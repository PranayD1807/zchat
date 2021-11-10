import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zchat/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  const Messages(this.user2);
  final String user2;
  @override
  Widget build(BuildContext context) {
    final cUser = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(cUser)
          .collection('chats')
          .doc(user2)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (ctx,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        final uid = FirebaseAuth.instance.currentUser!.uid;
        if (chatSnapshot.data == null) {
          return Container();
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, i) => MessageBubble(
            message: chatDocs[i]['text'],
            userImage: chatDocs[i]['userImage'],
            isMe: chatDocs[i]['userId'] == uid ? true : false,
            msgImageUrl: chatDocs[i]['msgImgUrl'],
            isImage: chatDocs[i]['isImg'],
            key: ValueKey(
              chatDocs[i].id,
            ),
          ),
        );
      },
    );
  }
}
