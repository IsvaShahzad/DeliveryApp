import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/mainscreen.dart';

class Profile extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

final _formKey = GlobalKey<FormState>();

late String _name = "";
late String _email = "";
late String _mobile = "";
late String _pincode = "";
late String _state = "";

class MapScreenState extends State<Profile>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  String email = "";

  // final FocusNode myFocusNode = FocusNode();
  final TextEditingController NameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController MobileController = TextEditingController();
  final TextEditingController PincodeController = TextEditingController();
  // final TextEditingController StateController = TextEditingController();

  late XFile file;
  var _isLoading = false;
  ShowAlert() {

    return showDialog(

      context: context,
      builder: (ctx) => AlertDialog(
        title: Align(
          alignment: Alignment.center,
          child: Text(
            "Profile updated!",
            style: TextStyle(fontFamily: 'Montserrat', fontSize: 19),
          ),
        ),
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF9AB3C3),
                elevation: 3,
                minimumSize: const Size(150, 50),
                maximumSize: const Size(150, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
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
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
          )
        ],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Makes the AlertDialog square
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    loadSavedProfile();
  }

  void loadSavedProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      NameController.text = prefs.getString('name') ?? '';
      EmailController.text = prefs.getString('email') ?? '';
      MobileController.text = prefs.getString('mobile') ?? '';
      PincodeController.text = prefs.getString('pincode') ?? '';
      // StateController.text = prefs.getString('state') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/page5.png"), fit: BoxFit.cover)),
      child: Scaffold(
          backgroundColor: Color(0xFFE2EDF4),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(13),
                bottomLeft: Radius.circular(12),
              ),
            ),
            leading: Transform.translate(
              offset: Offset(0, -8), // Move the icon 8 pixels up
              child: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.grey[600],
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
          body: Container(
            child: Form(
              // color: Colors.white,
              child: new ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      new Container(
                        height: 90.0,
                        color: Colors.transparent,
                        child: new Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 0.0),
                              child: new Stack(
                                  fit: StackFit.loose,
                                  children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 90.0, right: 100.0),
                                        child: new Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[],
                                        )),
                                  ]),
                            )
                          ],
                        ),
                      ),
                      new Container(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 25.0,
                                    right: 25.0,
                                  ),
                                  child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Text(
                                            'Personal Information',
                                            style: TextStyle(
                                                fontSize: 22.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          _status
                                              ? _getEditIcon()
                                              : new Container(),
                                        ],
                                      )
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 45.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Name',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          controller: NameController,
                                          decoration: const InputDecoration(
                                            hintText: "Enter Your Name",
                                            hintStyle: TextStyle(
                                              color: Colors.grey, // Change this to your desired color
                                              fontSize: 14,       // You can also adjust the font size if needed
                                            ),
                                          ),

                                          textInputAction: TextInputAction.next,
                                          enabled: !_status,
                                          autofocus: !_status,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _name = value!,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Email ID',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          controller: EmailController,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Email ID",
                                            hintStyle: TextStyle(
                                              color: Colors.grey, // Change this to your desired color
                                              fontSize: 14,       // You can also adjust the font size if needed
                                            ),

                                          ),
                                          textInputAction: TextInputAction.next,
                                          enabled: !_status,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _email = value!,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          new Text(
                                            'Mobile',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ],
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Flexible(
                                        child: new TextFormField(
                                          controller: MobileController,
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                              hintText: "Enter Mobile Number",
                                            hintStyle: TextStyle(
                                              color: Colors.grey, // Change this to your desired color
                                              fontSize: 14,       // You can also adjust the font size if needed
                                            ),
                                          ),
                                          textInputAction: TextInputAction.next,
                                          enabled: !_status,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please enter your name';
                                            }
                                            return null;
                                          },
                                          onSaved: (value) => _mobile = value!,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 25.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                          child: new Text(
                                            'Pin Code',
                                            style: TextStyle(
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                                fontFamily: 'Montserrat'),
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      // Expanded(
                                      //   child: Container(
                                      //     child: new Text(
                                      //       'State',
                                      //       style: TextStyle(
                                      //         fontSize: 16.0,
                                      //         fontWeight: FontWeight.bold,
                                      //         color: Color(0xffcc9a9d),
                                      //         fontFamily: 'Montserrat'
                                      //       ),
                                      //     ),
                                      //   ),
                                      //   flex: 2,
                                      // ),
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      left: 25.0, right: 25.0, top: 2.0),
                                  child: new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: EdgeInsets.only(right: 10.0),
                                          child: new TextFormField(
                                            controller: PincodeController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                                hintText: "Enter Pin Code",
                                              hintStyle: TextStyle(
                                                color: Colors.grey, // Change this to your desired color
                                                fontSize: 14,       // You can also adjust the font size if needed
                                              ),
                                            ),
                                            textInputAction:
                                                TextInputAction.next,
                                            enabled: !_status,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter your name';
                                              }
                                              return null;
                                            },
                                            onSaved: (value) =>
                                                _pincode = value!,
                                          ),
                                        ),
                                        flex: 2,
                                      ),
                                      // Flexible(
                                      //   child: new TextFormField(
                                      //     controller: StateController,
                                      //     decoration: const InputDecoration(
                                      //       hintText: "Enter State",
                                      //     ),
                                      //     enabled: !_status,
                                      //     validator: (value) {
                                      //       if (value!.isEmpty) {
                                      //         return 'Please enter your name';
                                      //       }
                                      //       return null;
                                      //     },
                                      //     onSaved: (value) => _state = value!,
                                      //   ),
                                      //   flex: 2,
                                      // ),
                                    ],
                                  )),
                              !_status ? _getActionButtons() : new Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }

  // @override
  // void dispose() {
  //   // Clean up the controller when the Widget is disposed
  //   myFocusNode.dispose();
  //   super.dispose();
  // }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF9AB3C3),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(2.0),
                  ),
                  elevation: 1,
                  minimumSize: const Size(130, 45),
                  maximumSize: const Size(130, 45),
                ),
                child: new Text(
                  "Save",
                  style: TextStyle(fontSize: 15, fontFamily: 'Montserrat'),
                ),
                // textColor: Colors.white,
                // color: Colors.green,is

                onPressed: saveProfile,
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Color(0xFF9AB3C3),
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(2.0),
                  ),
                  elevation: 1,
                  minimumSize: const Size(130, 45),
                  maximumSize: const Size(130, 45),
                ),
                child: new Text(
                  "Cancel",
                  style: TextStyle(fontFamily: 'Montserrat', fontSize: 15),
                ),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }

  void saveProfile() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', NameController.text);
      await prefs.setString('email', EmailController.text);
      await prefs.setString('pincode', PincodeController.text);
      await prefs.setString('mobile', MobileController.text);

      // Get a reference to the Firestore collection
      CollectionReference portfolioCollection =
      FirebaseFirestore.instance.collection('userprofile');

      // Use the email as the document ID
      await portfolioCollection.doc(EmailController.text).set({
        'username': NameController.text,
        'email': EmailController.text,
        'pincode': PincodeController.text,
        'mobile': MobileController.text,
      });

      print('Profile data saved to Firestore');
      ShowAlert();
    } catch (e) {
      print('Error saving profile data: $e');
    }
  }
}
