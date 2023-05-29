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
  String clothingType = "Men's Shirt";

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
                    const SizedBox(height: 10),
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
                    const SizedBox(height: 20),
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
                    const SizedBox(height: 20),
                    DropdownButtonFormField(
                        decoration:
                            const InputDecoration(label: Text("Clothing Type")),
                        value: clothingType,
                        items: [
                          "Men's Shirt",
                          "Men's Pants",
                          "Men's Trousers",
                          "Dresses",
                          "Skirts",
                          "Women's Shirt",
                          "Women's Pants"
                        ]
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (val) {
                          clothingType = val!;
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
