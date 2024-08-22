import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shop/checkout_screens/cartscreen.dart';
import 'package:shop/checkout_screens/payment_screen.dart';
import 'package:shop/screens/favourites.dart';
import 'package:shop/screens/mainscreen.dart';
import 'package:shop/screens/splash_screen.dart';

import 'package:provider/provider.dart';
import 'cart_screens/cart.dart';
import 'Providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // final Cart cart = Cart();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FavouriteProductPageProvider>(
          create: (_) => FavouriteProductPageProvider(),
        ),
        ChangeNotifierProvider<CartProvider>(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider<Cart>(
          create: (_) => Cart(),
        ),

        // Add other providers here if needed
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 804),
        minTextAdapt: true,
        builder: (BuildContext context, Widget? child) {
          return MaterialApp(
            theme: ThemeData(
              scaffoldBackgroundColor: Color(0xffffa7a6),
              primarySwatch: Colors.purple,
              // accentColor: Colors.pink,
              inputDecorationTheme: const InputDecorationTheme(),
            ),
            home: MainScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: FirestoreTestScreen(),
//     );
//   }
// }
//
// class FirestoreTestScreen extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<void> addTestData() async {
//     try {
//       // Create a collection named 'test_collection' and add a document
//       await _firestore.collection('test_collection').add({
//         'field1': 'value1',
//         'field2': 123,
//         'field3': DateTime.now().toString(),
//       });
//       print('Data added successfully.');
//     } catch (e) {
//       print('Error adding data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Firestore Test'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () async {
//             await addTestData();
//             // Optionally, show a message to the user
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text('Check the console for Firestore status.'),
//               ),
//             );
//           },
//           child: Text('Add Test Data to Firestore'),
//         ),
//       ),
//     );
//   }
// }
