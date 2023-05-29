import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ShoppingPieChart extends StatelessWidget {
  const ShoppingPieChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Theme.of(context).primaryColorLight,
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

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("No Data"));
              }

              return SfCircularChart(
                  title: ChartTitle(
                    text: 'Shopping Breakdown',
                    textStyle: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  series: <CircularSeries>[
                    PieSeries<ChartData, String>(
                      dataSource: getHistoryBreakdown(ctx, snapshot),
                      xValueMapper: (ChartData data, _) => data.x,
                      yValueMapper: (ChartData data, _) => data.y,
                      dataLabelMapper: (ChartData data, _) =>
                          "${data.x} (${data.y.toInt()})",
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        labelPosition: ChartDataLabelPosition.inside,
                        //labelAlignment: ChartAlignment.center,
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 9,
                        ),
                      ),
                    )
                  ]);
            }),
      ),
    );
  }

  List<ChartData> getHistoryBreakdown(BuildContext ctx,
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> data) {
    final elements = data.data!.docs.map((e) => e["Type"]).toList();
    //print("Elements" + elements.length.toString());
    var map = {};

    for (var x in elements) {
      map[x] = !map.containsKey(x) ? (1) : (map[x] + 1);
    }
    List<ChartData> ret = [];
    map.forEach((key, value) => ret.add(ChartData(key, value.toDouble())));
    //print("Ret is " + ret[0].x.toString() + ret[0].y.toString());
    return ret;
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
