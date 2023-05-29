import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterbutter/models/listings.dart';
import 'package:flutterbutter/models/user_data.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({super.key});

  static const routeName = '/addListing';

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final _formKey = GlobalKey<FormState>();

  XFile? _pickedImage;
  String title = "";
  String description = "";
  double? price;
  String clothingType = "Jacket";
  String material = "Cotton";

  bool _isLoading = false;

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    return pickedImage;
  }

  Future<void> _pickImage() async {
    XFile? pickedImage = await pickImage();
    setState(() {
      _pickedImage = pickedImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Listing"),
        actions: [
          IconButton(
            onPressed: () async {
              if (_formKey.currentState!.validate() && _pickedImage != null) {
                FocusScope.of(context).unfocus();

                //log(widget.id.toString());
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Listings>(context, listen: false).addListing(
                  author:
                      Provider.of<UserData>(context, listen: false).username,
                  title: title,
                  description: description,
                  image: _pickedImage!,
                  price: price!,
                  type: clothingType,
                  material: material,
                );
                setState(() {
                  _isLoading = false;
                });
                if (!mounted) return;
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Listing added"),
                  ),
                );
                Navigator.of(context).pushReplacementNamed('/listings');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text("Error detected: check your inputs."),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(35.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      maxLength: 50,
                      decoration: const InputDecoration(labelText: "Title"),
                      onChanged: (val) {
                        title = val;
                      },
                      validator: (val) {
                        return val == null || val.length < 5
                            ? "Please enter a valid title"
                            : null;
                      },
                    ),
                    TextFormField(
                      maxLength: 200,
                      decoration:
                          const InputDecoration(labelText: "Description"),
                      onChanged: (val) {
                        description = val;
                      },
                      validator: (val) {
                        return val == null || val.length < 10
                            ? "Please enter a valid description"
                            : null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: "Price"),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      onChanged: (val) {
                        price = double.tryParse(val);
                      },
                      validator: (val) {
                        return price == null
                            ? "Please enter a valid price"
                            : null;
                      },
                    ),
                    DropdownButtonFormField(
                        decoration:
                            const InputDecoration(label: Text("Clothing Type")),
                        value: clothingType,
                        items: [
                          "Jacket",
                          "Pants",
                          "Shirt",
                          "Dress",
                        ]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          clothingType = val!;
                        }),
                    DropdownButtonFormField(
                        decoration:
                            const InputDecoration(label: Text("Material")),
                        value: material,
                        items: [
                          "Cotton",
                          "Acrylic Fabric",
                          "Linen",
                          "Nylon",
                          "Silk",
                          "Wool",
                          "Polyester"
                        ]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          material = val!;
                        }),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: const Text('Pick Image'),
                    ),
                    const SizedBox(height: 16),
                    if (_pickedImage != null)
                      Image.file(
                        File(_pickedImage!.path),
                        height: 200,
                        width: 200,
                        fit: BoxFit.cover,
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
