import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:provider/provider.dart';

class Listings with ChangeNotifier {
  List<ListItem> allListings = [];

  bool isInit = false;

  Listings() {
    initListings();
  }

  Future<void> initListings() async {
    //if (isInit) return;
    print("Running function");
    final listingData = await FirebaseFirestore.instance
        .collection("Listings")
        .limit(100)
        .get();
    print("Length 1 is ${listingData.docs.length}");
    try {
      allListings = listingData.docs
          .map((item) => ListItem(
              id: item.id,
              title: item["Title"],
              description: item["Description"],
              price: item["Price"].toDouble(),
              status: item["Status"],
              imageLink: item["Image Link"],
              author: item["Author"],
              buyer: item["Buyer"],
              type: item["Type"]))
          .toList();
    } catch (error) {
      print(error.toString());
    }
    print("Length 2 is ${allListings.length}");
    isInit = true;
    notifyListeners();
  }

  List<ListItem> getCurrentListings() {
    return allListings.where((element) => element.status == "Active").toList();
  }

  Future<void> addListing({
    required String title,
    required String description,
    required String author,
    required double price,
    required XFile image,
    required String type,
  }) async {
    log("Ready for adding");
    final imageLink = await uploadImageToFirebase(image);
    log("Image uploaded");
    final response =
        await FirebaseFirestore.instance.collection("Listings").add({
      "Title": title,
      "Description": description,
      "Price": price,
      "Status": "Active",
      "Author": author,
      "Image Link": imageLink,
      "Buyer": "NIL",
      "Type": type,
      "Timestamp": DateTime.fromMicrosecondsSinceEpoch(0),
    });

    allListings.add(
      ListItem(
        id: response.id,
        title: title,
        description: description,
        price: price,
        status: "Active",
        imageLink: imageLink,
        author: author,
        buyer: "NIL",
        type: type,
      ),
    );

    notifyListeners();
  }

  Future<void> buyItem(ListItem item, BuildContext ctx) async {
    final boughtItem =
        allListings.firstWhere((element) => element.id == item.id);
    boughtItem.status = "Bought";
    boughtItem.buyer = Provider.of<UserData>(ctx, listen: false).username;
    await FirebaseFirestore.instance
        .collection("Listings")
        .doc(item.id)
        .update({
      "Buyer": Provider.of<UserData>(ctx, listen: false).username,
      "Status": "Bought",
      "Timestamp": DateTime.now(),
    });

    notifyListeners();
  }

  Future<void> deleteByID(String id) async {
    final deletedItem = allListings.firstWhere((item) => item.id == id);
    deleteImageFromFirebase(deletedItem.imageLink);
    allListings.removeWhere((item) => item.id == id);
    await FirebaseFirestore.instance.collection("Listings").doc(id).delete();
    notifyListeners();
  }

  ListItem retrieveByID(String id) {
    if (allListings.indexWhere((item) => item.id == id) == -1) {
      print("NOK");
      print(allListings);
      print(id);
    }
    final ret = allListings.firstWhere((item) => item.id == id);
    return ret;
  }

  Future<void> deleteImageFromFirebase(String imageUrl) async {
    firebase_storage.Reference storageReference =
        firebase_storage.FirebaseStorage.instance.refFromURL(imageUrl);

    await storageReference.delete();

    log('Image deleted from Firebase Storage.');
  }

  Future<String> uploadImageToFirebase(XFile imageFile) async {
    firebase_storage.Reference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().millisecondsSinceEpoch}');
    final metadata = firebase_storage.SettableMetadata(
      contentType: 'image/jpeg',
      customMetadata: {'picked-file-path': imageFile.path},
    );
    firebase_storage.UploadTask uploadTask = kIsWeb
        ? storageReference.putData(await imageFile.readAsBytes(), metadata)
        : storageReference.putFile(File(imageFile.path), metadata);

    firebase_storage.TaskSnapshot storageSnapshot =
        await uploadTask.whenComplete(() => null);

    String downloadUrl = await storageSnapshot.ref.getDownloadURL();

    return downloadUrl;
  }
}

class ListItem {
  String id = "";
  String title = "";
  String description = "";
  double price = 0;
  String status = "Active";
  String imageLink = "https://picsum.photos/250?image=9";
  String author = "";
  String buyer = "NIL";
  String type = "";
  ListItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.status,
    required this.imageLink,
    required this.author,
    required this.buyer,
    required this.type,
  });
}
