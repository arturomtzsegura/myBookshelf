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
      appBar: AppBar(

      ),
      body: Container(/*
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bulb.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        */
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.3,
              ),
              const Text('MyBookshelf',
                style: TextStyle(
                  fontSize: 40,
                ),
              ),
              SizedBox(
                height: size.height * 0.4,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        FittedBox(
                          child: ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const login()));
                            },
                            child: const Text('Login'),
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
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const register_scr()));
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
