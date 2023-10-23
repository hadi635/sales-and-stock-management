import 'package:flutter/material.dart';

class Productdetailsscreen extends StatelessWidget {
  static const screenroute = 'productdetails_screen';
  final String productID;
  final String productname;
   int productqty;
  final int productbuyprice;
  final int productselprice;
  final String productdescription; // إضافة متغير لوصف المنتج

  Productdetailsscreen({
    required this.productID,
    required this.productbuyprice,
    required this.productname,
    required this.productqty,
    required this.productselprice,
    required this.productdescription, // تعيين الوصف في البناء
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Product Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.label, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Name: $productname',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.format_list_numbered, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Quantity: $productqty',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.attach_money, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Buying Price: $productbuyprice',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.money, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Selling Price: $productselprice',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.description, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Description: $productdescription', // عرض وصف المنتج
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.format_list_numbered_rtl, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'ID: $productID', // عرض المعرّف
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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