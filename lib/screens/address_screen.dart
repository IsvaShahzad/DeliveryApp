import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  final String mobileNumber;
  final String address;
  final String province;

  AddressScreen({
    required this.mobileNumber,
    required this.address,
    required this.province,
  });

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String _selectedProvince = '';

  final List<String> _provinceOptions = [
    'Bahria Phase 1-4',
    'Bahria Phase 7-8',
    'DHA Phase 1',
    'DHA Phase 2',
    'Gulraiz',
    'Chaklala',
    'Pwd'
  ];

  bool _isEditing = false; // Toggle for edit mode

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final prefs = await SharedPreferences.getInstance();

      setState(() {
        _mobileController.text =
            prefs.getString('mobileNumber') ?? widget.mobileNumber;
        _addressController.text = prefs.getString('address') ?? widget.address;
        _selectedProvince = prefs.getString('province') ?? widget.province;
      });

      final addressDoc = await FirebaseFirestore.instance
          .collection('shippingdetails')
          .doc(user.email)
          .get();

      if (addressDoc.exists) {
        final data = addressDoc.data() as Map<String, dynamic>?;

        setState(() {
          _mobileController.text =
              data?['Mobile Number'] ?? _mobileController.text;
          _addressController.text = data?['Address'] ?? _addressController.text;
          _selectedProvince = data?['Area'] ?? _selectedProvince;
        });
      }
    }
  }

  Future<void> _saveAddress() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (_formKey.currentState?.validate() ?? false) {
        try {
          await FirebaseFirestore.instance
              .collection('shippingdetails')
              .doc(user.email)
              .set({
            'Email': user.email ?? 'Unknown',
            'Mobile Number': _mobileController.text,
            'Address': _addressController.text,
            'Area': _selectedProvince,
          });

          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('mobileNumber', _mobileController.text);
          await prefs.setString('address', _addressController.text);
          await prefs.setString('province', _selectedProvince);

          setState(() {
            _isEditing = false; // Exit edit mode after saving
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Address saved successfully!')),
          );
        } catch (e) {
          print('Error saving address: $e');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving address. Please try again.')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            'Address',
            style: TextStyle(
              fontFamily: 'Kanit', fontSize: 22, letterSpacing: 0.5,
            ),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      color: Colors.white,
                      elevation: 1.5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0), // Square corners
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            title: _isEditing
                                ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _addressController,
                                  keyboardType: TextInputType.text,
                                  maxLines: 3,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your Address',
                                    hintStyle: TextStyle(
                                      fontSize: 12.0, // Adjust font size
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  cursorColor: Colors.grey,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter address';
                                    }
                                    return null;
                                  },
                                ),
                                TextFormField(
                                  controller: _mobileController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your mobile number',
                                    hintStyle: TextStyle(
                                      fontSize: 12.0, // Adjust font size
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  cursorColor: Colors.grey,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter mobile number';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 8.0), // Spacing between fields
                                DropdownButtonFormField<String>(
                                  value: _provinceOptions
                                      .contains(_selectedProvince)
                                      ? _selectedProvince
                                      : null,
                                  items: _provinceOptions.map((province) {
                                    return DropdownMenuItem<String>(
                                      value: province,
                                      child: Text(province),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedProvince = value ?? '';
                                    });
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Select your area',
                                    hintStyle: TextStyle(
                                      fontSize: 12.0, // Adjust font size
                                      color: Colors.grey,
                                      fontFamily: 'Montserrat',
                                    ),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                  dropdownColor: Colors.white,
                                ),
                              ],
                            )
                                : Card(
                              color: Colors.white,
                              elevation: 1.5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(10.0.w),
                                leading: Icon(Icons.location_on,
                                    color: Colors.blue),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_addressController.text}',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15),
                                    ),
                                    Text('$_selectedProvince',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat',
                                            fontSize: 15)),
                                    Text(
                                      '${_mobileController.text}',
                                      style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(_isEditing
                                          ? Icons.check
                                          : Icons.edit),
                                      onPressed: () {
                                        if (_isEditing) {
                                          if (_formKey.currentState
                                              ?.validate() ??
                                              false) {
                                            _saveAddress();
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Please correct the errors in the form.')),
                                            );
                                          }
                                        } else {
                                          setState(() {
                                            _isEditing = true;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          if (_isEditing) // Only show save button in edit mode
                            Center(
                              child: SizedBox(
                                width: 280.0,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: _saveAddress,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFFB3C6D1),
                                    padding: EdgeInsets.symmetric(
                                        vertical: screenHeight * 0.02),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2.0),
                                    ),
                                    elevation: 1.0,
                                  ),
                                  child: Text(
                                    'Save ',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        color: Colors.white,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ]),
            ),
          ),
        ));
  }
}


