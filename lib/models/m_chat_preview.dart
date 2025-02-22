import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPreviewM {
  String uid;
  String username;
  String profileName;
  String? profilePicUrl;
  String lastMessage;
  DateTime createdAt;
  ChatPreviewM({
    required this.uid,
    required this.username,
    required this.profileName,
    required this.lastMessage,
    required this.createdAt,
    this.profilePicUrl,
  });

  factory ChatPreviewM.formDocument(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final Map<String, dynamic> previewData = doc.data();
    return ChatPreviewM(
      uid: previewData['uid'],
      username: previewData['username'],
      profileName: previewData['profileName'],
      lastMessage: previewData['lastMessage'],
      createdAt: previewData['createdAt'].toDate(),
      profilePicUrl: previewData['profileUrl'],
    );
  }
}
