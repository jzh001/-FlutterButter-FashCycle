import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:provider/provider.dart';

class UserData with ChangeNotifier {
  String username = "";
  String email = "";
  double currentSavings = 0;
  double totalSpending = 0;
  double carbonSavings = 0;

  Future<void> initUser() async {
    final userData = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    username = userData["Username"];
    email = userData["Email"];
    currentSavings = userData["Current Savings"].toDouble();
    totalSpending = userData["Total Spending"].toDouble();
    carbonSavings = userData["Carbon Savings"].toDouble();
    log(carbonSavings.toString());
    log("Ok");
    notifyListeners();
  }

  Future<void> buyItem(ListItem listItem) async {
    totalSpending += listItem.price;
    carbonSavings += 1;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "Total Spending": totalSpending,
      "Carbon Savings": carbonSavings,
    });
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("History")
        .add({"id": listItem.id, "Timestamp": DateTime.now()});
    notifyListeners();
  }

  Future<List<ChartData>> getHistoryBreakdown(BuildContext ctx) async {
    print("Function run");
    final history = await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("History")
        .get();
    print("OK2");
    final myTransactions = history.docs.map(
        (e) => Provider.of<Listings>(ctx, listen: false).retrieveByID(e["id"]));
    final elements = myTransactions.map((item) => item.type);

    var map = {};

    for (var x in elements) {
      map[x] = !map.containsKey(x) ? (1) : (map[x] + 1);
    }
    List<ChartData> ret = [];
    map.forEach((key, value) => ret.add(ChartData(key, value.toDouble())));
    print("RET");
    print(ret);
    print(ret.length);

    return ret;
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
