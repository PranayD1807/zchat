import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String userImage;

  final Key key;
  // ignore: use_key_in_widget_constructors
  const MessageBubble(this.message, this.userImage, this.isMe,
      {required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        if (!isMe)
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.brown[100],
            child: CircleAvatar(
              radius: 13,
              backgroundImage: NetworkImage(
                userImage,
              ),
            ),
          ),
        Container(
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: !isMe ? Colors.brown[100] : Theme.of(context).accentColor,
            borderRadius: BorderRadius.only(
              topLeft:
                  !isMe ? const Radius.circular(15) : const Radius.circular(20),
              topRight:
                  !isMe ? const Radius.circular(20) : const Radius.circular(15),
              bottomLeft:
                  !isMe ? const Radius.circular(8) : const Radius.circular(20),
              bottomRight:
                  !isMe ? const Radius.circular(20) : const Radius.circular(8),
            ),
          ),
          // width: 140,

          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 13,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Text(
            message,
            style: TextStyle(
              fontSize: 18,
              color: !isMe
                  ? Colors.brown[800]
                  : Theme.of(context).accentTextTheme.headline1!.color,
            ),
          ),
        ),
      ],
    );
  }
}
