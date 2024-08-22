import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../cart_screens/cart.dart';
import 'delivered_screen.dart';
import 'shipping_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isCheckboxChecked = false;
  String userFirstName = 'User';
  String userEmail = 'user@example.com';

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();

      if (userDoc.exists) {
        print('Fetched User Details: ${userDoc.data()}');
        setState(() {
          userFirstName = userDoc['firstname'] ?? 'User';
          userEmail = user.email ?? 'user@example.com';
        });
      } else {
        print('User document does not exist.');
      }
    } else {
      print('No current user.');
    }
  }

  Future<void> updateUserDetails() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.email)
            .update({
          'firstname': userFirstName,
          'email': userEmail,
        });
        print('User details updated successfully.');
      } catch (e) {
        print('Error updating user details: $e');
      }
    } else {
      print('No current user.');
    }
  }

  Future<void> placeOrder() async {
    if (!isCheckboxChecked) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.0),
            ),
            title: Text(
              'Error',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              'Please confirm your order by checking the checkbox.',
              style: TextStyle(
                fontFamily: 'Montserrat',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          );
        },
      );
    } else {
      // Add order details to Firestore
      try {
        final email = FirebaseAuth.instance.currentUser?.email ?? 'unknown@example.com';
        final cartDocRef = FirebaseFirestore.instance.collection('cartitems').doc(email);

        // Add order details to Firestore
        await FirebaseFirestore.instance.collection('orders').add({
          'username': userFirstName,
          'email': userEmail,
          'status': 'Order Confirmed',
          'timestamp': FieldValue.serverTimestamp(),
        });



        // Navigate to DeliveredScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => DeliveredScreen()),
        );
      } catch (e) {
        print('Error adding order to Firestore: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFE6EBEF), Color(0xFFFFFFFF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFE2EDF4),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ShippingScreen()),
              );
            },
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(
                'Select a Payment Method',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Card(
                color: Colors.white,
                elevation: 1.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2.0),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: isCheckboxChecked,
                    onChanged: (value) {
                      setState(() {
                        isCheckboxChecked = value!;
                      });
                    },
                  ),
                  title: Text(
                    'Cash on Delivery',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Montserrat',
                      fontSize: screenWidth * 0.045,
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              Align(
                alignment: Alignment.center,
                child: Text(
                  '*Parcel delivered to your door. Tip the rider!*',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.blueGrey,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
              Spacer(),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: placeOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFB3C6D1),
                      padding:
                          EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                      elevation: 1.0,
                    ),
                    child: Text(
                      'Place Order',
                      style: TextStyle(
                        fontSize: screenWidth * 0.045,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
            ],
          ),
        ),
      ),
    );
  }
}

class ElevatedCard extends StatelessWidget {
  final Widget child;

  const ElevatedCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: child,
      ),
    );
  }
}
