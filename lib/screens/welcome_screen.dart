import 'package:flutter/material.dart';
import 'package:salesandstockmanagement_app1/screens/login_screen.dart';
import 'package:salesandstockmanagement_app1/screens/signup_screen.dart';


import '../button.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screenroute = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Container(
                  height: 180,
                  child: Image.asset('assets/image.png'),
                ),
                Text(
                  'Manage your inventory and sales',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff2e386b),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            MyButton(
              color: Colors.yellow[900]!,
              title: 'login',
              onPressed: () {
                Navigator.pushNamed(context, login.screenroute);
              },
            ),
            MyButton(
              color: Colors.blue[800]!,
              title: 'signup',
              onPressed: () {
                Navigator.pushNamed(context, signup.screenroute);
              },
            )
          ],
        ),
      ),
    );
  }
}
