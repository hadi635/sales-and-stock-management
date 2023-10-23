import 'package:flutter/material.dart';
import 'package:salesandstockmanagement_app1/lineorder.dart';
 

class Order {
  final String orderID;
  final String date;
  final double totalAmount;
  final String inLocation;
  final String outLocation;
  final List<OrderLine> orderLines;

  Order({
    required this.orderID,
    required this.date,
    required this.totalAmount,
    required this.inLocation,
    required this.outLocation,
    required this.orderLines,
  });
}
  
    
  



