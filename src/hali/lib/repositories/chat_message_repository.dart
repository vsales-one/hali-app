import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/item_listing_message.dart';
import 'package:hali/models/user_profile.dart';
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
    final user = await userRepository.getUserProfile();
    final activeUsers = await userRepository.getActiveUsers();

    await for (QuerySnapshot snap
        in fireStore.collection(ITEM_REQUEST_MESSAGES).orderBy("publishedAt").snapshots()) {
      try {
        final chats = snap.documents
            .map((doc) => ItemListingMessage.fromJson(doc.data))
            .toList();

        chats.forEach((chat) {
          chat.to.isActive = false;
          chat.from.isActive = false;
          if (chat.to.id != user.id) {
            activeUsers.forEach((temp) {
              if (temp.id == chat.to.id) {
                chat.to.isActive = true;
              }
            });
          } else {
            activeUsers.forEach((temp) {
              if (temp.id == chat.from.id) {
                chat.from.isActive = true;
              }
            });
          }
        });

        yield chats;
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> sendMessage(ChatMessage chat) async {
    try {            
      fireStore.collection(MESSAGES).add(chat.toJson());
      await saveRecentChat(chat);
      return true;
    } catch (e) {
      print("Exception $e");
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

  Future<bool> sendItemRequestMessage(String messageContent,
      ItemListingMessage itemRequestMessage) async {
    print(
        "Sending message to request item ${itemRequestMessage.itemId}-${itemRequestMessage.itemTitle}");
    try {      
      await fireStore.collection(ITEM_REQUEST_MESSAGES).add(itemRequestMessage.toJson());
      itemRequestMessage.content = messageContent;
      await fireStore.collection(MESSAGES).add(itemRequestMessage.toJson());
      return true;
    } catch (e) {
      print("Exception $e");
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

  static String filterVal(String val) {
    List<String> inCorrects = [":", "#", "\$", "[", "]", "."];
    String filtered = val;
    inCorrects.forEach((val) {
      filtered = filtered.replaceAll(val, "");
    });
    return filtered;
  }
}
