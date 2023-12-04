import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserReservationsView extends StatelessWidget {
  final CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> getAcceptedReservations() {
      return reservationCollection
          .where('userId', isEqualTo: userId) // Add this line
          .where('status', isEqualTo: 'accepted')
          .snapshots();
    }

    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Accepted Reservations'),
        backgroundColor: Colors.brown,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getAcceptedReservations(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              DateTime timestamp = (data['timestamp'] as Timestamp).toDate(); // Get the timestamp
              DateTime expiryTime = (data['expiryTime'] as Timestamp).toDate(); // Get the expiry time
              String formattedTimestamp = DateFormat('MM/dd/yyyy hh:mm a').format(timestamp);
              String formattedExpiryTime = DateFormat('MM/dd/yyyy hh:mm a').format(expiryTime);
              return Card(
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text('Accepted reservation at $formattedTimestamp. \nPick up before: $formattedExpiryTime'), // Show the formatted times
                  trailing: Container(
                    width: 50, // specify width
                    height: 50, // specify height
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(data['imageUrl']),
                        fit: BoxFit.cover, // use BoxFit.cover to maintain aspect ratio
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
