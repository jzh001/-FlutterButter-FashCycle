// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:flutterbutter/screens/chat_screen.dart';
import 'package:provider/provider.dart';

class ListingDetailScreen extends StatefulWidget {
  ListItem listItem;
  bool isBuy = true;
  ListingDetailScreen({super.key, required this.listItem, this.isBuy = true});

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
                    Text("Price: ${widget.listItem.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                    Text(widget.listItem.type),
                    Text("Material: ${widget.listItem.material}"),
                    Text(widget.listItem.description),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Savings",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                        "Fabric Used: ${UserData.typeToFabric(widget.listItem.type).toStringAsFixed(2)} m^2"),
                    Text(
                        "CO2 Saved: ${(UserData.typeToFabric(widget.listItem.type) * UserData.materialToCarbon(widget.listItem.material)).toStringAsFixed(2)} kg"),
                  ]),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => ChatScreen(listItem: widget.listItem)));
                },
                child: const Text("Chat"),
              ),
              if (widget.isBuy)
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
                                    Navigator.of(ctx)
                                        .pushReplacementNamed('/listings');
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
                  child: const Text("Buy Now"),
                ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _purchaseItem() async {
    await Provider.of<UserData>(context, listen: false)
        .buyItem(widget.listItem)
        .then((value) => Provider.of<Listings>(context, listen: false)
            .buyItem(widget.listItem, context));
  }
}
