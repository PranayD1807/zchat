import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zchat/screens/chat_screen.dart';

class Contacts extends StatefulWidget {
  // const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  final cUser = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    void _deleteFriend(String uid) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cUser)
          .collection('chats')
          .doc(uid)
          .delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(cUser)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Contact deleted from your list.'),
        ),
      );
    }

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(cUser)
          .collection('chats')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder:
          (ctx, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == null) {
          return const Center(
            child: Text('Add Friends'),
          );
        }
        final userDocs = snapshot.data!.docs;
        return Padding(
          padding: const EdgeInsets.only(top: 70, left: 8, right: 8),
          child: ListView.builder(
            itemCount: userDocs.length,
            itemBuilder: (ctx, i) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(userDocs[i]['image_url']),
                ),
                title: Text(userDocs[i]['username']),
                subtitle: Text(
                  userDocs[i]['email'],
                  overflow: TextOverflow.fade,
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ChatScreen(
                        user2: userDocs[i].id,
                        uImageUrl: userDocs[i]['image_url'],
                        uName: userDocs[i]['username'],
                      ),
                    ),
                  );
                },
                trailing: IconButton(
                  onPressed: () {
                    _deleteFriend(userDocs[i].id);
                  },
                  icon: const Icon(
                    Icons.delete,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
