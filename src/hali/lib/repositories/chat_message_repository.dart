import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hali/di/appModule.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/repositories/user_repository.dart';
import 'package:meta/meta.dart';

class ChatMessageRepository {
  static const String CHATS = "chats",
      RECENT = "recentChats",
      MESSAGES = "messages",
      ITEM_REQUEST_MESSAGES = "itemRequestMessages";

  final UserRepository userRepository;
  final Firestore fireStore;

  ChatMessageRepository(
      {@required this.userRepository, @required this.fireStore});

  Stream<List<ItemListingMessage>> getItemRequestMessages() async* {
    final user = await userRepository.getCurrentUserProfileFull();

    // query request messages belong to item owner
    await for (QuerySnapshot snap in fireStore
        .collection(ITEM_REQUEST_MESSAGES)
        .where("to.userId", isEqualTo: user.email)
        .where("status", isEqualTo: "Open")
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

    // query request messages belong to requestor
    await for (QuerySnapshot snap in fireStore
        .collection(ITEM_REQUEST_MESSAGES)
        .where("from.userId", isEqualTo: user.email)
        .where("status", isEqualTo: "Open")
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
      await saveRecentChat(chat);
      return true;
    } catch (e) {
      logger.e("Exception $e");
      return false;
    }
  }

  Future saveRecentChat(ChatMessage chat) async {
    List<String> ids = [chat.from.email, chat.to.email];
    for (String id in ids) {
      Query query = fireStore
          .collection(RECENT)
          .document(id)
          .collection("history")
          .where("groupId", isEqualTo: chat.groupId);
      QuerySnapshot documents = await query.getDocuments();
      if (documents.documents.length != 0) {
        DocumentSnapshot documentSnapshot = documents.documents[0];
        documentSnapshot.reference.setData(chat.toJson());
      } else {
        fireStore
            .collection(RECENT)
            .document(id)
            .collection("history")
            .add(chat.toJson());
      }
    }
  }

  Future<bool> sendItemRequestMessage(
      String messageContent, ItemListingMessage itemRequestMessage) async {
    print(
        "Sending message to request item ${itemRequestMessage.itemId}-${itemRequestMessage.itemTitle}");
    try {
      await fireStore
          .collection(ITEM_REQUEST_MESSAGES)
          .add(itemRequestMessage.toJson());
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
    final snapShot = await fireStore
        .collection(ITEM_REQUEST_MESSAGES)
        .where("itemId", isEqualTo: itemRequestMessage.itemId)
        .snapshots()
        .first;

    if (snapShot.documents.first != null) {
      final data = {"status": ItemRequestMessageStatus.Closed.toString()};

      await fireStore
          .collection(ITEM_REQUEST_MESSAGES)
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

      await updatePostStatus(itemRequestMessage.itemId, ItemRequestMessageStatus.Closed.toString());

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
      final data = {"status": ItemRequestMessageStatus.Open.toString()};

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

      await updatePostStatus(itemRequestMessage.itemId, ItemRequestMessageStatus.Open.toString());

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
