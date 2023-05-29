import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:flutterbutter/screens/listing_detail_screen.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class PastTransactionsScreen extends StatelessWidget {
  const PastTransactionsScreen({super.key});

  static const routeName = "/history";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("History")),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Listings")
              .where("Buyer",
                  isEqualTo:
                      Provider.of<UserData>(context, listen: false).username)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData) {
              return const Center(
                child: Text("No Data Found"),
              );
            }
            
            return ListView(
              children: snapshot.data!.docs.map((e) {
                return Card(
                  color: Theme.of(context).primaryColorLight,
                  child: SizedBox(
                    height: 80,
                    child: Center(
                      child: ListTile(
                        title: Text(e["Title"]),
                        subtitle: Text(
                            "${(e["Timestamp"] as Timestamp).toDate()}\n${e["Type"]}"),
                        trailing: CircleAvatar(
                            radius: 30, child: Text("\$${e["Price"]}")),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx2) => ListingDetailScreen(
                                  listItem: convertToItem(e), isBuy: false)));
                        },
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
  ListItem convertToItem(QueryDocumentSnapshot item) {
    return ListItem(author: item["Author"], buyer: item["Buyer"], description: item["Description"], id: item.id, imageLink: item["Image Link"], price: item["Price"], status: item["Status"], title: item["Title"], type: item["Type"]);
  }
}
