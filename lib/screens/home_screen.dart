import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shop/screens/email_login.dart';
import 'package:shop/screens/splash_screen.dart';

import 'mainscreen.dart';

class HomeScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      // Sign out from Google to prompt account selection
      await _googleSignIn.signOut();

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential using the token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Update user data in Firestore
        final userDoc = FirebaseFirestore.instance.collection('users').doc(user.email);
        await userDoc.set({
          'firstname': user.displayName ?? 'User',
          'email': user.email,
        }, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed in as ${user.displayName}')),
        );
        // Navigate to the MainScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: double.infinity,
            child: Image.asset(
              'assets/images/food.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 3,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white, size: 22),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ),
                );
              },
            ),
          ),
          Positioned(
            top: screenHeight / 2,
            left: 0,
            right: 0,
            child: Container(
              height: screenHeight / 2,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(right: 160),
                            child: Text(
                              'Sign up or Log in',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(right: 60),
                            child: Text(
                              'Select your preferred method to continue',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Montserrat',
                                color: Colors.black87,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => _signInWithGoogle(context),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 11),
                      side: BorderSide(color: Colors.grey[400]!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.jpg', height: 24.0),
                        SizedBox(width: 10),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      // Add your Facebook sign-in logic here
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      elevation: 0,
                      backgroundColor: Colors.blue[700],
                      padding: EdgeInsets.symmetric(vertical: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.facebook, color: Colors.white, size: 24.0),
                        SizedBox(width: 10),
                        Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Text(
                            'Continue with Facebook',
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontFamily: 'Montserrat',
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => EmailLoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0.5,
                      foregroundColor: Colors.black87,
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 11),
                      side: BorderSide(color: Color(0xff7393B3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email_outlined, color: Color(0xff7393B3), size: 20.0),
                        SizedBox(width: 20),
                        Text(
                          'Continue with Email',
                          style: TextStyle(
                            color: Color(0xff7393B3),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
