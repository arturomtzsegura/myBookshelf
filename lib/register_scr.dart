import 'package:flutter/material.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class register_scr extends StatefulWidget {
  const register_scr({super.key});

  @override
  State<register_scr> createState() => _register_scrState();
}

class _register_scrState extends State<register_scr> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController rePass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

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
            const Text('Creating an account',
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
                        height: size.height * 0.05,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          hintText: 'Confirm your password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on confirmPasswordVisible state choose the icon
                              _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Theme.of(context).primaryColorDark,
                            ),
                            onPressed: () {
                              // Update the state i.e. toogle the state of confirmPasswordVisible variable
                              setState(() {
                                _confirmPasswordVisible = !_confirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        obscureText: !_confirmPasswordVisible,
                        controller: rePass,
                      ),
                      SizedBox(
                        height: size.height * 0.1,
                      ),
                      FittedBox(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            elevation: 0, // remove shadow
                            shape: RoundedRectangleBorder( // rounded corners
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          onPressed: () async {
                            final FirebaseAuth _auth = FirebaseAuth.instance;
                            if(email.text.isNotEmpty && password.text == rePass.text)
                            {
                              try {
                                final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                  email: email.text,
                                  password: password.text,
                                );

                                final User? user = userCredential.user;

                                if (user != null) {
                                  await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
                                      'email': user.email,
                                      'role': 'user',
                                      // Add any other data you want to store for the user
                                    });

                                  // The user was created successfully, you can use the user object further.
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const home()));
                                } else {
                                  // If the user is null, the creation might have failed.
                                  print('User creation failed.');
                                }
                              } catch (e) {
                                // Handle the error accordingly.
                                print('Error: $e');
                              }
                            }

                          },
                          child: const Text('Register',
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
