import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class NewMessage extends StatefulWidget {
  ListItem listItem;
  NewMessage({super.key, required this.listItem});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();

  var _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();

    FirebaseFirestore.instance
        .collection("Listings")
        .doc(widget.listItem.id)
        .collection("Chat")
        .add({
      'text': _enteredMessage,
      'createdAt': Timestamp.now(),
      'username': Provider.of<UserData>(context, listen: false).username,
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(15.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  label: Text('Send a message'),
                ),
                onChanged: (value) {
                  setState(() {
                    _enteredMessage = value;
                  });
                },
              ),
            ),
            IconButton(
              onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
