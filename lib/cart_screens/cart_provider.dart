import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'cart_items.dart';



class Cart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double calculateTotal() {
    double total = 0;
    for (var item in _items) {
      total += item.price;
    }
    return total;
  }

  void addItem(CartItem item) {
    _items.add(item);
    notifyListeners();
  }

}

