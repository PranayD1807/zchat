import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zchat/widgets/chat/messages.dart';
import 'package:zchat/widgets/chat/new_message.dart';
import 'package:zchat/widgets/drawer.dart';

class ChatScreen extends StatelessWidget {
  final String user2;
  final String uImageUrl;
  final String uName;
  ChatScreen(
      {required this.user2, required this.uImageUrl, required this.uName});
  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser!.uid;
    void _clearChat() async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cUser)
          .collection('chats')
          .doc(user2)
          .collection('messages')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user2)
          .collection('chats')
          .doc(cUser)
          .collection('messages')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(uImageUrl),
              ),
            ),
            const SizedBox(
              width: 30,
            ),
            Text(uName),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
              onPressed: () {
                _clearChat();
              },
              icon: const Icon(
                Icons.clear_all,
                size: 35,
              ),
            ),
          )
        ],
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://www.ixpap.com/images/2021/02/chocolate-wallpaper-ixpap-10.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Messages(user2),
            ),
            NewMessage(user2: user2),
          ],
        ),
      ),
    );
  }
}
