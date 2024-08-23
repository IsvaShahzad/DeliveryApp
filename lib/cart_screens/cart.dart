
import 'package:flutter/cupertino.dart';

import 'cart_items.dart';

class Cart extends ChangeNotifier {

  List<CartItem> items = [];

  void addToCart(CartItem item) {
    items.add(item);
  }
  void removeFromCart(CartItem item) {
    items.remove(item);
  }

  void clear() {
    items.clear();
  }

  double calculateTotal() {
    double total = 0.0;
    for (var item in items) {
      total += item.price * item.quantity; // Multiply price by quantity
    }
    return total;
  }

}