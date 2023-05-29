import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: must_be_immutable
class CarbonLineChart extends StatefulWidget {
  String variable;

  CarbonLineChart({required this.variable, super.key});

  @override
  State<CarbonLineChart> createState() => _CarbonLineChartState();
}

class _CarbonLineChartState extends State<CarbonLineChart> {
  List<ChartData> chartData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final data = await fetchDataFromFirestore();
    setState(() {
      chartData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: Theme.of(context).primaryColorLight,
        child: chartData.isNotEmpty
            ? SfCartesianChart(
                title: ChartTitle(text: "${widget.variable} Over Time"),
                primaryXAxis: DateTimeAxis(),
                series: <ChartSeries>[
                  LineSeries<ChartData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (ChartData data, _) => data.timestamp,
                    yValueMapper: (ChartData data, _) => data.value,
                  ),
                ],
              )
            : const Center(
                child: Text("No Data"),
              ),
      ),
    );
  }

  Future<List<ChartData>> fetchDataFromFirestore() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("History")
        .orderBy("Timestamp")
        .get();

    return snapshot.docs.map((doc) {
      final timestamp = (doc.data()['Timestamp'] as Timestamp).toDate();
      final value = doc.data()[widget.variable] as double;
      return ChartData(timestamp, value);
    }).toList();
  }
}

class ChartData {
  final DateTime timestamp;
  final double value;

  ChartData(this.timestamp, this.value);
}
