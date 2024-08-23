import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/screens/email_login.dart';
import 'package:shop/screens/email_signup.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  Future<void> sendVerificationEmail() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = _auth.currentUser;
      await user?.sendEmailVerification();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Verification email sent!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to send email: Too many requests. Try again later"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {


            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => EmailSignUpScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 90,
              height: 100, // Adjust height as needed
              child: Image.asset(
                'assets/images/emailpassimage.png', // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Welcome!\n",
                    style: TextStyle(
                      fontSize: 22, // Larger font size for heading
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                        height: 2, // Adjust line height to add space between lines
                        fontFamily: 'Montserrat'
                    ),
                  ),

                  TextSpan(
                    text: "Good to see you. Please verify your email to continue.",
                    style: TextStyle(
                      fontSize: 14, // Smaller font size for the rest of the text
                      color: Colors.grey[700],
                      fontFamily: 'Montserrat',
                      height: 1.5, // Adjust line height to add space between lines


                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 90),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0, backgroundColor: Color(0xff7393B3),foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(2), // Adjust the border radius for the circular effect
                ),
                minimumSize: Size(double.infinity, 48), // Make the button longer and taller
                padding: EdgeInsets.symmetric(vertical: 12, horizontal:15), // Background color
              ),
              onPressed: _isLoading ? null : () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                );
              },
              child: _isLoading
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : Text(
                "I've Verified!",
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15, // Adjust the font size as needed
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}
