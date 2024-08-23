import 'package:flutter/material.dart';

import '../detail_screen/products_detail_screen.dart';

class ProductViewScreen extends StatefulWidget {
  final String title;
  final String imagePath; // Can be a network URL or asset path
  final List<Map<String, dynamic>> products;

  ProductViewScreen({
    required this.title,
    required this.imagePath,
    required this.products,
  });

  @override
  _ProductViewScreenState createState() => _ProductViewScreenState();
}

class _ProductViewScreenState extends State<ProductViewScreen> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: 300,
                child: Image(
                  image: _getImageProvider(widget.imagePath), // Use the updated method
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 18,
                left: 5,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey[100],
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: widget.products.length,
              itemBuilder: (context, index) {
                final product = widget.products[index];
                return _buildProductCard(product);
              },
            ),
          ),
        ],
      ),
    );
  }

  // Method to build the appropriate image provider based on the path
  ImageProvider<Object> _getImageProvider(String path) {
    if (path.startsWith('http') || path.startsWith('https')) {
      return NetworkImage(path);
    } else {
      return AssetImage(path);
    }
  }

  Widget _buildProductCard(Map<String, dynamic> product) {
    final productName = product['name'] ?? 'No Name';
    final productPrice = product['price'] ?? 0.0; // Ensure the price is a double
    final productDescription = product['description'] ?? 'No Description';
    final productImage = product['image'] ?? '';
    final productId = product['id'] ?? ''; // Ensure you have an ID for the product
    final companyName = product['companyName'] ?? ''; // Ensure you have a company name

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(
              productName: productName,
              productDescription: productDescription,
              id: productId,
              productPrice: productPrice,
              ImageURL: productImage,
              companyName: companyName,
            ),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        elevation: 1.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productName,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Kanit',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rs. $productPrice',
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                        fontFamily: 'Montserrat',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      productDescription,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
              if (productImage.isNotEmpty)
                Container(
                  width: 120,
                  height: 110,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _getImageProvider(productImage), // Use the updated method
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
