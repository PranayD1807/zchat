import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({required this.user2});
  final String user2;
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';
  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    try {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(widget.user2)
          .collection('messages')
          .add(
        {
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userImage': userData['image_url'],
        },
      );
      FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user2)
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add(
        {
          'text': _enteredMessage,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userImage': userData['image_url'],
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Something went wrong.'),
        ),
      );
    }
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown[400],
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(5),
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.photo,
              size: 30,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Send a message',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: () {
              _enteredMessage.trim().isEmpty ? null : _sendMessage();
            },
            icon: const Icon(
              Icons.send,
              size: 30,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
