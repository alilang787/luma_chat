import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/models/m_personal_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

final personalData =
    StateNotifierProvider<personalDataNotify, PersonalDataM>((ref) {
  return personalDataNotify();
});

class personalDataNotify extends StateNotifier<PersonalDataM> {
  final user = FirebaseAuth.instance.currentUser!;
  personalDataNotify()
      : super(PersonalDataM(
          id: FirebaseAuth.instance.currentUser!.uid,
          username: 'username',
        ));

  //  ------------- set data -----------------
  void getData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username') ?? 'username';

    final personalData = PersonalDataM(
      username: username,
      id: user.uid,
      email: user.email,
      name: user.displayName,
    );
    state = personalData;

    String? profileUrl;
    String? dob;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (doc.exists) {
      profileUrl=doc.data()?['profileUrl'];
      dob = doc.data()?['dob'];
    }

    final updatedData = state;
    updatedData.dob = dob;
    updatedData.profileUrl = profileUrl;
  }
}


