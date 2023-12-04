import 'package:flutter/material.dart';
import 'package:mybookshelf/home.dart';
import 'package:mybookshelf/reservationsView.dart';
import 'package:mybookshelf/support.dart';
import 'package:mybookshelf/userReservationsView.dart';
import 'package:mybookshelf/utils/utils.dart';
import 'login.dart';

class about extends StatefulWidget {
  const about({super.key});

  @override
  State<about> createState() => _aboutState();
}

class _aboutState extends State<about> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('About Mybookshelf'),
        backgroundColor: Colors.brown,
      ),
      body: const Stack(
        children: [
          Padding(
              padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 10,
                  child: Text('MyBookshelf is an app that can help you to reserve'
                      ' a book in an available library from your city.\n '
                      'Just tap a book and you can read a little description, see where the library '
                      'is located and reserve the book in that place, so you can get to the library '
                      'and just pick it up.\n\n'
                      ''
                      'Give it a try!',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
