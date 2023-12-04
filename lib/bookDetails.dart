import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/home.dart';
import 'locationView.dart';

class BookDetailView extends StatelessWidget {
  final DocumentSnapshot document;

  BookDetailView({required this.document});

  @override
  Widget build(BuildContext context) {

    final CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');

    Future<void> requestBookReservation(String title, String imageUrl) async { // Add imageUrl parameter
      String userId = FirebaseAuth.instance.currentUser!.uid;
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get(); // Get the user document
      String userEmail = userDoc.get('email'); // Get the user's email
      return reservationCollection
          .add({
        'title': title,
        'userId': userId,
        'userEmail': userEmail, // Store the user's email
        'timestamp': DateTime.now(),
        'status': 'requested', // Add a status field
        'imageUrl': imageUrl, // Store the imageUrl
      })
          .then((value) => print("Reservation Requested"))
          .catchError((error) => print("Failed to request reservation: $error"));
    }

    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    Map<String, dynamic> location = data['location'] as Map<String, dynamic>;
    String name = location['name'];
    String latitude = location['latitude'];
    String longitude = location['longitude'];
    double latitudeDouble = latitude != null ? double.parse(latitude) : 0.0;
    double longitudeDouble = longitude != null ? double.parse(longitude) : 0.0;

    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Book Details'),
        backgroundColor: Colors.brown,
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            children:  <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['imageUrl']),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                    FittedBox(
                        child: Card(
                          elevation: 10,
                          color: Colors.brown,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${data['title']}', style: TextStyle(fontSize: 24, color: Colors.white)),
                                ],
                              ),

                              Text('${data['description']}', style: TextStyle(fontSize: 22, color: Colors.white)),
                              Text('Disponible en:', style: TextStyle(fontSize: 24, color: Colors.white)),
                              Text('$name', style: TextStyle(fontSize: 22, color: Colors.white)),
                            ],
                          ),
                        ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            try{
                              requestBookReservation(data['title'], data['imageUrl']);
                            }catch(e){
                              print('The book could not be stored');
                            }
                            final snackBar = SnackBar(content: Text('Request reserve sent'));
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
                          },
                          child: const Text('Reserve', style: TextStyle(fontSize: 20, color: Colors.brown)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LocationView(
                                  latitude: latitudeDouble,
                                  longitude: longitudeDouble,
                                ),
                              ),
                            );
                          },
                          child: Text('Ubicar biblioteca', style: TextStyle(fontSize: 20, color: Colors.brown)),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
