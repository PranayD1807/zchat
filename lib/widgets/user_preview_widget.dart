import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPreview extends StatelessWidget {
  UserPreview(
      {required this.u2email,
      required this.u2image,
      required this.u2username,
      required this.user2Id});
  String u2email;
  String u2username;
  String u2image;
  String user2Id;
  @override
  Widget build(BuildContext context) {
    void _addFriend(String user2Id) async {
      final user = await FirebaseAuth.instance.currentUser;
      final user1Data = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('chats')
            .doc(user2Id)
            .set({
          'email': u2email,
          'image_url': u2image,
          'username': u2username,
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user2Id)
            .collection('chats')
            .doc(user.uid)
            .set({
          'email': user1Data['email'],
          'image_url': user1Data['image_url'],
          'username': user1Data['username'],
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add as a friend.'),
          ),
        );
      }
    }

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(u2image),
      ),
      title: Text(u2username),
      subtitle: Text(u2email),
      trailing: IconButton(
        onPressed: () {
          _addFriend(user2Id);
        },
        icon: const Icon(
          Icons.message,
          size: 30,
        ),
      ),
    );
  }
}
