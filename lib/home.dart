import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mybookshelf/BookUpload.dart';
import 'package:mybookshelf/firstscr.dart';
import 'package:mybookshelf/reservationsView.dart';
import 'package:mybookshelf/support.dart';
import 'package:mybookshelf/userReservationsView.dart';
import 'package:mybookshelf/utils/utils.dart';
import 'about.dart';
import 'bookDetails.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final CollectionReference bookCollection = FirebaseFirestore.instance.collection('books');
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<DocumentSnapshot>(
      future: userCollection.doc(userId).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        String role = data['role'];

        return Scaffold(
          backgroundColor: Colors.brown,
          appBar: AppBar(
            title: Text('Books'),
            backgroundColor: Colors.brown,
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
                crossAxisCount: 2,
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailView(document: document),
                        ),
                      );
                    },
                    child: Card(
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
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
          drawer: Drawer(
            backgroundColor: Colors.brown,
            child: ListView(
              children: [
                DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.person, color: Colors.brown, size: 50,),
                        ),
                      ],
                    )
                ),
                if (role == 'user') ListTile(
                  leading: Icon(Icons.collections_bookmark, color: Colors.white,),
                  title: Text('Book lending',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserReservationsView()));
                  },
                ),
                if (role == 'admin') ListTile(
                  leading: Icon(Icons.checklist_rtl, color: Colors.white,),
                  title: Text('Book requests',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationsView()));
                  },
                ),
                if (role == 'admin') ListTile(
                  leading: Icon(Icons.upload, color: Colors.white,),
                  title: Text('Upload book',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BookUpload()));
                  },
                ),
                if (role == 'user') ListTile(
                  leading: Icon(Icons.info, color: Colors.white,),
                  title: Text('About app',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => about()));
                  },
                ),
                if (role == 'user') ListTile(
                  leading: Icon(Icons.support_agent, color: Colors.white,),
                  title: Text('Support',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => support()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.output, color: Colors.white,),
                  title: Text('Log out',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  onTap: (){
                    Utils.closeSession();
                    final snackBar = SnackBar(content: Text('Sesion cerrada'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => firstscr()));
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
