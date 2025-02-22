import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/m_chat_data.dart';
import '/utils/utils.dart';

class chatDataNotify extends StateNotifier<List<ChatDataM>> {
  chatDataNotify() : super([]);

  void clearData() {
    state = [];
  }

  void updateChatOjb(ChatDataM chat) {
    List<ChatDataM> chatList = state;
    ChatDataM chatObj = chatList.firstWhere((e) => e == chat);
    chatObj.isRead = true;
  }

  // >>>>>>>>>>>>>> Load Messages from Server <<<<<<<<<<<<<<<<<<

  Future<void> loadMessages(String chatId, String currUid) async {
    FirebaseFirestore.instance
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        final chats = snapshot.docs.map((doc) {
          final chat = ChatDataM.formDocument(doc);

          if (!chat.isRead && chat.senderUid != currUid) {
            doc.reference.update({
              'status': ChatStatus.Delivered.index,
            });
          }

          return chat;
        }).toList();
        state = chats;
      }
    });
  }

  // >>>>>>>>>>>>>>>>>> Send New Message <<<<<<<<<<<<<<<<<<<<

  void sendMessage({
    required String message,
    required String uniqueUid,
    required String currUname,
    required String receiverUid,
    required String recUname,
    required String recProfileName,
    required String recProfileUrl,
  }) async {
    final currentUser = FirebaseAuth.instance.currentUser!;

    // ------------------- update local data ----------------------
    final Map<String, dynamic> chatMap = {
      'message': message,
      'senderUid': currentUser.uid,
      'receiverUid': receiverUid,
      'senderUsername': currUname,
      'receiverUsername': recUname,
      'createdAt': Timestamp.now(),
      'status': ChatStatus.Sending.index,
      'docRef': null,
    };

    final chatObj = ChatDataM.fromMap(chatMap);

    state = [chatObj, ...state];

    // ------------- upload message on server ----------------
    printLog(v: 'message is being upload');
    FirebaseFirestore.instance
        .collection('chats')
        .doc(uniqueUid)
        .collection('messages')
        .add(chatMap)
        .then((DocumentReference docRef) => {
              docRef.update({
                'status': currentUser.uid != receiverUid
                    ? ChatStatus.Uploaded.index
                    : ChatStatus.Read.index,
              })
            });

    // ------------ update chats previews on server ---------------

    // ------- for sender ---------
    await FirebaseFirestore.instance
        .collection('open-chats')
        .doc(currentUser.uid)
        .collection('users')
        .doc(receiverUid)
        .set({
      'uid': receiverUid,
      'username': recUname,
      'profileName': recProfileName,
      'profileUrl': recProfileUrl,
      'lastMessage': message,
      'createdAt': Timestamp.now(),
    });

    // ------ for receiver ---------
    await FirebaseFirestore.instance
        .collection('open-chats')
        .doc(receiverUid)
        .collection('users')
        .doc(currentUser.uid)
        .set({
      'uid': currentUser.uid,
      'username': currUname,
      'profileName': currentUser.displayName,
      'profileUrl': currentUser.photoURL,
      'lastMessage': message,
      'createdAt': Timestamp.now(),
    });
  }
}

final chatDataProvider =
    StateNotifierProvider<chatDataNotify, List<ChatDataM>>((ref) {
  return chatDataNotify();
});
