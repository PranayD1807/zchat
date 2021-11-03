import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  // const ChatScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Chat'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (ctx, i) => Container(
          padding: EdgeInsets.all(8),
          child: Text('This Works'),
        ),
      ),
    );
  }
}
