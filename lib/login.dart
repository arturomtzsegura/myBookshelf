import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home.dart';

class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.1,
            ),
            const Text('Entering to',
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const Text('MyBookshelf',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            SizedBox(
              height: size.height * 0.1,
            ),
            Row(
              children: [
                const Expanded(
                  flex: 1,
                  child: Column(
                    children: [

                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Type your email',
                        ),
                        controller: email,
                      ),
                      SizedBox(
                        height: size.height * 0.05,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Type your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              _passwordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of passwordVisible variable
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_passwordVisible,
                        controller: password,
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      FittedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrangeAccent,
                            foregroundColor: Colors.white, // text color
                            elevation: 10, // remove shadow
                          ),
                          onPressed: () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            if(email.text.isNotEmpty && password.text.isNotEmpty) {
                              try {
                                final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text.toString(),
                                );

                                final User? user = userCredential.user;

                                if (user != null) {
                                  // The user logged in successfully, you can use the user object further.
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const home()));
                                  print('User logged in successfully!');
                                } else {
                                  // If the user is null, the login might have failed.
                                  print('User login failed.');
                                }
                              } catch (e) {
                                // Handle the error accordingly.
                                print('Error: $e');
                              }

                            }
                          },
                          child: const Text('Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: Column(
                    children: [

                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
