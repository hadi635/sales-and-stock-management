import 'package:flutter/material.dart';


class supplierDetailsScreen extends StatelessWidget {
  static const screenroute = 'supplierdetails_screen';
  final String supplierId;
  final String supplierName;
  final String phoneNumber;
  final String adress;
  final double credit;
  final double debit;

  supplierDetailsScreen({
    required this.supplierId,
    required this.supplierName,
    required this.phoneNumber,
    required this.adress,
    required this.credit,
    required this.debit,
  });

  @override
  Widget build(BuildContext context) {
    double balance=debit-credit;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Supplier Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Supplier ID: $supplierId',
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
                Icon(Icons.account_circle, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Name: $supplierName',
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
                Icon(Icons.phone, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Phone Number: $phoneNumber',
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
                Icon(Icons.location_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Address: $adress',
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
                Icon(Icons.monetization_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Credit: $credit',
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
                Icon(Icons.monetization_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'Debit: $debit',
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
                Icon(Icons.monetization_on, color: Colors.orange),
                SizedBox(width: 8),
                Text(
                  'balance: $balance',
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