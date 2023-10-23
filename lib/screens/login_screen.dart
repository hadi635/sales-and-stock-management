import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesandstockmanagement_app1/employehomescreen.dart';
import 'package:salesandstockmanagement_app1/homesalesmanscreen.dart';
import 'package:salesandstockmanagement_app1/screens/home_screen.dart';
import 'package:salesandstockmanagement_app1/screens/signup_screen.dart';

import '../button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class login extends StatefulWidget {
  static const screenroute = 'login_screen';

  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
 final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  bool showSpinner = false;
  bool showError = false;

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  @override
  void dispose() {
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                child: Image.asset('assets/image.png'),
              ),
              SizedBox(height: 50),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    email = value;
                    showError = false;
                  });
                },
                focusNode: emailFocusNode,
                decoration: InputDecoration(
                  hintText: 'Enter your Email',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: showError ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  setState(() {
                    password = value;
                    showError = false;
                  });
                },
                focusNode: passwordFocusNode,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: showError ? Colors.red : Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              MyButton(
                color: Colors.yellow[900]!,
                title: 'Login',
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    UserCredential userCredential =
                        await _auth.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    DocumentSnapshot userDoc = await _firestore
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .get();
                    if (userDoc.exists) {
                      String selectedUserRole = userDoc['role'];
                      switch (selectedUserRole) {
                        case 'Manager':
                          Navigator.pushNamed(
                              context, homescreen.screenroute);
                          break;
                        case 'Employee':
                          Navigator.pushNamed(
                              context, empolyehomescreen.screenroute);
                          break;
                        case 'Sales man':
                          Navigator.pushNamed(
                              context, salesmanhomescreen.screenroute);
                          break;
                        default:
                          Navigator.pushNamed(
                              context, salesmanhomescreen.screenroute);
                          break;
                      }
                    }

                    setState(() {
                      showSpinner = false;
                    });
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      showError = true;
                    });
                    setState(() {
                      showSpinner = false;
                    });
                  } catch (e) {
                    setState(() {
                      showError = true;
                    });
                    setState(() {
                      showSpinner = false;
                    });
                  }
                },
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await _auth.sendPasswordResetEmail(email: email);

                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Password Reset'),
                          content: Text('An email has been sent to reset your password.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Error'),
                          content: Text('An error occurred while sending the password reset email.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            ),
                          ],
                        );
                      },
                    );
                    print('Error sending password reset email: $e');
                  }
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
              if (showError)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    'Invalid email or password.',
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}