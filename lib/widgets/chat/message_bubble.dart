import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';
import 'package:zchat/screens/image_screen.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String msgImageUrl;
  final bool isImage;
  final bool isMe;
  final String userImage;

  final Key key;
  // ignore: use_key_in_widget_constructors
  const MessageBubble(
      {required this.message,
      required this.userImage,
      required this.isMe,
      required this.isImage,
      required this.msgImageUrl,
      required this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          isImage ? CrossAxisAlignment.end : CrossAxisAlignment.center,
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
        isImage
            ? TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => ImageDetail(msgImageUrl),
                    ),
                  );
                },
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.6,
                      maxHeight: MediaQuery.of(context).size.height * 0.3),
                  decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.brown,
                    ),
                    child: FadeInImage(
                      fit: BoxFit.cover,
                      placeholder:
                          const AssetImage('lib/images/placeholder.jpg'),
                      image: NetworkImage(msgImageUrl),
                      fadeInDuration: const Duration(milliseconds: 300),
                      fadeOutDuration: const Duration(milliseconds: 100),
                    ),
                  ),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color:
                      !isMe ? Colors.brown[100] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: !isMe
                        ? const Radius.circular(15)
                        : const Radius.circular(20),
                    topRight: !isMe
                        ? const Radius.circular(20)
                        : const Radius.circular(15),
                    bottomLeft: !isMe
                        ? const Radius.circular(8)
                        : const Radius.circular(20),
                    bottomRight: !isMe
                        ? const Radius.circular(20)
                        : const Radius.circular(8),
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
