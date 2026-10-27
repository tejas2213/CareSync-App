import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:caresync/features/pharmacy/presentation/pages/medical_store_page.dart';
import 'package:lottie/lottie.dart';

class OrdersPage extends StatelessWidget {
  final String patientId;

  const OrdersPage({super.key, required this.patientId});

  Future<List<Map<String, dynamic>>> fetchOrders() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/$patientId/MyOrders')
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      print("Error fetching orders: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
              decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
            colors: [
              Color.fromRGBO(97, 206, 255, 1),
              Colors.white,
              Colors.white,
              Color.fromRGBO(14, 190, 126, 1),
            ],
          ),
        ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.0, screenHeight * 0.06, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: screenWidth * 0.1,
                    width: screenWidth * 0.1,
                    decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(17),
                          color: Colors.transparent,
                          border: Border.all(
                              color: const Color.fromRGBO(0, 0, 0, 1),
                              width: 1)),
                      child: const Icon(
                        size: 30,
                        Icons.arrow_back_ios_new_rounded,
                        color: Colors.black,
                      ),
                  ),
                ),
                Text(
                  'My Orders',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 20),
              ],
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: fetchOrders(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset("assets/json/noOrder.json",height:150,),
                        const SizedBox(height: 10),
                        const Text(
                          'No orders placed yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Place your first order now.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MedicalStore()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(14, 190, 127, 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Order medicines',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final orders = snapshot.data!;
              return Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 100, 16, 0),
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final productList = order['products'] as List<dynamic>;
                    final totalPrice = order['totalPrice'] ?? 0;
                    final address = order['address'] ?? '';
                    final paymentMethod = order['paymentMethod'] ?? '';

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black87.withOpacity(0.5),
                              offset: const Offset(0, 4),
                              blurRadius: 6.0,
                              spreadRadius: 0.1,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Order Details:",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ...productList.map((product) {
                                final productImage = product['image'] ?? '';
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Row(
                                    children: [
                                      productImage.isNotEmpty
                                          ? Image.network(
                                              productImage,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset(
                                              productImage,
                                              width: 40,
                                              height: 40,
                                              fit: BoxFit.cover,
                                            ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                          child: Text(
                                              "- ${product['name']} (₹${product['price']})")),
                                    ],
                                  ),
                                );
                              }),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Column(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Total Price: ₹$totalPrice"),
                                      Text("Payment Method: $paymentMethod"),
                                      Text("Address: $address"),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
