import 'package:dine_ease/models/order_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders => _orders;

  void addOrder(Order order) {
    _orders.add(order);
    notifyListeners();
  }

  void removeOrder(int index) {
    _orders.removeAt(index);
    notifyListeners();
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }


}
