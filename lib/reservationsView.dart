import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReservationsView extends StatelessWidget {
  final CollectionReference pendingReservationCollection = FirebaseFirestore.instance.collection('pendingReservations');
  final CollectionReference reservationCollection = FirebaseFirestore.instance.collection('reservations');

  Future<void> acceptReservationRequest(String requestId) {
    return reservationCollection
        .doc(requestId)
        .update({'status': 'accepted'})
        .then((value) => print("Reservation Accepted"))
        .catchError((error) => print("Failed to accept reservation: $error"));
  }

  Future<void> rejectReservationRequest(String requestId) {
    return reservationCollection
        .doc(requestId)
        .delete()
        .then((value) => print("Reservation Rejected"))
        .catchError((error) => print("Failed to reject reservation: $error"));
  }

// This function can be used to get a stream of reservation requests
  Stream<QuerySnapshot> getReservationRequests() {
    return reservationCollection
        .where('status', isEqualTo: 'requested')
        .snapshots();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Pending Reservations'),
        backgroundColor: Colors.brown,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: getReservationRequests(),
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
              return Card(
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text('Requested by ${data['userId']} at ${data['timestamp'].toDate()}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextButton(
                        child: Text('Accept', style: TextStyle(color: Colors.brown),),
                        onPressed: () => acceptReservationRequest(document.id),
                      ),
                      TextButton(
                        child: Text('Reject', style: TextStyle(color: Colors.brown)),
                        onPressed: () => rejectReservationRequest(document.id),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      )
    );
  }
}
