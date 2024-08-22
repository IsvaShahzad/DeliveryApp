import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../cart_screens/cart.dart' as cartprovider;
import '../cart_screens/cart_items.dart';

class CartProvider with ChangeNotifier {






  int _counter = 0;
  int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  cartprovider.Cart _cart = cartprovider.Cart(); // Define and initialize the Cart object
  cartprovider.Cart get cart => _cart; // Getter for the Cart object

  CartProvider() {
    _getPrefItems();
  }

  Future<void> _setPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cart_item', _counter);
    await prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  Future<void> _getPrefItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_item') ?? 0;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice += productPrice;
    _setPrefItems();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice -= productPrice;
    _setPrefItems();
  }

  void addCartItem(CartItem item) {
    _counter++;
    cart.items.add(item); // Add the item to the cart
    addTotalPrice(item.price); // Update the total price by adding the item's price
    _setPrefItems();
    notifyListeners();
  }

  void removeCartItem(CartItem item) {
    _counter--;
    cart.items.remove(item); // Remove the item from the cart
    removeTotalPrice(item.price); // Update the total price by subtracting the item's price
    _setPrefItems();
    notifyListeners();
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    addTotalPrice(item.price);
    _setPrefItems();
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
      removeTotalPrice(item.price);
    } else {
      removeCartItem(item);
    }
    _setPrefItems();
    notifyListeners();
  }


  void updateCounter() {
    _counter = cart.items.length; // Update the counter based on the cart item count
    _setPrefItems();
    notifyListeners();
  }

  void clearCart() {
    cart.items.clear();

    // Any other logic to clear the cart
  }


}
