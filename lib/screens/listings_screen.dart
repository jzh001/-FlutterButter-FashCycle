import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/screens/listing_detail_screen.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';
import 'package:flutterbutter/widgets/no_data_icon.dart';

class ListingsScreen extends StatefulWidget {
  const ListingsScreen({super.key});
  static const routeName = '/listings';

  @override
  State<ListingsScreen> createState() => _ListingsScreenState();
}

class _ListingsScreenState extends State<ListingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Listings"),
      ),
      drawer: const AppDrawer(),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Listings")
              .where("Status", isEqualTo: "Active")
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const NoDataIcon();
            }

            return GridView.count(
                crossAxisCount: 2,
                children: snapshot.data!.docs
                    .map((item) => MenuTile(
                        title: item["Title"],
                        coverImgLink: item["Image Link"],
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx2) => ListingDetailScreen(
                                  listItem: convertToItem(item))));
                        }))
                    .toList());
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed("/addListing");
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  ListItem convertToItem(QueryDocumentSnapshot item) {
    return ListItem(
        author: item["Author"],
        buyer: item["Buyer"],
        description: item["Description"],
        id: item.id,
        imageLink: item["Image Link"],
        price: item["Price"],
        status: item["Status"],
        title: item["Title"],
        type: item["Type"], material: item["Material"]);
  }
}

class MenuTile extends StatelessWidget {
  final String title;
  final String coverImgLink;
  final VoidCallback onTap;
  const MenuTile({
    super.key,
    required this.title,
    required this.coverImgLink,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 30,
        margin: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        color: Theme.of(context).primaryColorLight,
        child: LayoutBuilder(builder: (_, constraints) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: constraints.maxHeight * 0.65,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                  child: Image.network(
                    coverImgLink,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
