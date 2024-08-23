import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop/screens/email_login.dart';
import '../../Providers/cart_provider.dart';
import '../cart_screens/cart_items.dart';
import '../cart_screens/cart.dart' as cartt;
import '../checkout_screens/cartscreen.dart' as cartscreen;

import 'package:badges/badges.dart' as badges;

import '../screens/favourites.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productName;
  final String id;
  final double productPrice;
  final String productDescription;
  final String ImageURL;
  final String companyName;

  const ProductDetailScreen({
    Key? key,
    required this.productName,
    required this.id,
    required this.productPrice,
    required this.productDescription,
    required this.ImageURL,
    required this.companyName,
  }) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _prefs = prefs;
        String key = '${widget.productName}_${widget.productPrice}';

        _isFavorite = _prefs.getBool(key) ?? false;
      });
    });
  }
  //
  // void navigateToSellerPortfolio(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => Portf()),
  //   );
  // }

  void showCartMessage(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Added to Cart',
            style: TextStyle(fontFamily: 'Montserrat'),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => cartscreen.CartScreen(
                    cart: Provider.of<cartt.Cart>(context, listen: false),
                    cartProvider:
                        Provider.of<CartProvider>(context, listen: false),
                  ),
                ),
              );
            },
            child: Text(
              'Go to Cart',
              style: TextStyle(color: Colors.blue, fontFamily: 'Montserrat'),
            ),
          ),
        ],
      ),
      duration: Duration(seconds: 5),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController urlController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final favoriteProductsModel =
        Provider.of<FavouriteProductPageProvider>(context, listen: false);

    void _showFavoriteOptions(BuildContext context) {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.favorite_border),
                title: Text(
                  'Favourites',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FavoriteProductsPage(
                              ImageURL: widget.ImageURL,
                              productName: widget.productName,
                              productDescription: widget.productDescription,
                              productPrice: widget.productPrice,
                            )),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  'Logout',
                  style: TextStyle(fontFamily: 'Montserrat'),
                ),
                onTap: () {
                  // Perform the logout action
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EmailLoginScreen()),
                  );
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/pastel.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 250.0,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      widget.ImageURL,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 30.0,
                      left: 10.0,
                      right: 10.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          cartscreen.CartScreen(
                                        cart: Provider.of<cartt.Cart>(context,
                                            listen: false),
                                        cartProvider: Provider.of<CartProvider>(
                                            context,
                                            listen: false),
                                      ),
                                    ),
                                  );
                                },
                                child: badges.Badge(
                                  child: Icon(Icons.shopping_bag_outlined,
                                      color: Colors.white),
                                  badgeContent: Consumer<CartProvider>(
                                    builder: (context, cartProvider, child) {
                                      return Text(
                                        cartProvider.counter.toString(),
                                        style: TextStyle(color: Colors.white),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                icon:
                                    Icon(Icons.more_vert, color: Colors.white),
                                onPressed: () {
                                  _showFavoriteOptions(context);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 11.0),
                    child: Text(
                      widget.productName,
                      style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      '${widget.productDescription}',
                      style:
                          TextStyle(fontSize: 14.0, fontFamily: 'Montserrat'),
                    ),
                  ),
                  SizedBox(height: 15.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'Rs. ${widget.productPrice.toStringAsFixed(0)}',
                      style:
                          TextStyle(fontSize: 15.0, fontFamily: 'Montserrat', fontWeight: FontWeight.w600),
                    ),
                  ),
                  SizedBox(height: 70.0),
                  Align(
                    alignment: Alignment.center,
                    child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          CartItem item = CartItem(
                            name: widget.productName,
                            price: widget.productPrice,
                            imageUrl: widget.ImageURL,
                            id: null,
                          );
                          Provider.of<CartProvider>(context, listen: false)
                              .addCartItem(item);

                          showCartMessage(context);
                          print('Added to cart: $item');
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_outlined),
                          SizedBox(width: 8.0),
                          Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Color(0xFF9AB3C3),
                        elevation: 0.5,
                        minimumSize: const Size(270, 50),
                        maximumSize: const Size(270, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(width: 75.0),
            FloatingActionButton(
              elevation: 1.0,
              child: _isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                });

                final product = Product(
                  ImageURL: widget.ImageURL,
                  productName: widget.productName,
                  productDescription: widget.productDescription,
                  productPrice: widget.productPrice,
                );

                // Add or remove from favorites
                if (_isFavorite) {
                  favoriteProductsModel.addFavoriteProduct(product);
                  _prefs.setBool(
                      '${widget.productName}_${widget.productPrice}', true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added to favorites')),
                  );
                } else {
                  favoriteProductsModel.removeFavoriteProduct(product);
                  _prefs.setBool(
                      '${widget.productName}_${widget.productPrice}', false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Removed from favorites')),
                  );
                }
              },
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
            ),
            SizedBox(width: 8.0),
          ],
        ),
      ),
    );
  }
}
