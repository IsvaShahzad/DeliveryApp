import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:provider/provider.dart';
import 'package:shop/screens/email_login.dart';

import '../main.dart';

class Product with ChangeNotifier {
  final String ImageURL;
  final String productName;
  final String productDescription;
  final double productPrice;

  Product({
    required this.ImageURL,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Product &&
              runtimeType == other.runtimeType &&
              ImageURL == other.ImageURL &&
              productName == other.productName &&
              productDescription == other.productDescription &&
              productPrice == other.productPrice;

  @override
  int get hashCode =>
      ImageURL.hashCode ^
      productName.hashCode ^
      productDescription.hashCode ^
      productPrice.hashCode;
}

class FavouriteProductPageProvider extends ChangeNotifier {
  List<Product> _favoriteProducts = [];

  List<Product> get favoriteProducts => _favoriteProducts;

  bool isFavorite(Product product) {
    return _favoriteProducts.contains(product);
  }

  void addFavoriteProduct(Product product) {
    print('Adding product $product to favorites');

    _favoriteProducts.add(product);
    print('Favorite products: $_favoriteProducts');
    notifyListeners();
  }

  void removeFavoriteProduct(Product product) {
    print('Removing product $product from favorites');
    _favoriteProducts.remove(product);
    print('Favorite products: $_favoriteProducts');

    notifyListeners();
  }
}

class FavoriteProductsPage extends StatefulWidget {
  final String ImageURL;
  final String productName;
  final String productDescription;
  final double productPrice;

  const FavoriteProductsPage({
    required this.ImageURL,
    required this.productName,
    required this.productDescription,
    required this.productPrice,
  });

  @override
  _FavoriteProductsPageState createState() => _FavoriteProductsPageState();
}

class _FavoriteProductsPageState extends State<FavoriteProductsPage> {
  @override
  Widget build(BuildContext context) {
    final model = context.read<FavouriteProductPageProvider>();
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/page8.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EmailLoginScreen(),
                  ),
                );
              },
            ),
          ],
        ),
        body: Container(
          child: Padding(
            padding: EdgeInsets.only(top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: model.favoriteProducts.isEmpty
                      ? Center(
                    child: Text(
                      "No products added",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        fontFamily: 'Montserrat'
                      ),
                    ),
                  )
                      : GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Two products per row
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.7, // Adjust to fit your design
                    ),
                    itemCount: model.favoriteProducts.length,
                    itemBuilder: (context, index) {
                      final product = model.favoriteProducts[index];

                      return Card(
                        elevation: 2,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: Stack(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(2),
                                  ),
                                  child: Image.network(
                                    product.ImageURL,
                                    height: 120, // Adjust the height to fit the grid
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.productName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Rs.${product.productPrice.toStringAsFixed(0)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 160,
                              right: 0,
                              child: IconButton(
                                icon: Icon(Icons.favorite, color: Colors.red),
                                onPressed: () {
                                  // Add your favorite button functionality here
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
