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
  Future<void> addListing({
    required String title,
    required String description,
    required String author,
    required double price,
    required XFile image,
    required String type,
    required String material,
  }) async {
    log("Ready for adding");
    final imageLink = await uploadImageToFirebase(image);
    log("Image uploaded");
    await FirebaseFirestore.instance.collection("Listings").add({
      "Title": title,
      "Description": description,
      "Price": price,
      "Status": "Active",
      "Author": author,
      "Image Link": imageLink,
      "Buyer": "NIL",
      "Type": type,
      "Material": material,
      "Buy Timestamp": DateTime.now(),
      "Sell Timestamp": DateTime.fromMicrosecondsSinceEpoch(0),
    });

    notifyListeners();
  }

  Future<void> buyItem(ListItem item, BuildContext ctx) async {
    await FirebaseFirestore.instance
        .collection("Listings")
        .doc(item.id)
        .update({
      "Buyer": Provider.of<UserData>(ctx, listen: false).username,
      "Status": "Bought",
      "Sell Timestamp": DateTime.now(),
    });

    notifyListeners();
  }

  Future<void> delete(ListItem deletedItem) async {
    deleteImageFromFirebase(deletedItem.imageLink);
    await FirebaseFirestore.instance
        .collection("Listings")
        .doc(deletedItem.id)
        .delete();
    notifyListeners();
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
  String material = "";
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
    required this.material,
  });
}
