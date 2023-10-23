import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import 'package:salesandstockmanagement_app1/button.dart';
import 'package:salesandstockmanagement_app1/employehomescreen.dart';
import 'package:salesandstockmanagement_app1/homesalesmanscreen.dart';
import 'package:salesandstockmanagement_app1/screens/home_screen.dart';

class signup extends StatefulWidget {
  static const screenroute = 'signup_screen';

  @override
  _signupState createState() => _signupState();
}

class _signupState extends State<signup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late String email;
  late String password;
  String selectedUserRole = 'Sales man';
  List<String> userRoles = ['Sales man', 'Employee', 'Manager'];

  bool showSpinner = false;// dwyra tahmil

  void _signUp() async {
    setState(() {
      showSpinner = true;
    });

    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(newUser.user!.uid).set({
        'role': selectedUserRole,
      });

      switch (selectedUserRole) {
        case 'Manager':
          Navigator.pushNamed(context, homescreen.screenroute);
          break;
        case 'Employee':
          Navigator.pushNamed(context, empolyehomescreen.screenroute);
          break;
        case 'Sales man':
          Navigator.pushNamed(context, salesmanhomescreen.screenroute);
          break;
        default:
          Navigator.pushNamed(context, salesmanhomescreen.screenroute);
          break;
      }

      setState(() {
        showSpinner = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        showSpinner = false;
      });
    }
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
                  email = value;
                },
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
                      color: Colors.blue,
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
                  password = value;
                },
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
                      color: Colors.blue,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: selectedUserRole,
                items: userRoles.map((role) {
                  return DropdownMenuItem<String>(
                    value: role,
                    child: Text(role),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedUserRole = newValue!;
                  });
                },
              ),
              SizedBox(height: 10),
              MyButton(
                color: Colors.blue[800]!,
                title: 'Sign Up',
                onPressed: _signUp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
