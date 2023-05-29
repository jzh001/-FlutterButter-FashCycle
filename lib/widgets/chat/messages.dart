import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/widgets/chat/message_bubble.dart';

class Messages extends StatelessWidget {
  final ListItem listItem;

  const Messages(this.listItem, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("Listings")
          .doc(listItem.id)
          .collection("Chat")
          .orderBy('createdAt', descending: true)
          .limit(300)
          .snapshots(),
      builder: (BuildContext ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final chatDocs = chatSnapshot.data!.docs;
        //log(user!.uid);
        //log(chatDocs[0]['userId']);
        return ListView.builder(
          itemBuilder: (ctx, idx) => MessageBubble(
            chatDocs[idx]['text'],
            chatDocs[idx]['username'],
            key: ValueKey(chatDocs[idx]
                .id), //ensures flutter is efficiently updating the list
          ),
          itemCount: chatDocs.length,
          reverse: true,
        );
      },
    );
  }
}
