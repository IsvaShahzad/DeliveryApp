import 'package:flutter/material.dart';
import '../screens/product_view_screen.dart';

class VerticalGridScreen extends StatelessWidget {
  final List<String> titles;
  final List<String> imagePaths;

  const VerticalGridScreen({
    Key? key,
    required this.titles,
    required this.imagePaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Restaurants",
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Kanit',
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30.0, right: 30.0, top: 8.0, bottom: 0.0), // Reduced top padding
        child: ListView.builder(
          itemCount: titles.length,
          itemBuilder: (_, i) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductViewScreen(
                      title: titles[i],
                      imagePath: imagePaths[i],
                      products: [], // Pass the related products (replace with actual data)
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Border radius for the card
                ),
                elevation: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12), // Rounded corners only on the top
                        bottom: Radius.zero, // No rounding on the bottom corners
                      ),
                      child: Container(
                        height: 200, // Set the height to ensure a square
                        width: double.infinity, // Ensure the width matches the container's width
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(imagePaths[i]),
                            fit: BoxFit.cover, // Make the image cover the entire area
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8), // Space between the image and the text content
                    Padding(
                      padding: const EdgeInsets.all(8.0), // Padding around the text content
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            titles[i],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: MediaQuery.of(context).size.width * 0.045,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
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
                                  fontFamily: 'Montserrat',
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.delivery_dining,
                                color: Colors.grey[700],
                                size: MediaQuery.of(context).size.width * 0.055,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '100/-',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontFamily: 'Montserrat',
                                  fontSize: MediaQuery.of(context).size.width * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
