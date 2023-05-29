import 'package:flutter/material.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  //const MessageBubble({Key? key}) : super(key: key);

  final String message;
  final String name;

  const MessageBubble(this.message, this.name, {required Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isMe =
        (name == Provider.of<UserData>(context, listen: false).username);
    return Row(
      // so width is respected
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
              color: isMe ? Colors.green.shade200 : Colors.amber.shade200,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: !isMe
                    ? const Radius.circular(0)
                    : const Radius.circular(12),
                bottomRight: !isMe
                    ? const Radius.circular(12)
                    : const Radius.circular(0),
              )),
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                message,
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
