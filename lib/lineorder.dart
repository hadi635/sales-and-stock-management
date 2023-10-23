import 'package:flutter/material.dart';
class OrderLine {
  int id;
  int quantity;
  double unitPrice;
  int discount;

  OrderLine({
    required this.id,
    required this.quantity,
    required this.unitPrice,
    required this.discount, required double totalLineAmount,
  });

  double get totalLineAmount {
    return (quantity * unitPrice) - discount;
  }
}