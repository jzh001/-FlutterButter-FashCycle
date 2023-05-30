import 'package:flutter/material.dart';
import 'package:flutterbutter/charts/carbon_line_chart.dart';
import 'package:flutterbutter/charts/shopping_pie_chart.dart';
import 'package:flutterbutter/charts/fabric_pie_chart.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:flutterbutter/widgets/app_drawer.dart';
import 'package:flutterbutter/widgets/no_data_icon.dart';
import 'package:provider/provider.dart';

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
        mainAxisSize: MainAxisSize.min,
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
          Provider.of<UserData>(context, listen: false).carbonSavings != 0
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: SizedBox(
                    child: ListView(children: [
                      CarbonLineChart(
                        variable: "Carbon Savings",
                      ),
                      const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
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
                )
              : const NoDataIcon(),
        ],
      ),
    );
  }
}
