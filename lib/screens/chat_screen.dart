import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/widgets/chat/messages.dart';
import 'package:flutterbutter/widgets/chat/new_message.dart';

class ChatScreen extends StatelessWidget {
  //const ChatScreen({ Key? key }) : super(key: key);

  final ListItem listItem;

  const ChatScreen({Key? key, required this.listItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat - ${listItem.title}")),
      body: Column(
        children: [
          Expanded(child: Messages(listItem)),
          NewMessage(listItem: listItem),
        ],
      ),
    );
  }
}
