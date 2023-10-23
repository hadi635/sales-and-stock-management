import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salesandstockmanagement_app1/Clients_screen.dart';
import 'package:salesandstockmanagement_app1/Order_screen.dart';
import 'package:salesandstockmanagement_app1/Stock_screen.dart';
import 'package:salesandstockmanagement_app1/Supplier_screen.dart';
import 'package:salesandstockmanagement_app1/offer_screen.dart';
import 'package:salesandstockmanagement_app1/reports_screen.dart';
import 'package:salesandstockmanagement_app1/screens/login_screen.dart';

class homescreen extends StatefulWidget {
  static const String screenroute = 'home_screen';

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  final _auth = FirebaseAuth.instance;
  late User signedInUser;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
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

  void _logout() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, login.screenroute);
  }

  Future<void> _changePassword() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final bool isPasswordValid = await _showOldPasswordDialog();

        if (!isPasswordValid) {
          print('Old password is incorrect.');
          return;
        }

        await _showNewPasswordDialog(user);
      } else {
        print('User not found.');
      }
    } catch (e) {
      print('Error changing password: $e');
    }
  }

  Future<bool> _showOldPasswordDialog() async {
    String oldPassword = '';
    bool isPasswordValid = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter old password',
                ),
                onChanged: (value) {
                  oldPassword = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (oldPassword.isNotEmpty) {
                  try {
                    final user = _auth.currentUser;
                    if (user != null) {
                      final credential = EmailAuthProvider.credential(
                        email: user.email!,
                        password: oldPassword,
                      );
                      final authResult =
                          await user.reauthenticateWithCredential(credential);
                      if (authResult.user != null) {
                        isPasswordValid = true;
                        Navigator.of(context).pop();
                      } else {
                        isPasswordValid = false;
                        Navigator.of(context).pop();
                      }
                    }
                  } catch (e) {
                    print('Error reauthenticating: $e');
                    Navigator.of(context).pop();
                  }
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );

    return isPasswordValid;
  }

  Future<void> _showNewPasswordDialog(User user) async {
    String newPassword = '';

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Enter new password',
                ),
                onChanged: (value) {
                  newPassword = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                if (newPassword.isNotEmpty) {
                  try {
                    await user.updatePassword(newPassword);
                    Navigator.of(context).pop();
                    _showSnackBar('Password changed successfully.');
                  } catch (e) {
                    _showSnackBar('Error updating password: $e');
                  }
                }
              },
              child: Text('Submit'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
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
                showMenu(
                  context: context,
                  position: RelativeRect.fromLTRB(100, 100, 0, 0),
                  items: [
                    PopupMenuItem(
                      value: 'change_password',
                      child: Text('Change Password'),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ],
                  elevation: 8.0,
                ).then((selectedValue) {
                  if (selectedValue == 'change_password') {
                    _changePassword();
                  } else if (selectedValue == 'logout') {
                    _logout();
                  }
                });
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
              Navigator.pushNamed(context, Stockscreen.screenroute);
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
              Navigator.pushNamed(context, SupplierScreen.screenroute);
            },
            splashColor: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/image2.png',
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
                      'Supplier',
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
              Navigator.pushNamed(context, offerscreen.screenroute);
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
          ),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, reportscreen.screenroute);
            },
            splashColor: Theme.of(context).focusColor,
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                Image.asset(
                  'assets/image6.png',
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
                      'View reports',
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
        
        ],
      ),
    );
  }
}
