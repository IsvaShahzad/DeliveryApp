import 'package:flutter/material.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/mainscreen.dart';

class ContactUsScreen extends StatefulWidget {


  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine padding and font sizes based on available width
        double horizontalPadding = constraints.maxWidth * 0.04;
        double fontSize = constraints.maxWidth > 600 ? 18.0 : 16.0;
        double titleFontSize = constraints.maxWidth > 600 ? 24.0 : 22.0;
        double contactFontSize = constraints.maxWidth > 600 ? 18.0 : 16.0;
        double assistanceFontSize = constraints.maxWidth > 600 ? 15.0 : 13.0;

        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/page5.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(13),
                  bottomLeft: Radius.circular(12),
                ),
              ),
              leading: Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Color(0xffb38e8e),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: constraints.maxHeight * 0.1),
                  Text(
                    "We're dedicated to assisting you. For any questions or support, please contact us using the information provided.",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.03),
                  Text(
                    'For Contact:',
                    style: TextStyle(
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.025),
                  Text(
                    'Email: charmedservices@gmail.com',
                    style: TextStyle(
                      fontSize: contactFontSize,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.012),
                  Text(
                    'Phone: 03335206478',
                    style: TextStyle(
                      fontSize: contactFontSize,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '* Assistance is available 24/7 *',
                      style: TextStyle(
                        fontSize: assistanceFontSize,
                        color: Colors.blueGrey,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
