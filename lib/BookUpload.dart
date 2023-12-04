import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'home.dart';


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
  Map<String, dynamic>? selectedLocation;
  String? selectedLocationId;


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
      'location': selectedLocation, // Include the selected location
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
    final CollectionReference locationsCollection = FirebaseFirestore.instance.collection('locations');

    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Book'),
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          TextField(
            controller: titulo,
            onChanged: (value) {
              setState(() {
                title = titulo.text;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Enter Book Title",
            ),
          ),
          TextField(
            controller: descripcion,
            onChanged: (value) {
              setState(() {
                description = descripcion.text;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Enter Book Description",
            ),
          ),
          TextField(
            controller: cantidad,
            onChanged: (value) {
              setState(() {
                quantity = int.parse(cantidad.text);
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              hintText: "Enter Quantity Available",
            ),
          ),
          Text('Select the library'),
          StreamBuilder<QuerySnapshot>(
            stream: locationsCollection.snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("Loading");
              }

              List<DropdownMenuItem> locationItems = snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return DropdownMenuItem(
                  value: document.id, // Use document ID as the value
                  child: Text(data['name']),
                );
              }).toList();
              return DropdownButton(
                value: selectedLocationId, // Use selected location ID as the value
                items: locationItems,
                onChanged: (value) {
                  setState(() {
                    selectedLocationId = value;
                    selectedLocation = snapshot.data!.docs.firstWhere((doc) => doc.id == value).data() as Map<String, dynamic>;
                  });
                },
              );

            },
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0, // remove shadow
              shape: RoundedRectangleBorder( // rounded corners
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: getImage,
            child: Text('Choose Image'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 0, // remove shadow
              shape: RoundedRectangleBorder( // rounded corners
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            onPressed: (){
              try{
                uploadBook();
              }catch(e){
                print('The book could not be stored');
              }
              titulo.clear();
              descripcion.clear();
              cantidad.clear();
              final snackBar = SnackBar(content: Text('The book has been stored'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const home()));
            },
            child: Text('Upload Book'),
          ),
        ],
      ),
      ),
    );
  }
}
