import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';

class UserData with ChangeNotifier {
  String username = "";
  String email = "";
  double currentSavings = 0;
  double totalSpending = 0;
  double carbonSavings = 0;
  double totalFabric = 0;

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
    totalFabric = userData["Total Fabric"].toDouble();
    log(carbonSavings.toString());
    log("Ok");
    notifyListeners();
  }

  Future<void> buyItem(ListItem listItem) async {
    totalSpending += listItem.price;
    carbonSavings +=
        typeToFabric(listItem.type) * materialToCarbon(listItem.material);
    totalFabric += typeToFabric(listItem.type);
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "Total Spending": totalSpending,
      "Carbon Savings": carbonSavings,
      "Total Fabric": totalFabric,
    });
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("History")
        .add({
      "id": listItem.id,
      "Timestamp": DateTime.now(),
      "Total Fabric": totalFabric,
      "Spending": totalSpending,
      "Carbon Savings": carbonSavings
    });
    notifyListeners();
  }

  static double typeToFabric(String type) {
    // in m^2
    switch (type) {
      case "Jacket":
        return 1.47 * 2;
      case "Pants":
        return (1.3 * 2 + 0.25) * 1.47;
      case "Shirt":
        return 0.91 * 2.4;
      case "Dress":
        return 6 * 1.47;
      default:
        return 0;
    }
  }

  static double materialToCarbon(String material) {
    // kg / m^2
    switch (material) {
      case "Cotton":
        return 8.3 / 2;
      case "Acrylic Fabric":
        return 11.53 / 2;
      case "Linen":
        return 4.5 / 2;
      case "Nylon":
        return 7.31 / 2;
      case "Silk":
        return 7.63 / 2;
      case "Wool":
        return 13.83 / 2;
      case "Polyester":
        return 6.4 / 2;
      default:
        return 0;
    }
  }
}
