import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shop/screens/email_signup.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/mainscreen.dart';

class EmailLoginScreen extends StatefulWidget {
  @override
  _EmailLoginScreenState createState() => _EmailLoginScreenState();
}

class _EmailLoginScreenState extends State<EmailLoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  Future<void> loginUser() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch sign-in methods associated with the email
      final signInMethods = await _auth.fetchSignInMethodsForEmail(_emailController.text);

      if (signInMethods.isNotEmpty) {
        User? user = (await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        )).user;

        if (user != null) {
          if (user.emailVerified) {
            // Email is verified
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          } else {
            // Email not verified
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Please verify your email before logging in."),
                backgroundColor: Colors.red,
              ),
            );
            await user.sendEmailVerification(); // Optionally, send a new verification email
            await _auth.signOut(); // Sign out the user until they verify their email
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Email does not exist. You can create a new account."),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login failed. Please check your credentials."),
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Positioned image and back arrow button
                  Stack(
                    children: [
                      Positioned(
                        top: 20,
                        right: 295,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back, color: Color(0xFF7393B3)),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) => HomeScreen()),
                            );
                          },
                        ),
                      ),
                      // Positioned image and text
                      Positioned(
                        top: 80, // Adjust as needed
                        right: 230,
                        child: Image.asset(
                          'assets/images/emailpassimage.png', // Replace with your image path
                          height: 80,
                          width: 100,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 190), // Adjust padding for the top space
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "What's your email?",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Kanit',
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "We'll check if you have an account.",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[800],
                                fontFamily: 'Montserrat',
                              ),
                            ),
                            SizedBox(height: 30),
                            // Email TextField
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0),
                              child: TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Email',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Password TextField
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 3.0),
                              child: TextField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade400),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(2),
                                    borderSide: BorderSide(color: Colors.grey.shade500),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 18),
                                ),
                              ),
                            ),
                            SizedBox(height: 140),
                            // Continue Button
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : loginUser,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Color(0xFF7F9BB3),
                                  minimumSize: Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                'or',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontFamily: 'Montserrat',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => EmailSignUpScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 0.5,
                                foregroundColor: Colors.black87,
                                backgroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 48),
                                padding: EdgeInsets.symmetric(vertical: 11),
                                side: BorderSide(color: Color(0xff7393B3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.email_rounded,
                                      color: Color(0xff7393B3), size: 20.0),
                                  SizedBox(width: 20),
                                  Text(
                                    'Sign up with email',
                                    style: TextStyle(
                                      color: Color(0xff7393B3),
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}