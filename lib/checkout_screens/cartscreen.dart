import 'package:flutter/material.dart';
import 'package:shop/checkout_screens/payment_screen.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/mainscreen.dart';
import '../widgets/cart_widget.dart';
import '../widgets/progress_bar.dart';
import 'delivered_screen.dart';
import '../../Providers/cart_provider.dart' as cartprovider;
import '../../cart_screens/cart.dart';
import '../../cart_screens/cart_items.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartScreen extends StatefulWidget {
  final cartprovider.CartProvider cartProvider;
  final Cart cart;

  const CartScreen({Key? key, required this.cartProvider, required this.cart})
      : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    updateTotal();
  }

  void updateTotal() {
    setState(() {
      total = widget.cartProvider.cart.calculateTotal();
    });
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
    return false;
  }

  Future<void> _storeCartItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is currently logged in');
      return;
    }

    final email = user.email ?? 'unknown@example.com';
    final cartItems = widget.cartProvider.cart.items;
    double totalWithExtra = total + 100;

    // Prepare the cart data
    final cartData = {
      'Items': cartItems.map((item) {
        return {
          'Item Name': item.name,
          'Price': item.price,
          'Quantity': item.quantity,
          'Image URL': item.imageUrl,
        };
      }).toList(),
      'Total': totalWithExtra,
      'Timestamp': FieldValue.serverTimestamp(), // Add timestamp
    };

    try {
      // Reference to the user's document in the 'cartitems' collection
      final userDocRef = FirebaseFirestore.instance.collection('cartitems').doc(email);

      // Reference to the 'orders' subcollection for the user
      final ordersCollectionRef = userDocRef.collection('orders');

      // Generate a unique identifier for each order
      final orderDocRef = ordersCollectionRef.doc(); // Automatically generates a unique document ID

      // Store the cart data in a new document in the 'orders' subcollection
      await orderDocRef.set(cartData);

      print('Cart items stored in Firestore');
    } catch (e) {
      print('Error storing cart items to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/page6.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false, // Disables the back arrow

            flexibleSpace: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.black54,
                    size: 23,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );
                  },
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cart',
                      style: TextStyle(
                        fontSize: 23,
                        color: Colors.black,
                        fontFamily: 'Kanit',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              // Progress Bar
              ProgressBar(
                steps: ['Menu', 'Cart', 'Payment'],
                currentIndex: 1, // Adjust this based on the current step
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  elevation: 2, // Adjust elevation as needed
                  child: ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: Image.asset(
                      'assets/images/deliveryguy.jpeg', // Replace with your image path
                      width: 70, // Adjust width as needed
                      height: 70, // Adjust height as needed
                    ),
                    title: Text(
                      'Estimated delivery',
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    subtitle: Text(
                      'Standard (30-45 mins)',
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10), // Space between ListTile and ListView
              Expanded(
                child: widget.cartProvider.cart.items.isEmpty
                    ? Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Text(
                      'Your cart is empty!\nAdd something to it🛒',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                        color: Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: widget.cartProvider.cart.items.length,
                  itemBuilder: (context, index) {
                    CartItem item = widget.cartProvider.cart.items[index];

                    return Dismissible(
                      key: Key(item.name),
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          widget.cartProvider.removeCartItem(item);
                          updateTotal();
                        });
                        widget.cartProvider.cart.items.remove(item);
                      },
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: item.imageUrl.startsWith('assets/')
                                ? Image.asset(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            )
                                : Image.network(
                              item.imageUrl,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rs. ${item.price.toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Text(
                                      '-',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        if (item.quantity > 1) {
                                          widget.cartProvider.decreaseQuantity(item);
                                        } else {
                                          widget.cartProvider.removeCartItem(item);
                                        }
                                        updateTotal();
                                      });
                                    },
                                  ),
                                  Text(
                                    item.quantity.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Text(
                                      '+',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                        fontSize: 18,
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        widget.cartProvider.increaseQuantity(item);
                                        updateTotal();
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              CartSummaryWidget(
                onConfirmPayment: () async {
                  await _storeCartItems();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PaymentScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}