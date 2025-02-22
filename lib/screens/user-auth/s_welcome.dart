import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
        actions: [
          IconButton(
              onPressed: () => FirebaseAuth.instance.signOut(),
              icon: Icon(Icons.logout))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage: NetworkImage(
                FirebaseAuth.instance.currentUser!.photoURL!,
              ),
            ),
            Gap(16),
            Text(
              FirebaseAuth.instance.currentUser!.displayName!,
              style: TextStyle(fontSize: 28),
            )
          ],
        ),
      ),
    );
  }
}
