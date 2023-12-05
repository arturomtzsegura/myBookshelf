import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mybookshelf/register_scr.dart';
import 'login.dart';

class firstscr extends StatefulWidget {
  const firstscr({super.key});

  @override
  State<firstscr> createState() => _homeState();
}

class _homeState extends State<firstscr> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/firstscreenimg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column( // Change Center to Column
          mainAxisAlignment: MainAxisAlignment.center, // To keep the content in center
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            const Text('MyBookshelf',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            FittedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  foregroundColor: Colors.white, // text color
                                  elevation: 10, // remove shadow

                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const login()));
                                },
                                child: const Text('Login',
                                  style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            FittedBox(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrangeAccent,
                                  foregroundColor: Colors.white, ////// text color
                                  elevation: 10, // remove shadow

                                ),
                                onPressed: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const register_scr()));
                                },
                                child: const Text('Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
