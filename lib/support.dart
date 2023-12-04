import 'package:flutter/material.dart';
import 'package:mybookshelf/reservationsView.dart';
import 'package:mybookshelf/userReservationsView.dart';
import 'package:mybookshelf/utils/utils.dart';

import 'about.dart';
import 'home.dart';
import 'login.dart';

class support extends StatefulWidget {
  const support({super.key});

  @override
  State<support> createState() => _supportState();
}

class _supportState extends State<support> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown,
      appBar: AppBar(
        title: Text('Support'),
        backgroundColor: Colors.brown,
      ),
      body:
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 10,
                  child: Column(
                    children: [
                      Text('You can call and get more information about your reserve here:',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),

                      Text('\n'
                          'mybookshelf@support.com\n'
                          'support@gmail.com.mx \n'
                          'support@mybookshelf.com\n',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text('\nTelephone: \n\n'
                          '444 292 4828\n'
                          '444 828 2049\n'
                          '444 927 1934\n',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
    );
  }
}
