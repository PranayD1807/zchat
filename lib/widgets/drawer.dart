import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class XDrawer extends StatelessWidget {
  // const XDrawer({ Key? key }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    Future<String> getData() async {
      final userData =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final userImage = userData['image_url'];
      return userImage;
    }

    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('users').doc(uid).snapshots(),
        builder: (ctx,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return Drawer(
            child: Scaffold(
              appBar: AppBar(),
              body: Column(
                children: <Widget>[
                  Container(
                    height: 220,
                    width: double.infinity,
                    color: Colors.brown,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 72,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(
                              snapshot.data!['image_url'],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          snapshot.data!['username'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email: ' + snapshot.data!['email'],
                          style: const TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                  ListTile(
                    title: const Text('Log Out'),
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                    },
                    trailing: const Icon(
                      Icons.exit_to_app,
                      color: Colors.brown,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
