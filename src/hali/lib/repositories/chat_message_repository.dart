import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hali/models/chat_message.dart';
import 'package:hali/models/user_profile.dart';
import 'package:hali/repositories/user_repository.dart';

class ChatMessageRepository {
  static const String CHATS = "chats",
      RECENT = "recentChats",
      MESSAGES = "messages";

  static Stream<List<ChatMessage>> getChats() async* {
    final firestore = Firestore.instance;
    final user = await UserRepository.getUserProfile();    
    List<UserProfile> activeUsers = await UserRepository.getActiveUsers();
    await for (QuerySnapshot snap in firestore
        .collection(RECENT)
        .document(user.id)
        .collection("history")
        .snapshots()) {
      try {        
        List<ChatMessage> chats = snap.documents
            .map((doc) =>
                ChatMessage.fromJson(doc.data))
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

  static Future<bool> sendMessage(ChatMessage chat) async {
    try {
      Firestore fireStore = Firestore.instance;
      String id = getUniqueId(chat.from.id, chat.to.id);
      print("ID $id");
      chat.groupId = id;
      fireStore.collection(MESSAGES).add(chat.toJson());
      await saveRecentChat(chat);
      return true;
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }

  static Future saveRecentChat(ChatMessage chat) async {
    List<String> ids = [chat.from.id, chat.to.id];
    for (String id in ids) {
      Firestore fireStore = Firestore.instance;
      Query query = fireStore
          .collection(RECENT)
          .document(id)
          .collection("history")
          .where("groupId", isEqualTo: getUniqueId(chat.from.id, chat.to.id));
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

  static String getUniqueId(String i1, String i2) {
    if (i1.compareTo(i2) <= -1) {
      return i1 + i2;
    } else {
      return i2 + i1;
    }
  }

  static Stream<List<ChatMessage>> listenChat(
      UserProfile from, UserProfile to) async* {
    Firestore firestore = Firestore.instance;
    await for (QuerySnapshot snap in firestore
        .collection("messages")
        .where("groupId",
            isEqualTo: getUniqueId(
              from.id,
              to.id,
            ))
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
