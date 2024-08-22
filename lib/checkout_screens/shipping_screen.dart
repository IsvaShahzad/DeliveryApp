import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/progressbar_shipping.dart';
import '../../cart_screens/cart.dart' as cartt;
import '../../Providers/cart_provider.dart';
import '../widgets/progress_bar.dart';
import 'cartscreen.dart' as cartscreen;
import 'payment_screen.dart';

class ShippingScreen extends StatefulWidget {
  @override
  State<ShippingScreen> createState() => _ShippingScreenState();
}

class _ShippingScreenState extends State<ShippingScreen> {
  List<String> provinceOptions = [
    'Bahria(Phase 1-8)',
    'DHA(Phase 1-2)',
    'Gulraiz',
    'PWD',
    'Chaklala'
  ];
  String _selectedProvince = 'Chaklala';
  bool _expressDelivery = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController mobileController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  final _auth = FirebaseAuth.instance;
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
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        setState(() {
          userFirstName = userDoc['firstname'] ?? 'User';
          userEmail = user.email ?? 'user@example.com';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/page4.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFE2EDF4),
        body: Form(
          key: _formKey,
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(vertical: 23.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.grey[600],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => cartscreen.CartScreen(
                                  cart: context.read<cartt.Cart>(),
                                  cartProvider: context.read<CartProvider>(),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 5), // Adjust the width as needed for spacing
                       Text(
                          'Payment',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                          ),
                        ),
                      ],
                    ),
                  ),

                  ProgressBarShipping(
                    steps: ['Menu', 'Cart', 'Payment'],
                    currentIndex: 1,
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Container(
                      height: 620,
                      width: 370,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 5.h),
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: postalCodeController,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF000000),
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white12.withOpacity(0.9),
                                    hintText: 'Enter Postal Code',
                                    hintStyle: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Some Text';
                                    } else if (value.length > 20) {
                                      return 'Enter less than 20 numbers';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: mobileController,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF000000),
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    hintText: 'Enter Your Mobile number',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Some Text';
                                    } else if (value.length > 20) {
                                      return 'Enter less than 20 numbers';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              Container(
                                child: TextFormField(
                                  controller: addressController,
                                  maxLines: 5,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF000000),
                                  ),
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.white.withOpacity(0.9),
                                    hintText:
                                    'Enter Delivery Address / Landmark',
                                    hintStyle: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter Some Text';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              SizedBox(height: 10.h),
                              DropdownButtonFormField(
                                value: _selectedProvince,
                                items: provinceOptions.map((category) {
                                  return DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.9),
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                    horizontal: 10.0,
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                ),
                                onChanged: (selectedCategory) {
                                  setState(() {
                                    _selectedProvince =
                                        selectedCategory.toString();
                                  });
                                },
                              ),
                              SizedBox(height: 50.h),
                              Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF9AB3C3),
                                    elevation: 1,
                                    minimumSize: const Size(250, 50),
                                    maximumSize: const Size(250, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                  ),
                                  child: Text(
                                    'Checkout',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Montserrat',
                                      fontSize: 18,
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (_formKey.currentState != null &&
                                        _formKey.currentState!.validate()) {
                                      try {
                                        User? user = _auth.currentUser;
                                        if (user != null) {

                                          await FirebaseFirestore.instance
                                              .collection('shippingdetails')
                                              .doc(user.email)
                                              .set({
                                            'Email': user.email ?? 'Unknown',
                                            'Postal Code':
                                            postalCodeController.text,
                                            'Mobile Number':
                                            mobileController.text,
                                            'Address': addressController.text,
                                            'Province': _selectedProvince,
                                          });
                                        }
                                      } catch (e) {
                                        print(
                                            'Error adding shipping details to Firestore: $e');
                                      }

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              PaymentScreen(),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
