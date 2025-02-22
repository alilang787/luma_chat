import 'package:cloud_firestore/cloud_firestore.dart';

class ChatDataM {
  final String message;
  final String senderUid;
  final String receiverUid;
  final String senderUsername;
  final String receiverUsername;
  final Timestamp createdAt;
  ChatStatus status;
  DocumentReference<Map<String, dynamic>>? docRef;
  bool isRead;

  ChatDataM({
    required this.message,
    required this.senderUid,
    required this.receiverUid,
    required this.senderUsername,
    required this.receiverUsername,
    required this.createdAt,
    required this.status,
    this.docRef,
    bool? isRead,
  }) : this.isRead = isRead ?? false;
  factory ChatDataM.formDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> messageData = doc.data();
    final _status = ChatStatus.values[messageData['status']];
    return ChatDataM(
      message: messageData['message'],
      senderUid: messageData['senderUid'],
      receiverUid: messageData['receiverUid'],
      senderUsername: messageData['senderUsername'],
      receiverUsername: messageData['receiverUsername'],
      createdAt: messageData['createdAt'],
      status: _status,
      docRef: doc.reference,
      isRead: _status == ChatStatus.Read,
    );
  }
  factory ChatDataM.fromMap(Map chat) {
    return ChatDataM(
      message: chat['message'],
      senderUid: chat['senderUid'],
      receiverUid: chat['receiverUid'],
      senderUsername: chat['senderUsername'],
      receiverUsername: chat['receiverUsername'],
      createdAt: chat['createdAt'],
      status: ChatStatus.values[chat['status']],
      docRef: chat['docRef'],
    );
  }
}

enum ChatStatus {
  Sending,
  Uploaded,
  Delivered,
  Read,
}
