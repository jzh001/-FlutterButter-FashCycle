// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:provider/provider.dart';

class ListingDetailScreen extends StatefulWidget {
  ListItem listItem;
  ListingDetailScreen({super.key, required this.listItem});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listItem.title),
      ),
      body: Column(
        children: [
          Image.network(
            widget.listItem.imageLink,
            fit: BoxFit.cover,
            width: 300,
            height: 300,
          ),
          Card(
            margin: const EdgeInsets.all(15.0),
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                    ),
                    Text(
                      widget.listItem.title,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      "By: ${widget.listItem.author}",
                      style: const TextStyle(fontStyle: FontStyle.italic),
                    ),
                    Text("Price: ${widget.listItem.price}",
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                    Text(widget.listItem.type),
                    Text(widget.listItem.description),
                  ]),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: const Text("Confirm Purchase"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                _purchaseItem();
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("Yes"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: const Text("No"),
                            ),
                          ],
                        ));
              },
              child: const Text("Buy Now")),
        ],
      ),
    );
  }

  Future<void> _purchaseItem() async {
    await Provider.of<UserData>(context, listen: false)
        .buyItem(widget.listItem.price)
        .then((value) => Provider.of<Listings>(context, listen: false)
            .buyItem(widget.listItem, context));
  }
}
