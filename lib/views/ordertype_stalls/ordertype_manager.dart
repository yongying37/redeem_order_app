import 'package:flutter/material.dart';

class OrderTypeManager extends ChangeNotifier {
  String? _selectedOrderType;

  String? get selectedOrderType => _selectedOrderType;

  void setOrderType(String orderType) {
    _selectedOrderType = orderType;
    notifyListeners();
  }

  void clearOrderType() {
    _selectedOrderType = null;
    notifyListeners();
  }
}
