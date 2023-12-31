import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mybookshelf/BookUpload.dart';
import 'package:mybookshelf/about.dart';
import 'package:mybookshelf/firstscr.dart';
import 'package:mybookshelf/home.dart';
import 'package:mybookshelf/login.dart';
import 'package:mybookshelf/profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: firstscr(),
    );
  }
}
