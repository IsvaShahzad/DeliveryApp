import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../cart_screens/cart.dart';
import '../widgets/maps.dart';
import '../widgets/progress_bar.dart';
import '../widgets/progressbar_shipping.dart';
import 'delivered_screen.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isCheckboxChecked = false;
  String userFirstName = 'User';
  String userEmail = 'user@example.com';
  String userAddress = '';
  String userArea = '';


  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
    _fetchUserAddress();
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

  Future<void> _fetchUserAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot addressDoc = await FirebaseFirestore.instance
          .collection('shippingdetails')
          .doc(user.email)
          .get();

      if (addressDoc.exists) {
        print('Fetched Address Details: ${addressDoc.data()}');
        setState(() {
          userAddress = addressDoc['Address'] ?? 'No address available';
          userArea = addressDoc['Area'] ?? 'No area available';

        });
      } else {
        print('Address document does not exist.');
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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Text(
                'Payment',
                style: TextStyle(
                  fontSize: screenWidth * 0.06,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ProgressBarShipping(
            steps: ['Menu', 'Cart', 'Payment'],
            currentIndex: 1, // Adjust this based on the current step
          ),
          SizedBox(height: 10),
          Card(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.grey[200],
                  child: Text(
                    'Delivery Address',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                ),
                MapWidget(),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '${userAddress}, ${userArea}', // Concatenate address and area
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontFamily: 'Montserrat',
                      color: Colors.black87,
                    ),
                  ),

                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: screenHeight * 0.05),
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
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
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
        ],
      ),
    );
  }
}
