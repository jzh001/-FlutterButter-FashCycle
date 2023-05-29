import 'package:flutter/material.dart';
import 'package:flutterbutter/charts/carbon_line_chart.dart';
import 'package:flutterbutter/charts/shopping_pie_chart.dart';
import 'package:flutterbutter/charts/fabric_pie_chart.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green.shade200,
      ),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.2,
              decoration: BoxDecoration(
                color: Colors.green.shade200,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
              child: Center(
                child: Text(
                  "FashCycle",
                  style: Theme.of(context).textTheme.displaySmall,
                ),
              )),
          Expanded(
            child: SizedBox(
              child: ListView(children: [
                CarbonLineChart(
                  variable: "Carbon Savings",
                ),
                const Row(children: [
                  FabricPieChart(),
                  ShoppingPieChart(),
                ]),
                CarbonLineChart(
                  variable: "Total Fabric",
                ),
                CarbonLineChart(
                  variable: "Spending",
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
