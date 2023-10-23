import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesandstockmanagement_app1/Clients_screen.dart';
import 'package:salesandstockmanagement_app1/Order_screen.dart';
import 'package:salesandstockmanagement_app1/Stock_screen.dart';

import 'package:salesandstockmanagement_app1/offer_screen.dart';
import 'package:salesandstockmanagement_app1/offerlist.dart';
import 'package:salesandstockmanagement_app1/productlist.dart';


class salesmanhomescreen extends StatefulWidget {
  static const String screenroute = 'salesmanhome_screen';

  @override
  State<salesmanhomescreen> createState() => _salesmanhomescreenState();
}

class _salesmanhomescreenState extends State<salesmanhomescreen> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
        print(signedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home page'),
        backgroundColor: Colors.orange,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        padding: EdgeInsets.all(16),
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ProductListScreen.screenroute);
            },
            splashColor: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/image.png',
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Stock',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, clientscreen.screenroute);
            },
            splashColor: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/image1.png',
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Clients',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),  
           InkWell(
            onTap: () {
              Navigator.pushNamed(context, OrderScreen.screenroute);
            },
            splashColor: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/image3.png',
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Make Order',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, Offerlist.screenroute);
            },
            splashColor: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/image4.png',
                  height: 150.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      'Make Offer',
                      style: TextStyle(
                        fontSize: 30.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )]));}}