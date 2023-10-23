import 'package:flutter/material.dart';
import 'package:salesandstockmanagement_app1/order.dart'; // تأكد من استيراد الـ Order بشكل صحيح

class OrderScreen extends StatelessWidget {
  static const screenroute = 'order_screen';
  final Order order;

  OrderScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('ID: ${order.orderID}'),
            Text('Date: ${order.date}'),
            Text('Total Amount: ${order.totalAmount.toStringAsFixed(2)}'),
            Text('In Location: ${order.inLocation}'),
            Text('Out Location: ${order.outLocation}'),
            Text('Order Lines:'),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: order.orderLines.map((line) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Line ID: ${line.id}'),
                    Text('Quantity: ${line.quantity}'),
                    Text('Unit Price: ${line.unitPrice.toStringAsFixed(2)}'),
                    Text('Discount: ${line.discount}'),
                    Text('Total Line Amount: ${line.totalLineAmount.toStringAsFixed(2)}'),
                    Divider(),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}