import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:salesandstockmanagement_app1/Clients_screen.dart';
import 'package:salesandstockmanagement_app1/Order_screen.dart';
import 'package:salesandstockmanagement_app1/Stock_screen.dart';
import 'package:salesandstockmanagement_app1/Supplier_screen.dart';
import 'package:salesandstockmanagement_app1/button.dart';
import 'package:salesandstockmanagement_app1/client.dart';

import 'package:salesandstockmanagement_app1/employehomescreen.dart';
import 'package:salesandstockmanagement_app1/homesalesmanscreen.dart';
import 'package:salesandstockmanagement_app1/offer_screen.dart';
import 'package:salesandstockmanagement_app1/offerlist.dart';
import 'package:salesandstockmanagement_app1/product.dart';

import 'package:salesandstockmanagement_app1/productlist.dart';
import 'package:salesandstockmanagement_app1/reports_screen.dart';
import 'package:salesandstockmanagement_app1/screens/home_screen.dart';
import 'package:salesandstockmanagement_app1/screens/login_screen.dart';
import 'package:salesandstockmanagement_app1/screens/signup_screen.dart';
import 'package:salesandstockmanagement_app1/screens/welcome_screen.dart';
import 'package:salesandstockmanagement_app1/spplier.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // تضمن تهيئة ربط Flutter مع الجهاز
  await Firebase.initializeApp(); // قم بتهيئة Firebase
  runApp(const MyApp()); // قم بتشغيل التطبيق
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'stock management',
      theme: ThemeData(
        primaryColor: Colors.white,
        useMaterial3: true,
      ),
      initialRoute: WelcomeScreen.screenroute,
      routes: {
        WelcomeScreen.screenroute: (context) => const WelcomeScreen(),
        login.screenroute: (context) => login(),
        signup.screenroute: (context) => signup(),
        homescreen.screenroute: (context) => homescreen(),
        Stockscreen.screenroute: (context) => Stockscreen(clientId: '',),
        clientscreen.screenroute: (context) => clientscreen(),
        SupplierScreen.screenroute: (context) => SupplierScreen(),
       
        offerscreen.screenroute: (context) => offerscreen(),
        reportscreen.screenroute: (context) => reportscreen(),
        empolyehomescreen.screenroute: (context) => empolyehomescreen(),
        salesmanhomescreen.screenroute: (context) => salesmanhomescreen(),
        ProductListScreen.screenroute: (context) => ProductListScreen(),
        Offerlist.screenroute: (context) => Offerlist(),
        supplierDetailsScreen.screenroute: (context) => supplierDetailsScreen(
              supplierId: '123',
              supplierName: 'clientName',
              phoneNumber: 'phoneNumber',
              adress: 'tripoli',
              credit: 0.0,
              debit: 0.0,
            ),
        ClientDetailsScreen.screenroute: (context) => ClientDetailsScreen(
              clientId: 'clientID',
              clientName: 'clientName',
              phoneNumber: 'phoneNumber',
              address: 'address',
              credit: 0.0,
              debit: 0.0,
            ),
        Productdetailsscreen.screenroute: (context) => Productdetailsscreen(
              productID: 'your_product_id_here',
              productbuyprice: 50,
              productname: 'Product Name',
              productqty: 100,
              
              
              
              productselprice: 70,
              productdescription:'aaa',
            ),
      },
    );
  }
}
