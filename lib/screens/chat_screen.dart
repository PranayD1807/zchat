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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              // titlePadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              centerTitle: true,
              title: Text(
                uName,
              ),
              background: Image(
                fit: BoxFit.cover,
                image: NetworkImage(uImageUrl),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () {
                    _clearChat();
                  },
                  icon: const Icon(
                    Icons.delete_sweep,
                    size: 35,
                  ),
                ),
              )
            ],
          ),
          SliverFillRemaining(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/images/img2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              // padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Messages(user2),
                  ),
                  NewMessage(user2: user2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
