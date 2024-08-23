import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop/screens/mainscreen.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  Future<List<Map<String, dynamic>>> _fetchOrderHistory() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Fetch orders from the 'orders' subcollection
      final QuerySnapshot ordersSnapshot = await FirebaseFirestore.instance
          .collection('cartitems')
          .doc(user.email)
          .collection('orders')
          .orderBy('Timestamp', descending: true) // Order by most recent
          .get();

      // Convert the snapshot into a list of maps
      return ordersSnapshot.docs.map((doc) {
        return doc.data() as Map<String, dynamic>;
      }).toList();
    } else {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey[600]),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchOrderHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found.'));
          } else {
            final List<Map<String, dynamic>> orderHistory = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.all(16.0),
              itemCount: orderHistory.length,
              itemBuilder: (context, index) {
                final orderDetails = orderHistory[index];
                final timestamp = orderDetails['Timestamp'];
                final formattedTime = timestamp is Timestamp
                    ? DateFormat('dd-MM-yyyy, hh:mm a').format(timestamp.toDate())
                    : 'N/A';

                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Divider(color: Colors.grey[300], height: 24),
                        Text(
                          'Items:',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 10),
                        ...((orderDetails['Items'] as List<dynamic>?)?.map((item) {
                          if (item is Map<String, dynamic>) {
                            final imageUrl = item['Image URL'] ?? '';
                            final name = item['Item Name'] ?? 'No Name';
                            final price = item['Price'] ?? 'N/A';
                            final quantity = item['Quantity'] ?? 'N/A';

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Price: ${price.toString()}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        'Quantity: ${quantity.toString()}',
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (imageUrl.isNotEmpty)
                                  SizedBox(
                                    width: 80,  // Adjust width as needed
                                    height: 80, // Adjust height as needed
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(2.0),
                                      child: Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          } else {
                            return Text('Invalid item format');
                          }
                        }) ?? [Text('No items available')]),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order Time:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount:',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Rs. ${orderDetails['Total'] ?? 'N/A'}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

