import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/reservationsView.dart';
import 'package:mybookshelf/userReservationsView.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final CollectionReference bookCollection = FirebaseFirestore.instance.collection('books');

  final CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');

  Future<void> requestBookReservation(String title) {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    return reservationCollection
        .add({
      'title': title,
      'userId': userId,
      'timestamp': DateTime.now(),
      'status': 'requested', // Add a status field
    })
        .then((value) => print("Reservation Requested"))
        .catchError((error) => print("Failed to request reservation: $error"));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Books'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: bookCollection.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return GridView.count(
            crossAxisCount: 3,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Card(
                elevation: 1,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      width: 500,
                      height: 500,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['imageUrl']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      height: 16,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () => requestBookReservation(data['title']),
                        child: const Text('Reserve'),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );

        },
      ),
      drawer: Drawer(
        backgroundColor: Colors.blueAccent,
        child: ListView(
          children: [
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.person, color: Colors.black, size: 50,),
                    ),
                  ],
                )
            ),
            ListTile(
              leading: Icon(Icons.collections_bookmark, color: Colors.black,),
              title: Text('Book lending',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => UserReservationsView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.checklist_rtl, color: Colors.black,),
              title: Text('Book requests',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsView()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black,),
              title: Text('About app',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.support_agent, color: Colors.black,),
              title: Text('Support',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: (){

              },
            ),
            ListTile(
              leading: Icon(Icons.output, color: Colors.black,),
              title: Text('Log out',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
              onTap: () {

              },
            ),
          ],
        ),
      ),
    );
  }
}
