import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
            Card(
              color: Colors.teal.shade100,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(35))),
              child: Row(children: [
                const CircleAvatar(
                  backgroundColor: Colors.amber,
                  child: Icon(Icons.money),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                    "Total Spending: ${Provider.of<UserData>(context).totalSpending}")
              ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 60,
              child: Card(
                color: Theme.of(context).primaryColorLight,
                child: FutureBuilder(
                    future: Provider.of<UserData>(context)
                        .getHistoryBreakdown(context),
                    builder: (ctx, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      log("OK");
                      return SfCircularChart(series: <CircularSeries>[
                        PieSeries<ChartData, String>(
                            dataSource: snapshot.data,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) => data.y,
                            // Radius of pie
                            radius: '50%')
                      ]);
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
