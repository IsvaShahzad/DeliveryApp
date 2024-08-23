import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressScreen extends StatefulWidget {
  final String postalCode;
  final String mobileNumber;
  final String address;
  final String province;

  AddressScreen({
    required this.postalCode,
    required this.mobileNumber,
    required this.address,
    required this.province,
  });

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _postalCodeController = TextEditingController();
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
        _postalCodeController.text = prefs.getString('postalCode') ?? widget.postalCode;
        _mobileController.text = prefs.getString('mobileNumber') ?? widget.mobileNumber;
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
          _postalCodeController.text = data?['Postal Code'] ?? _postalCodeController.text;
          _mobileController.text = data?['Mobile Number'] ?? _mobileController.text;
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
          await prefs.setString('postalCode', _postalCodeController.text);
          await prefs.setString('mobileNumber', _mobileController.text);
          await prefs.setString('address', _addressController.text);
          await prefs.setString('province', _selectedProvince);

          Navigator.pop(context);
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Address'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              TextFormField(
                controller: _postalCodeController,
                decoration: InputDecoration(labelText: 'Postal Code'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter postal code';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _mobileController,
                decoration: InputDecoration(labelText: 'Mobile Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter address';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                value: _provinceOptions.contains(_selectedProvince) ? _selectedProvince : null,
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
                  labelText: 'Area',
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
                isExpanded: true,
              ),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: _saveAddress,
                child: Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
