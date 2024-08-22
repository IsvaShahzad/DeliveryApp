import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/Providers/cart_provider.dart';

class CartSummaryWidget extends StatelessWidget {
  final VoidCallback? onConfirmPayment;

  CartSummaryWidget({this.onConfirmPayment});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    double total = cartProvider.cart.calculateTotal();
    double deliveryFee = 100.0;
    double subtotal = total + deliveryFee;

    return Visibility(
      visible: cartProvider.cart.items.isNotEmpty,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
        elevation: 5, // Adjust elevation as needed
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Total Amount
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    'Rs. ${total.toStringAsFixed(0)}', // Remove decimal places
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0, // Increase font size for emphasis
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5), // Space between label and amount
              // Delivery Fee
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Standard delivery:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    'Rs. ${deliveryFee.toStringAsFixed(0)}', // Remove decimal places
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Divider(height: 2),
              SizedBox(height: 10),
              // Subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal:',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Text(
                    'Rs. ${subtotal.toStringAsFixed(0)}', // Remove decimal places
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15), // Add some space before the button
              ElevatedButton(
                onPressed:
                cartProvider.cart.items.isEmpty ? null : onConfirmPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9AB3C3),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  elevation: 1.0,
                  textStyle: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                child: Text(
                  'Confirm payment',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
