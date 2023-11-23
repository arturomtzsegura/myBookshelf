import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker

class BookUpload extends StatefulWidget {
  @override
  _BookUploadState createState() => _BookUploadState();
}

class _BookUploadState extends State<BookUpload> {
  final CollectionReference bookCollection = FirebaseFirestore.instance.collection('books');
  final ImagePicker _picker = ImagePicker();
  late File _imageFile;
  late String title, description;
  late int quantity;
  final TextEditingController titulo = TextEditingController();
  final TextEditingController descripcion = TextEditingController();
  final TextEditingController cantidad = TextEditingController();

  Future<void> uploadBook() async {
    late String imageUrl;

    if (_imageFile != null) {
      final Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('books/${title.toString()}');
      final UploadTask uploadTask = storageReference.putFile(_imageFile);

      await uploadTask.whenComplete(() async {
        imageUrl = await storageReference.getDownloadURL();
      }).catchError((onError) {
        print(onError);
      });
    }

    return bookCollection
        .add({
      'title': title,
      'description': description,
      'quantity': quantity,
      'imageUrl': imageUrl,
    })
        .then((value) => print("Book Uploaded"))
        .catchError((error) => print("Failed to upload book: $error"));

  }

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Book'),
      ),
      body: Column(
        children: <Widget>[
          TextField(controller: titulo,
            onChanged: (value) {
              setState(() {
                title = titulo.text;
              });
            },
            decoration: InputDecoration(
              hintText: "Enter Book Title",
            ),
          ),
          TextField(controller: descripcion,
            onChanged: (value) {
              setState(() {
                description = descripcion.text;
              });
            },
            decoration: InputDecoration(
              hintText: "Enter Book Description",
            ),
          ),
          TextField(controller: cantidad,
            onChanged: (value) {
              setState(() {
                quantity = int.parse(cantidad.text);
              });
            },
            decoration: InputDecoration(
              hintText: "Enter Quantity Available",
            ),
          ),
          ElevatedButton(
            onPressed: getImage,
            child: Text('Choose Image'),
          ),
          ElevatedButton(
            onPressed: (){
                uploadBook();
                titulo.clear();
                descripcion.clear();
                cantidad.clear();
              },
            child: Text('Upload Book'),
          ),
        ],
      ),
    );
  }
}
