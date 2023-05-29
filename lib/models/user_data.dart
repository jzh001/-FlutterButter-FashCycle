import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
    currentSavings = userData["Current Savings"];
    totalSpending = userData["Total Spending"];
    carbonSavings = userData["Carbon Savings"];
  }

  Future<void> buyItem(double price) async {
    totalSpending += price;
    carbonSavings += 1;
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      "Total Spending": totalSpending,
      "Carbon Savings": carbonSavings,
    });
  }
}
