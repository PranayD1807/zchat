import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:zchat/widgets/pickers/chat_image_picker.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({required this.user2});
  final String user2;
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  var _enteredMessage = '';
  bool _sendingImg = false;
  File _receivedImg = File('');

  // receiving img
  void loadImg(File img) async {
    setState(() {
      _receivedImg = img;
      _sendingImg = true;
    });
  }

  void _sendImgMsg() async {
    final user = await FirebaseAuth.instance.currentUser;
    final user1Data = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final user2Data = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user2)
        .get();
    try {
      // getting ref
      final ref = FirebaseStorage.instance
          .ref()
          .child('Img_msgs')
          .child(user.uid + DateTime.now().toString() + '.jpg');
      // putting file
      await ref.putFile(_receivedImg).whenComplete(() => null);
      // gettting url
      final imgUrl = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(widget.user2)
          .collection('messages')
          .add(
        {
          'text': '',
          'isImg': true,
          'msgImgUrl': imgUrl,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userImage': user1Data['image_url'],
        },
      );
      // updating timestamp
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(widget.user2)
          .update({
        'email': user2Data['email'],
        'image_url': user2Data['image_url'],
        'username': user2Data['username'],
        'timestamp': Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user2)
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add(
        {
          'text': '',
          'isImg': true,
          'msgImgUrl': imgUrl,
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userImage': user1Data['image_url'],
        },
      );
      // updating timestamp
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user2)
          .collection('chats')
          .doc(user.uid)
          .update({
        'email': user1Data['email'],
        'image_url': user1Data['image_url'],
        'username': user1Data['username'],
        'timestamp': Timestamp.now(),
      });

      setState(() {
        _sendingImg = false;
        _receivedImg = File('');
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to upload Image')));
    }
  }

  // sending text message
  void _sendMessage() async {
    if (_enteredMessage == '') {
      return;
    }
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final user1Data = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    final user2Data = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user2)
        .get();
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(widget.user2)
          .collection('messages')
          .add(
        {
          'text': _enteredMessage,
          'isImg': false,
          'msgImgUrl': '',
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userImage': user1Data['image_url'],
        },
      );
      // updating timestamp
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('chats')
          .doc(widget.user2)
          .update({
        'email': user2Data['email'],
        'image_url': user2Data['image_url'],
        'username': user2Data['username'],
        'timestamp': Timestamp.now(),
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user2)
          .collection('chats')
          .doc(user.uid)
          .collection('messages')
          .add(
        {
          'text': _enteredMessage,
          'isImg': false,
          'msgImgUrl': '',
          'createdAt': Timestamp.now(),
          'userId': user.uid,
          'userImage': user1Data['image_url'],
        },
      );
      // updating timestamp
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.user2)
          .collection('chats')
          .doc(user.uid)
          .update({
        'email': user1Data['email'],
        'image_url': user1Data['image_url'],
        'username': user1Data['username'],
        'timestamp': Timestamp.now(),
      });
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
      margin: const EdgeInsets.only(
        top: 8,
      ),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.brown[400],
      ),
      child: _sendingImg
          ? Stack(
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.5,
                  ),
                  // height: 300,
                  width: double.infinity,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Image(image: FileImage(_receivedImg))),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: FloatingActionButton(
                    key: Key('ImgDelete'),
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      setState(() {
                        _sendingImg = false;
                        _receivedImg = File('');
                      });
                    },
                    child: const Icon(
                      Icons.delete,
                    ),
                  ),
                ),
                Positioned(
                  key: Key('ImgSend'),
                  bottom: 10,
                  right: 10,
                  child: FloatingActionButton(
                    backgroundColor: Colors.deepOrange,
                    onPressed: () {
                      _sendImgMsg();
                    },
                    child: const Icon(
                      Icons.send,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: <Widget>[
                ChatImgPicker(loadImg),
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
