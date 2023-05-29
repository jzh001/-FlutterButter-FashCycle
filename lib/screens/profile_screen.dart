import 'package:flutter/material.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const routeName = '/profile';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person),
                ),
                const SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Provider.of<UserData>(context).username,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(Provider.of<UserData>(context).email),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Card(
              color: Colors.teal.shade100,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child: Row(children: [
                const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.emoji_events),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    "Total Carbon Savings: ${Provider.of<UserData>(context).carbonSavings}")
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
