import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:shop/order_history/order_history.dart';
import 'package:shop/screens/favourites.dart';
import 'package:shop/screens/home_screen.dart';
import 'package:shop/screens/profile.dart';
import '../cart_screens/cart.dart' as cartt;
import '../cart_screens/cart.dart';
import '../checkout_screens/cartscreen.dart' as cartscreen;
import '../Providers/cart_provider.dart';

import '../checkout_screens/cartscreen.dart';
import '../widgets/parallax effect.dart';
import '../widgets/imagepaths.dart';
import '../widgets/vertical_grid.dart';
import 'contact_us.dart';
import 'product_view_screen.dart';
import 'email_login.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Stream<QuerySnapshot> _streamCategory;
  final CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('categories');
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _streamCategory = _collectionRef.snapshots();
    _fetchUserName();
    _streamCategory = categoriesStream; // Using the stream from data.dart
    _saveCategoriesToFirestore(); // Save categories on init
  }



  List<String> allTitles = [
    ...titlesMain,
    ...titlesCuisineForYou,
    ...titlesHotDeals,
    ...titleDesiDesire
  ];

  Future<void> _fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.email)
          .get();
      if (userDoc.exists) {
        setState(() {
          userFirstName = userDoc['firstname'] ?? 'User';
        });
      }
    }
  }

  Future<void> _saveCategoriesToFirestore() async {
    // Implementation for saving categories
  }



  @override
  Widget build(BuildContext context) {
    // Filter titles based on search query
    final filteredTitles = allTitles
        .where((title) => title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    // Map filtered titles to their respective image paths
    final filteredImagePaths = filteredTitles
        .map((title) {
      int index;
      if (titlesMain.contains(title)) {
        index = titlesMain.indexOf(title);
        return imagePathsAllRestaurant[index];
      } else if (titlesCuisineForYou.contains(title)) {
        index = titlesCuisineForYou.indexOf(title);
        return imagePathsCuisinesForYou[index];
      } else if (titlesHotDeals.contains(title)) {
        index = titlesHotDeals.indexOf(title);
        return imagePathsHotDeals[index];
      } else if (titleDesiDesire.contains(title)) {
        index = titleDesiDesire.indexOf(title);
        return imagepathDesiDesire[index];
      }
      return null; // Handle cases where title is not fo
      // und
    })
        .where((path) => path != null) // Filter out null paths
        .map((path) => path!) // Ensure non-null values for further operations
        .where((path) {
      final pathString = path.toLowerCase(); // Normalize the path to lowercase
      return !imagePathsStart.any((startPath) => startPath.toLowerCase() == pathString);
    }) // Exclude paths in imagePathsStart
        .toList();

    print('Filtered Titles: $filteredTitles');
    print('Filtered Image Paths: $filteredImagePaths');



    return WillPopScope(
      onWillPop: () async {
        // Returning false prevents the screen from being popped
        return false;
      },



      child: Container(



        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            title: Text(
              'Hello, $userFirstName',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to your CartScreen or perform other actions here
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(
                        cart: Provider.of<Cart>(context, listen: false),
                        cartProvider:
                            Provider.of<CartProvider>(context, listen: false),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(width: 16),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      onChanged: (query) {
                        setState(() {
                          _searchQuery = query;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search for restaurants & cuisines',
                        hintStyle: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black54,
                          size: 26,
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 0.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          borderSide: BorderSide(color: Colors.grey[100]!),
                        ),
                      ),
                      cursorColor: Colors.grey[400],
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(height: 20),

                    // Conditionally display the GridView or other widgets
                    if (_searchQuery.isNotEmpty)
                      filteredTitles.isNotEmpty
                          ?
        GridView.builder(
        scrollDirection: Axis.vertical,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 1, // Wider tiles
          ),
          itemCount: filteredTitles.length,
          itemBuilder: (_, i) {
            final title = filteredTitles[i];
            final imagePath = filteredImagePaths[i];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductViewScreen(
                      title: title,
                        imagePath: filteredImagePaths[i] ?? '', // Use the correct index to get a single image path
                      products: products[title] ?? [],
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Match the borderRadius
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            imagePath != null
                                ? (imagePath.startsWith('http') ||
                                imagePath.startsWith('https'))
                                ? Image.network(
                              imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                                : Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            )
                                : Container(
                                color: Colors.grey[300]), // Fallback placeholder
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductViewScreen(
                                title: title,
                                imagePath:  filteredImagePaths[i] ?? '',
                                products: products[title] ?? [],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat', // Match the fontFamily
                                    fontSize: MediaQuery.of(context).size.width * 0.04,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.grey[700],
                                      size: MediaQuery.of(context).size.width * 0.045,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      '30-40 mins',
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontFamily: 'Montserrat', // Match the fontFamily
                                        fontSize: MediaQuery.of(context).size.width * 0.035,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.delivery_dining,
                                        color: Colors.grey[700],
                                        size: MediaQuery.of(context).size.width * 0.055,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '₹100',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'Montserrat', // Match the fontFamily
                                          fontSize: MediaQuery.of(context).size.width * 0.035,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        )

            : Center(
                              child: Text(
                                'No results found',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                ),
                              ),
                            )
                    else ...[
                      SizedBox(
                        height:
                            220, // Fixed height for the horizontal grid view
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1.5, // Elongated tiles
                          ),
                          itemCount: 4,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                // Handle onTap for horizontal grid items
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  color: Colors.grey[200], // Placeholder color
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.asset(
                                          imagePathsStart[i],
                                          fit: BoxFit
                                              .cover, // Ensure the image covers the entire container
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.1),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20),

                      Text(
                        "Cuisines for you",
                        style: TextStyle(
                          fontSize: MediaQuery.of(context).size.width * 0.057,
                          color: Colors.black,
                          fontFamily: 'Kanit',
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      SizedBox(height: 10),

                      // Horizontal GridView for featured restaurants
                      SizedBox(
                        height:
                            100, // Set a fixed height for the horizontal grid view
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1, // Wider tiles
                          ),
                          itemCount: titlesCuisineForYou.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                // Handle onTap for horizontal grid items
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  color: Colors.grey[200], // Placeholder color
                                  child: Stack(
                                    children: [
                                      Image.network(
                                        imagePathsCuisinesForYou[
                                            i], // Replace this with the list of network image URLs
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        height: double.infinity,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            colors: [
                                              Colors.black.withOpacity(0.1),
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment
                                            .bottomCenter, // Aligns the text to the bottom center
                                        child: Text(
                                          titlesCuisineForYou[i],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Kanit',
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 20),

                      Row(
                        children: [
                          Text(
                            "Hot Deals & Discounts",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.057,
                              color: Colors.black,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(), // This widget will push the container to the end of the row
                          Container(
                            width: 34, // Adjust the width of the circle
                            height: 34, // Adjust the height of the circle
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .grey[200], // Background color of the circle
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_sharp,
                                  size: 18, color: Colors.black87),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerticalGridScreen(
                                      titles: titlesHotDeals,
                                      imagePaths: imagePathsHotDeals,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // Horizontal GridView for hot deals

                      // Horizontal GridView for featured restaurants
                      SizedBox(
                        height:
                            220, // Set a fixed height for the horizontal grid view
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1, // Wider tiles
                          ),
                          itemCount: titlesHotDeals.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductViewScreen(
                                      title: titlesHotDeals[
                                          i], // Pass the title for the new screen
                                      imagePath: imagePathsHotDeals[
                                          i], // Pass the image path for the new screen
                                      products: products[titlesHotDeals[i]] ??
                                          [], // Pass the products related to the title
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              imagePathsHotDeals[
                                                  i], // Use network image for the grid tile
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductViewScreen(
                                                title: titlesHotDeals[i],
                                                imagePath: imagePathsHotDeals[
                                                    i], // Pass the specific image path
                                                products: products[
                                                        titlesHotDeals[i]] ??
                                                    [], // Pass the related products
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 1,
                                          color: Colors.white,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    titlesHotDeals[i],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        color: Colors.grey[700],
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '30-40 mins',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.delivery_dining,
                                                          color:
                                                              Colors.grey[700],
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.055,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '100/-',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      SizedBox(height: 10),

                      Row(
                        children: [
                          Text(
                            "Desi Desire",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.width * 0.057,
                              color: Colors.black,
                              fontFamily: 'Kanit',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Spacer(), // This widget will push the container to the end of the row
                          Container(
                            width: 34, // Adjust the width of the circle
                            height: 34, // Adjust the height of the circle
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors
                                  .grey[200], // Background color of the circle
                            ),
                            child: IconButton(
                              icon: Icon(Icons.arrow_forward_ios_sharp,
                                  size: 17, color: Colors.black87),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VerticalGridScreen(
                                      titles: titleDesiDesire,
                                      imagePaths: imagepathDesiDesire,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 10),

                      // Horizontal GridView for featured restaurants
                      SizedBox(
                        height:
                            220, // Set a fixed height for the horizontal grid view
                        child: GridView.builder(
                          scrollDirection: Axis.horizontal,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                            childAspectRatio: 1, // Wider tiles
                          ),
                          itemCount: titleDesiDesire.length,
                          itemBuilder: (_, i) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductViewScreen(
                                      title: titleDesiDesire[
                                          i], // Pass the title for the new screen
                                      imagePath: imagepathDesiDesire[
                                          i], // Pass the image path for the new screen
                                      products: products[titleDesiDesire[i]] ??
                                          [], // Pass the products related to the title
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(
                                        child: Stack(
                                          fit: StackFit.expand,
                                          children: [
                                            Image.network(
                                              imagepathDesiDesire[
                                                  i], // Use network image for the grid tile
                                              fit: BoxFit.cover,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment.bottomCenter,
                                                  end: Alignment.topCenter,
                                                  colors: [
                                                    Colors.transparent,
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductViewScreen(
                                                title: titleDesiDesire[i],
                                                imagePath: imagepathDesiDesire[
                                                    i], // Pass the specific image path
                                                products: products[
                                                        titleDesiDesire[i]] ??
                                                    [], // Pass the related products
                                              ),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 1,
                                          color: Colors.white,
                                          child: Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    titleDesiDesire[i],
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontFamily: 'Montserrat',
                                                      fontSize:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.04,
                                                    ),
                                                  ),
                                                  SizedBox(height: 4),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.access_time,
                                                        color: Colors.grey[700],
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.045,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '30-40 mins',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        Icon(
                                                          Icons.delivery_dining,
                                                          color:
                                                              Colors.grey[700],
                                                          size: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.055,
                                                        ),
                                                        SizedBox(width: 4),
                                                        Text(
                                                          '100/-',
                                                          style: TextStyle(
                                                            color: Colors
                                                                .grey[600],
                                                            fontFamily:
                                                                'Montserrat',
                                                            fontSize: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.035,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      Text(
                        "All restaurants",
                        style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.057,
                            color: Colors.black,
                            fontFamily: 'Kanit',
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.02),

                      GridView.builder(
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
// Disable grid-specific scrolling

                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 1, // Wider tiles
                        ),
                        itemCount: titlesMain.length,
                        itemBuilder: (_, i) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductViewScreen(
                                    title: titlesMain[
                                        i], // Pass the title for the new screen
                                    imagePath: imagePathsAllRestaurant[
                                        i], // Pass the image path for the new screen
                                    products: products[titlesMain[i]] ??
                                        [], // Pass the products related to the title
                                  ),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Expanded(
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            imagePathsAllRestaurant[i],
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                begin: Alignment.bottomCenter,
                                                end: Alignment.topCenter,
                                                colors: [
                                                  Colors.transparent,
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductViewScreen(
                                              title: titlesMain[i],
                                              imagePath: imagePathsAllRestaurant[
                                                  i], // Pass the specific image path
                                              products: products[
                                                      titlesMain[i]] ??
                                                  [], // Pass the related products
                                            ),
                                          ),
                                        );
                                      },
                                      child: Card(
                                        elevation: 1,
                                        color: Colors.white,
                                        child: Container(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  titlesMain[i],
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'Montserrat',
                                                    fontSize:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.04,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      color: Colors.grey[700],
                                                      size:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.045,
                                                    ),
                                                    SizedBox(width: 4),
                                                    Text(
                                                      '30-40 mins',
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color: Colors.grey[600],
                                                        fontFamily:
                                                            'Montserrat',
                                                        fontSize: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.035,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 8),
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Icon(
                                                        Icons.delivery_dining,
                                                        color: Colors.grey[700],
                                                        size: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.055,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        '100/-',
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[600],
                                                          fontFamily:
                                                              'Montserrat',
                                                          fontSize: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.035,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ]
                  ]),
            ),
          ),
          drawer: Drawer(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(2),
                bottomRight: Radius.circular(2),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  Container(
                    color: Color(0xFF7F9BB3), // Header color
                    padding: EdgeInsets.all(20), // Custom padding for content
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: 100), // Adjust spacing as needed
                        Text(
                          'Welcome, $userFirstName',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20, // Font size set to 20
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.dashboard,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Dashboard",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.home,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Home",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.person,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "View Profile",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.history,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Order History",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderHistoryScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.maps_home_work_outlined,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Addresses",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParallaxEffect(),
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.help,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Help center",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContactUsScreen(),
                          ),
                        );
                      },
                    ),
                  ),

                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.settings,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Settings",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLoginScreen()),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: .0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.privacy_tip_rounded,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Terms & Conditions / Privacy",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLoginScreen()),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white, // Lighter pink for the tile
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
                      trailing: Icon(
                        Icons.login_outlined,
                        size: 19,
                        color: Color(0xff3b5664),
                      ),
                      title: Text(
                        "Log Out",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontSize: 15),
                      ),
                      onTap: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmailLoginScreen()),
                        );
                      },
                    ),
                  ),
                  // No Divider here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
