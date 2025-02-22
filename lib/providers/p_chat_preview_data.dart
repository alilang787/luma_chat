import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/m_chat_preview.dart';

class ChatPreviewDataNotify extends StateNotifier<List<ChatPreviewM>?> {
  ChatPreviewDataNotify() : super(null); // Use null to indicate loading

  StreamSubscription<QuerySnapshot>? _subscription;

  void loadChatPreviews() {
    final id = FirebaseAuth.instance.currentUser?.uid;
    if (id == null) {
      state = [];
      return;
    }

    _subscription?.cancel(); // Cancel any previous subscription

    _subscription = FirebaseFirestore.instance
        .collection('open-chats')
        .doc(id)
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        final previews = snapshot.docs.map((doc) {
          return ChatPreviewM.formDocument(doc);
        }).toList();
        state = previews;
      } else {
        state = [];
      }
    }, onError: (error) {
      state = [];
    });
  }

  void clearChatPreviews() {
    _subscription?.cancel();
    _subscription = null;
    state = []; // Clear chat previews
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final chatPreviewData =
    StateNotifierProvider<ChatPreviewDataNotify, List<ChatPreviewM>?>((ref) {
  return ChatPreviewDataNotify();
});
