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

    Future<void> cancelReservation(String docId) async {
      // Get reference to the document
      DocumentReference docRef = reservationCollection.doc(docId);

      // Update the reservation status to 'cancelled'
      await docRef.update({'status': 'cancelled'});
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
              DateTime? timestamp;
              DateTime? expiryTime;
              if (data['timestamp'] != null) {
                timestamp = (data['timestamp'] as Timestamp).toDate(); // Get the timestamp
                expiryTime = timestamp.add(Duration(hours: 4)); // Add 4 hours to the timestamp
              }
              String formattedTimestamp = timestamp != null ? DateFormat('MM/dd/yyyy hh:mm a').format(timestamp) : 'N/A';
              String formattedExpiryTime = expiryTime != null ? DateFormat('MM/dd/yyyy hh:mm a').format(expiryTime) : 'N/A';
              return Dismissible(
                key: Key(document.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Confirm"),
                        content: const Text("Are you sure you wish to cancel this reservation?"),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(false), // Return false when cancel is pressed
                              child: const Text("CANCEL")
                          ),
                          TextButton(
                              onPressed: () => Navigator.of(context).pop(true), // Return true when accept is pressed
                              child: const Text("ACCEPT")
                          ),
                        ],
                      );
                    },
                  );
                },
                onDismissed: (direction) {
                  cancelReservation(document.id); // Call the cancel function with the document id
                },
                child: Card(
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
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
