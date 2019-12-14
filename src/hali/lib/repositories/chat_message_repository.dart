import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:hali/config/application.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class ChatMessageRepository {
  static const String CHATS = "chats",
      RECENT = "recentChats",
      MESSAGES = "messages",
      ITEM_REQUEST_MESSAGES = "itemRequestMessages",
      HISTORY = "history";

  final UserRepository userRepository;
  final Firestore fireStore;

  ChatMessageRepository({
    @required this.userRepository,
    @required this.fireStore,
  });

  Stream<List<ItemListingMessage>> getItemRequestMessages() async* {
    final user = await userRepository.getCurrentUserProfileFull();

    await for (QuerySnapshot snap in fireStore
        .collection(ITEM_REQUEST_MESSAGES)
        .document(user.email)
        .collection(HISTORY)        
        .orderBy("publishedAt")
        .snapshots()) {
      try {
        final chats = snap.documents
            .map((doc) => ItemListingMessage.fromJson(doc.data))
            .toList();
        yield chats;
      } catch (e) {
        logger.e(e);
      }
    }
  }

  Future<bool> sendMessage(ChatMessage chat) async {
    try {
      fireStore.collection(MESSAGES).add(chat.toJson());
      return true;
    } catch (e) {
      logger.e("Exception $e");
      return false;
    }
  }

  Future<bool> sendItemRequestMessage(
      String messageContent, ItemListingMessage itemRequestMessage) async {
    print(
        "Sending message to request item ${itemRequestMessage.itemId}-${itemRequestMessage.itemTitle}");
    assert(itemRequestMessage.from.email.isNotEmpty);
    assert(itemRequestMessage.to.email.isNotEmpty);

    try {
      // Add link message between requestor and item owner
      List<String> ids = [
        itemRequestMessage.from.email,
        itemRequestMessage.to.email
      ];
      for (String id in ids) {
        Query query = fireStore
            .collection(ITEM_REQUEST_MESSAGES)
            .document(id)
            .collection(HISTORY)
            .where("groupId", isEqualTo: itemRequestMessage.groupId);
        QuerySnapshot documents = await query.getDocuments();
        if (documents.documents.length != 0) {
          DocumentSnapshot documentSnapshot = documents.documents[0];
          documentSnapshot.reference.setData(itemRequestMessage.toJson());
        } else {
          fireStore
              .collection(ITEM_REQUEST_MESSAGES)
              .document(id)
              .collection(HISTORY)
              .add(itemRequestMessage.toJson());
        }
      }

      // add first hint message
      itemRequestMessage.content = messageContent;
      await fireStore.collection(MESSAGES).add(itemRequestMessage.toJson());
      return true;
    } catch (e) {
      logger.e("Exception $e");
      return false;
    }
  }

  Stream<List<ChatMessage>> listenChat(String chatGroupId) async* {
    await for (QuerySnapshot snap in fireStore
        .collection("messages")
        .where("groupId", isEqualTo: chatGroupId)
        .orderBy("publishedAt")
        .snapshots()) {
      try {
        List<ChatMessage> chats = snap.documents
            .map((doc) =>
                ChatMessage.fromJson(Map<String, dynamic>.from(doc.data)))
            .toList();
        yield chats;
      } catch (e) {
        print(e);
      }
    }
  }

  /// confirm item pick up and close the post
  Future<bool> confirmItemPickupAndClosePost(
      ItemListingMessage itemRequestMessage) async {
    final currentUserEmail = Application.currentUser.email;
    final snapShot = await fireStore
        .collection(ITEM_REQUEST_MESSAGES)
        .document(currentUserEmail)
        .collection(HISTORY)
        .where("itemId", isEqualTo: itemRequestMessage.itemId)
        .getDocuments();

    if (snapShot.documents.first != null) {
      final data = {"status": EnumToString.parse(ItemRequestMessageStatus.Closed)};

      await fireStore
          .collection(ITEM_REQUEST_MESSAGES)
          .document(currentUserEmail)
          .collection(HISTORY)
          .document(snapShot.documents.first.documentID)
          .setData(data, merge: true);

      // send message to requestor
      final toRequestorMessage = ChatMessage.fromNamed(
          content:
              "${itemRequestMessage.from.firstName} đã xác nhận bạn nhận được quà",
          from: itemRequestMessage.from,
          to: itemRequestMessage.to,
          isSeen: false,
          publishedAt: DateTime.now(),
          groupId: itemRequestMessage.groupId);

      await fireStore.collection(MESSAGES).add(toRequestorMessage.toJson());

      await updatePostStatus(itemRequestMessage.itemId,
          EnumToString.parse(ItemRequestMessageStatus.Closed));

      return true;
    }

    return false;
  }

  Future<bool> updatePostStatus(String id, String status) async {
    try {      
      final docRef = fireStore.collection("itemposts").document(id);
      final data = {"status": status};
      await docRef.updateData(data);
      return true;
    } catch (_) {
      return false;
    }
  }

  /// Cancel item pickup and reopen post
  Future<bool> cancelItemPickupAndReopenPost(
      ItemListingMessage itemRequestMessage) async {
    final snapShot = await fireStore
        .collection(ITEM_REQUEST_MESSAGES)
        .where("itemId", isEqualTo: itemRequestMessage.itemId)
        .snapshots()
        .first;

    if (snapShot.documents.first != null) {
      final data = {"status": EnumToString.parse(ItemRequestMessageStatus.Open)};

      await fireStore
          .collection(ITEM_REQUEST_MESSAGES)
          .document(snapShot.documents.first.documentID)
          .setData(data, merge: true);

      // send message to requestor
      final toRequestorMessage = ChatMessage.fromNamed(
          content:
              "${itemRequestMessage.from.firstName} đã huỷ xác nhận cho bạn được nhận quà",
          from: itemRequestMessage.from,
          to: itemRequestMessage.to,
          isSeen: false,
          publishedAt: DateTime.now(),
          groupId: itemRequestMessage.groupId);

      await fireStore.collection(MESSAGES).add(toRequestorMessage.toJson());

      await updatePostStatus(
          itemRequestMessage.itemId, EnumToString.parse(ItemRequestMessageStatus.Open));

      return true;
    }

    return false;
  }

  static String filterVal(String val) {
    List<String> inCorrects = [":", "#", "\$", "[", "]", "."];
    String filtered = val;
    inCorrects.forEach((val) {
      filtered = filtered.replaceAll(val, "");
    });
    return filtered;
  }
}
