import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/screens/listing_detail_screen.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

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
      body: FutureBuilder(
          future: Provider.of<Listings>(context, listen: false).initListings(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final allListings = Provider.of<Listings>(ctx).getCurrentListings();

            return GridView.count(
                crossAxisCount: 2,
                children: allListings
                    .map((item) => MenuTile(
                        title: item.title,
                        coverImgLink: item.imageLink,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (ctx2) =>
                                  ListingDetailScreen(listItem: item)));
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
