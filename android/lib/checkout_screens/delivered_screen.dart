import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/mainscreen.dart';

class DeliveredScreen extends StatefulWidget {
  @override
  _DeliveredScreenState createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends State<DeliveredScreen> {
  late ConfettiController _confettiController;
  double _rating = 0;
  final CollectionReference ratingsCollection = FirebaseFirestore.instance.collection('ratings');

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(milliseconds: 800));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void triggerConfetti() {
    _confettiController.play();
  }

  Future<void> _storeRating() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('No user is currently logged in');
      return;
    }

    final email = user.email ?? 'unknown@example.com';

    try {
      await ratingsCollection.doc(email).set({
        'rating': _rating,
        // Add other relevant data here if needed
      });
      print('Rating stored in Firestore!');
    } catch (e) {
      print('Failed to store rating: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/mainpage.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Color(0xFFE2EDF4),
        body: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 100.0),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Order Placed Successfully!',
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF9AB3C3),
                          elevation: 1,
                          minimumSize: const Size(230, 50),
                          maximumSize: const Size(230, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => MainScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Add more items to cart',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Or',
                        style: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Align(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color(0xFF9AB3C3),
                          elevation: 1,
                          minimumSize: const Size(230, 50),
                          maximumSize: const Size(230, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                elevation: 0,
                                title: Column(
                                  children: [
                                    Text(
                                      "Your order will be delivered in 40 minutes!⏳",
                                      style: TextStyle(
                                        fontSize: 17.0,
                                        color: Colors.black87,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  Align(
                                    alignment: Alignment.center,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor: Color(0xFF9AB3C3),
                                        elevation: 6,
                                        minimumSize: const Size(140, 45),
                                        maximumSize: const Size(140, 45),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(0.0),
                                        ),
                                      ),
                                      child: Text(
                                        'OK',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text(
                          'Order Status',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Align(
                        alignment: Alignment.center,
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                          ),
                          child: Container(
                            padding: EdgeInsets.all(16.0),
                            width: 250.0,
                            height: 220.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Rate Us',
                                  style: TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                                SizedBox(height: 10.0),
                                RatingBar.builder(
                                  initialRating: _rating,
                                  minRating: 1,
                                  direction: Axis.horizontal,
                                  allowHalfRating: true,
                                  itemCount: 5,
                                  itemSize: 30.0,
                                  unratedColor: Colors.grey,
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.orangeAccent,
                                  ),
                                  onRatingUpdate: (rating) {
                                    setState(() {
                                      _rating = rating;
                                    });
                                  },
                                ),
                                SizedBox(height: 16.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 1,
                                    minimumSize: const Size(160, 40),
                                    foregroundColor: Colors.white,
                                    backgroundColor: Color(0xFF9AB3C3),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text(
                                            "Thank you for rating! ⭐",
                                            style: TextStyle(
                                              fontFamily: 'Montserrat',
                                              fontSize: 19,
                                            ),
                                          ),
                                          actions: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: Color(0xFF9AB3C3),
                                                  elevation: 1,
                                                  minimumSize: const Size(150, 45),
                                                  maximumSize: const Size(150, 45),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(2.0),
                                                  ),
                                                ),
                                                child: Text(
                                                  'OK',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontFamily: 'Montserrat',
                                                  ),
                                                ),
                                                onPressed: () {
                                                  // Store the rating in Firebase
                                                  _storeRating().then((_) {
                                                    Navigator.pop(context);
                                                  }).catchError((error) {
                                                    print('Failed to store rating: $error');
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: const Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                    ),
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
          ],
        ),
      ),
    );
  }
}
