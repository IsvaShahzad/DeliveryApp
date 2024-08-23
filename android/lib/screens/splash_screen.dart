import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import your home screen or next screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the HomeScreen after 3 seconds
    Timer(Duration(seconds: 4), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/burger.jpeg'), // Path to your image
            fit: BoxFit.cover, // Cover the entire screen
          ),
        ),
      ),
    );
  }
}
