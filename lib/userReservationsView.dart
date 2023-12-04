import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserReservationsView extends StatelessWidget {
  final CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    Stream<QuerySnapshot> getAcceptedReservations() {
      return reservationCollection
          .where('status', isEqualTo: 'accepted')
          .snapshots();
    }
    return Scaffold(
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
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return ListTile(
                title: Text(data['title']),
                subtitle: Text('Accepted by admin at ${data['timestamp'].toDate()}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
