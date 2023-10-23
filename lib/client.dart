import 'package:flutter/material.dart';

class ClientDetailsScreen extends StatelessWidget {
  static const screenroute = 'clientdetails_screen';
  final String clientId;
  final String clientName;
  final String phoneNumber;
  final String address;
  final double credit;
  final double debit;

  ClientDetailsScreen({
    required this.clientId,
    required this.clientName,
    required this.phoneNumber,
    required this.address,
    required this.credit,
    required this.debit,
  });

  @override
  Widget build(BuildContext context) {
     double balance=debit-credit;
    return Scaffold(
      
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('Client Details'),
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
                  'Client ID: $clientId',
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
                  'Name: $clientName',
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
                  'Address: $address',
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
