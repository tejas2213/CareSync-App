// //FlutterTejas22132926##
// // import 'package:caresync/Tejas/PatientSide.dart/PatientHomeScreen.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:twilio_flutter/twilio_flutter.dart';

// // import '../Model Class/productdetails.dart';

// // class Cart extends StatefulWidget {
// //   final String patientId;
// //   final String storeId;
// //   final VoidCallback onProductChanged;

// //   const Cart({
// //     super.key,
// //     required this.patientId,
// //     required this.storeId,
// //     required this.onProductChanged,
// //   });

// //   @override
// //   State<Cart> createState() => _CartState();
// // }

// // class _CartState extends State<Cart> {
// //   List<ProductData> cartProducts = [];
// //   String selectedPaymentMethod = "Cash on Delivery";
// //   TextEditingController addressController = TextEditingController();
// //   double totalPrice = 0.0;
// //   bool isPlacingOrder = false;

// //   late TwilioFlutter twilioFlutter;

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchCartProducts();
// //     twilioFlutter = TwilioFlutter(
// //       accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
// //       authToken: 'YOUR_TWILIO_AUTH_TOKEN',
// //       twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
// //     );
// //   }

// //   Future<void> fetchCartProducts() async {
// //     try {
// //       final querySnapshot = await FirebaseFirestore.instance
// //           .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
// //           .get();

// //       cartProducts.clear();
// //       totalPrice = 0.0;
// //       for (var productDoc in querySnapshot.docs) {
// //         final product = ProductData(
// //           name: productDoc.data()['name'] ?? 'No Name',
// //           productId: productDoc.id,
// //           price: productDoc.data()['price'] ?? 0,
// //           image: productDoc.data()['image'] ?? '',
// //           mrp: productDoc.data()['mrp'] ?? 0,
// //           quantity: productDoc.data()['quantity'] ?? 1,
// //         );
// //         cartProducts.add(product);
// //         totalPrice += product.price * product.quantity;
// //       }

// //       setState(() {});
// //     } catch (e) {
// //       print("Error fetching cart products: $e");
// //     }
// //   }

// //   Future<void> _placeOrder() async {
// //     if (addressController.text.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Please enter your address.")),
// //       );
// //       return;
// //     }

// //     setState(() {
// //       isPlacingOrder = true;
// //     });

// //     try {
// //       final medicalStoreDoc = await FirebaseFirestore.instance
// //           .collection('Medical Stores')
// //           .doc(widget.storeId)
// //           .get();

// //       if (!medicalStoreDoc.exists) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Medical store details not found.")),
// //         );
// //         setState(() {
// //           isPlacingOrder = false;
// //         });
// //         return;
// //       }

// //       final medicalStorePhone = medicalStoreDoc.data()?['phone'];

// //       if (medicalStorePhone == null || medicalStorePhone.isEmpty) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(
// //               content: Text("Medical store phone number is missing.")),
// //         );
// //         setState(() {
// //           isPlacingOrder = false;
// //         });
// //         return;
// //       }

// //       final patientDoc = await FirebaseFirestore.instance
// //           .collection('CareSync/patients/accounts')
// //           .doc(widget.patientId)
// //           .get();

// //       if (!patientDoc.exists) {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           const SnackBar(content: Text("Patient details not found.")),
// //         );
// //         setState(() {
// //           isPlacingOrder = false;
// //         });
// //         return;
// //       }

// //       final patientName = patientDoc.data()?['name'] ?? 'Unknown';
// //       final patientPhone = patientDoc.data()?['phone'] ?? 'Unknown';

// //       String productDetails = '';
// //       for (var product in cartProducts) {
// //         productDetails +=
// //             '${product.name} (Qty: ${product.quantity}) - ₹${product.price * product.quantity}\n';
// //       }

// //       await FirebaseFirestore.instance
// //           .collection('CareSync/patients/accounts/${widget.patientId}/MyOrders')
// //           .add({
// //         'products': cartProducts
// //             .map((product) => {
// //                   'name': product.name,
// //                   'price': product.price,
// //                   'image': product.image,
// //                   'quantity': product.quantity,
// //                 })
// //             .toList(),
// //         'totalPrice': totalPrice,
// //         'paymentMethod': selectedPaymentMethod,
// //         'address': addressController.text,
// //         'timestamp': FieldValue.serverTimestamp(),
// //       });

// //       await twilioFlutter.sendSMS(
// //         toNumber: medicalStorePhone,
// //         messageBody: '''New order placed!

// // Patient Name: $patientName
// // Phone: $patientPhone
// // Total Price: ₹$totalPrice
// // Address: ${addressController.text}

// // Products:
// // $productDetails
// //         ''',
// //       );

// //       for (var product in cartProducts) {
// //         await FirebaseFirestore.instance
// //             .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
// //             .doc(product.productId)
// //             .delete();
// //       }

// //       setState(() {
// //         cartProducts.clear();
// //         totalPrice = 0.0;
// //         isPlacingOrder = false;
// //       });

// //       showDialog(
// //         context: context,
// //         builder: (context) => AlertDialog(
// //           title: const Text("Success"),
// //           content: const Text("Order placed successfully!"),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //                   Navigator.pushReplacement(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => const PatientHomeScreen()),
// //                   );
// //               },
// //               child: const Text("OK"),
// //             ),
// //           ],
// //         ),
// //       );
// //     } catch (e) {
// //       print("Error placing order: $e");
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         const SnackBar(content: Text("Error placing order. Try again.")),
// //       );
// //       setState(() {
// //         isPlacingOrder = false;
// //       });
// //     }
// //   }

// //   void _showConfirmationDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: const Text("Confirm Order"),
// //         content: const Text("Are you sure you want to proceed with the order?"),
// //         actions: [
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //             },
// //             child: const Text("No"),
// //           ),
// //           TextButton(
// //             onPressed: () {
// //               Navigator.of(context).pop();
// //               _placeOrder();
// //             },
// //             child: const Text("Yes"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Stack(
// //         children: [
// //           Container(
// //               decoration: const BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             stops: [0.0, 0.3, 0.7, 1.0],
// //             colors: [
// //               Color.fromRGBO(97, 206, 255, 1),
// //               Colors.white,
// //               Colors.white,
// //               Color.fromRGBO(14, 190, 126, 1),
// //             ],
// //           ),
// //         ),
// //           ),
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(16.0, 55, 16, 0),
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Row(
// //                   children: [
// //                     GestureDetector(
// //                       onTap: () {
// //                         Navigator.pop(context);
// //                       },
// //                       child: Container(
// //                           height: 43,
// //                           width: 43,
// //                           decoration: BoxDecoration(
// //                             borderRadius: BorderRadius.circular(17),
// //                             color: Colors.white,
// //                           ),
// //                           child: const Icon(
// //                             size: 30,
// //                             Icons.arrow_back_ios_new_rounded,
// //                             color: Colors.grey,
// //                           )),
// //                     ),
// //                     const SizedBox(width: 80),
// //                     Text(
// //                       'My Cart',
// //                       style: GoogleFonts.poppins(
// //                         fontSize: 30,
// //                         fontWeight: FontWeight.w600,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //                 SizedBox(
// //                   height: 500,
// //                   child: cartProducts.isEmpty
// //                       ? const Center(child: Text("Your cart is empty."))
// //                       : ListView.builder(
// //                           itemCount: cartProducts.length,
// //                           itemBuilder: (context, index) {
// //                             final product = cartProducts[index];
// //                             return Card(
// //                               margin: const EdgeInsets.all(8.0),
// //                               child: ListTile(
// //                                 leading: Image.network(
// //                                   product.image,
// //                                   width: 50,
// //                                   height: 50,
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                                 title: Text(
// //                                   product.name,
// //                                   style: GoogleFonts.roboto(
// //                                       fontWeight: FontWeight.bold),
// //                                 ),
// //                                 subtitle: Column(
// //                                   crossAxisAlignment: CrossAxisAlignment.start,
// //                                   children: [
// //                                     Text('Price: ₹${product.price}'),
// //                                     Text(
// //                                         'Total: ₹${product.price * product.quantity}'),
// //                                     Row(
// //                                       children: [
// //                                         IconButton(
// //                                           icon: const Icon(Icons.remove),
// //                                           onPressed: () {
// //                                             if (product.quantity > 1) {
// //                                               setState(() {
// //                                                 product.quantity--;
// //                                                 totalPrice -= product.price;
// //                                               });
// //                                               FirebaseFirestore.instance
// //                                                   .collection(
// //                                                       'CareSync/patients/accounts/${widget.patientId}/Cart')
// //                                                   .doc(product.productId)
// //                                                   .update({
// //                                                 'quantity': product.quantity,
// //                                               });
// //                                             }
// //                                           },
// //                                         ),
// //                                         Text('Qty: ${product.quantity}'),
// //                                         IconButton(
// //                                           icon: const Icon(Icons.add),
// //                                           onPressed: () {
// //                                             setState(() {
// //                                               product.quantity++;
// //                                               totalPrice += product.price;
// //                                             });
// //                                             FirebaseFirestore.instance
// //                                                 .collection(
// //                                                     'CareSync/patients/accounts/${widget.patientId}/Cart')
// //                                                 .doc(product.productId)
// //                                                 .update({
// //                                               'quantity': product.quantity,
// //                                             });
// //                                           },
// //                                         ),
// //                                       ],
// //                                     ),
// //                                   ],
// //                                 ),
// //                                 trailing: IconButton(
// //                                   icon: const Icon(Icons.delete),
// //                                   onPressed: () async {
// //                                     await FirebaseFirestore.instance
// //                                         .collection(
// //                                             'CareSync/patients/accounts/${widget.patientId}/Cart')
// //                                         .doc(product.productId)
// //                                         .delete();
// //                                     setState(() {
// //                                       cartProducts.removeAt(index);
// //                                       totalPrice -=
// //                                           product.price * product.quantity;
// //                                     });
// //                                   },
// //                                 ),
// //                               ),
// //                             );
// //                           },
// //                         ),
// //                 ),
// //                 Padding(
// //                   padding: const EdgeInsets.symmetric(vertical: 16.0),
// //                   child: Column(
// //                     children: [
// //                       TextField(
// //                         controller: addressController,
// //                         decoration: const InputDecoration(
// //                           labelText: 'Enter Delivery Address',
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),

// //                       const Row(
// //                         children: [
// //                           Icon(Icons.payment,
// //                               color: Color.fromRGBO(14, 190, 127, 1)),
// //                           SizedBox(width: 8),
// //                           Text(
// //                             "Payment Method: Cash on Delivery",
// //                             style: TextStyle(
// //                                 fontSize: 16, fontWeight: FontWeight.bold),
// //                           ),
// //                         ],
// //                       ),
// //                       //const SizedBox(height: 15),
// //                       const SizedBox(height: 20),
// //                       Text(
// //                         'Total Price: ₹$totalPrice',
// //                         style: GoogleFonts.poppins(
// //                           fontSize: 20,
// //                           fontWeight: FontWeight.bold,
// //                           color: const Color.fromRGBO(14, 190, 127, 1),
// //                         ),
// //                       ),
// //                       const SizedBox(height: 20),
// //                       isPlacingOrder
// //                           ? const CircularProgressIndicator()
// //                           : ElevatedButton(
// //                               onPressed: _showConfirmationDialog,
// //                               style: ElevatedButton.styleFrom(
// //                                 backgroundColor:
// //                                     const Color.fromRGBO(14, 190, 127, 1),
// //                                 minimumSize: const Size(180, 50),
// //                                 shape: RoundedRectangleBorder(
// //                                   borderRadius: BorderRadius.circular(10),
// //                                 ),
// //                               ),
// //                               child: const Text(
// //                                 'Place Order',
// //                                 style: TextStyle(
// //                                   color: Colors.white,
// //                                 ),
// //                               ),
// //                             ),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:twilio_flutter/twilio_flutter.dart';

// import '../Model Class/productdetails.dart';

// class Cart extends StatefulWidget {
//   final String patientId;
//   final String storeId;
//   final VoidCallback onProductChanged;

//   const Cart({
//     super.key,
//     required this.patientId,
//     required this.storeId,
//     required this.onProductChanged,
//   });

//   @override
//   State<Cart> createState() => _CartState();
// }

// class _CartState extends State<Cart> {
//   List<ProductData> cartProducts = [];
//   String selectedPaymentMethod = "Cash on Delivery";
//   TextEditingController addressController = TextEditingController();
//   double totalPrice = 0.0;
//   bool isPlacingOrder = false;

//   late TwilioFlutter twilioFlutter;

//   @override
//   void initState() {
//     super.initState();
//     fetchCartProducts();
//     twilioFlutter = TwilioFlutter(
//       accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
//       authToken: 'YOUR_TWILIO_AUTH_TOKEN',
//       twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
//     );
//   }

//   Future<void> fetchCartProducts() async {
//     try {
//       final querySnapshot = await FirebaseFirestore.instance
//           .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
//           .get();

//       cartProducts.clear();
//       totalPrice = 0.0;
//       for (var productDoc in querySnapshot.docs) {
//         final product = ProductData(
//           name: productDoc.data()['name'] ?? 'No Name',
//           productId: productDoc.id,
//           price: productDoc.data()['price'] ?? 0,
//           image: productDoc.data()['image'] ?? '',
//           mrp: productDoc.data()['mrp'] ?? 0,
//           quantity: productDoc.data()['quantity'] ?? 1,
//         );
//         cartProducts.add(product);
//         totalPrice += product.price * product.quantity;
//       }

//       setState(() {});
//     } catch (e) {
//       print("Error fetching cart products: $e");
//     }
//   }

//   Future<void> _placeOrder() async {
//     if (cartProducts.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Your cart is empty. Add items to proceed.")),
//       );
//       return;
//     }

//     if (addressController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please enter your address.")),
//       );
//       return;
//     }

//     setState(() {
//       isPlacingOrder = true;
//     });

//     try {
//       final orderData = {
//         'products': cartProducts.map((product) {
//           return {
//             'name': product.name,
//             'price': product.price,
//             'quantity': product.quantity,
//           };
//         }).toList(),
//         'totalPrice': totalPrice,
//         'address': addressController.text,
//         'paymentMethod': selectedPaymentMethod,
//         'orderDate': Timestamp.now(),
//       };

//       await FirebaseFirestore.instance
//           .collection('CareSync/patients/accounts/${widget.patientId}/Orders')
//           .add(orderData);

//       // Clear the cart after placing the order
//       for (var product in cartProducts) {
//         await FirebaseFirestore.instance
//             .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
//             .doc(product.productId)
//             .delete();
//       }

//       cartProducts.clear();
//       totalPrice = 0.0;

//       // Notify success
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Order placed successfully!")),
//       );

//       // Navigate back or update UI
//       Navigator.pop(context);
//       widget.onProductChanged();
//     } catch (e) {
//       print("Error placing order: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Failed to place order. Please try again.")),
//       );
//     } finally {
//       setState(() {
//         isPlacingOrder = false;
//       });
//     }
//   }

//   void _showConfirmationDialog() {
//     if (cartProducts.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Your cart is empty. Add items to proceed.")),
//       );
//       return;
//     }

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Confirm Order"),
//         content: const Text("Are you sure you want to proceed with the order?"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             child: const Text("No"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _placeOrder();
//             },
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Container(
//             decoration: const BoxDecoration(
//               gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//                 stops: [0.0, 0.3, 0.7, 1.0],
//                 colors: [
//                   Color.fromRGBO(97, 206, 255, 1),
//                   Colors.white,
//                   Colors.white,
//                   Color.fromRGBO(14, 190, 126, 1),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(16.0, 55, 16, 0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: 43,
//                         width: 43,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(17),
//                           color: Colors.white,
//                         ),
//                         child: const Icon(
//                           size: 30,
//                           Icons.arrow_back_ios_new_rounded,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 80),
//                     Text(
//                       'My Cart',
//                       style: GoogleFonts.poppins(
//                         fontSize: 30,
//                         fontWeight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: cartProducts.isEmpty
//                       ? Center(
//                           child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(
//                                 'assets/empty_cart.png',
//                                 height: 200,
//                               ),
//                               const SizedBox(height: 20),
//                               const Text(
//                                 "Your cart is empty!",
//                                 style: TextStyle(
//                                   fontSize: 20,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               const Text(
//                                 "Add some items to your cart to get started.",
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ],
//                           ),
//                         )
//                       : ListView.builder(
//                           itemCount: cartProducts.length,
//                           itemBuilder: (context, index) {
//                             final product = cartProducts[index];
//                             return Card(
//                               margin: const EdgeInsets.all(8.0),
//                               child: ListTile(
//                                 leading: Image.network(
//                                   product.image,
//                                   width: 50,
//                                   height: 50,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 title: Text(
//                                   product.name,
//                                   style: GoogleFonts.roboto(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 subtitle: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text('Price: ₹${product.price}'),
//                                     Text(
//                                         'Total: ₹${product.price * product.quantity}'),
//                                     Row(
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(Icons.remove),
//                                           onPressed: () {
//                                             if (product.quantity > 1) {
//                                               setState(() {
//                                                 product.quantity--;
//                                                 totalPrice -= product.price;
//                                               });
//                                               FirebaseFirestore.instance
//                                                   .collection(
//                                                       'CareSync/patients/accounts/${widget.patientId}/Cart')
//                                                   .doc(product.productId)
//                                                   .update({
//                                                 'quantity': product.quantity,
//                                               });
//                                             }
//                                           },
//                                         ),
//                                         Text('Qty: ${product.quantity}'),
//                                         IconButton(
//                                           icon: const Icon(Icons.add),
//                                           onPressed: () {
//                                             setState(() {
//                                               product.quantity++;
//                                               totalPrice += product.price;
//                                             });
//                                             FirebaseFirestore.instance
//                                                 .collection(
//                                                     'CareSync/patients/accounts/${widget.patientId}/Cart')
//                                                 .doc(product.productId)
//                                                 .update({
//                                               'quantity': product.quantity,
//                                             });
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 trailing: IconButton(
//                                   icon: const Icon(Icons.delete),
//                                   onPressed: () async {
//                                     await FirebaseFirestore.instance
//                                         .collection(
//                                             'CareSync/patients/accounts/${widget.patientId}/Cart')
//                                         .doc(product.productId)
//                                         .delete();
//                                     setState(() {
//                                       cartProducts.removeAt(index);
//                                       totalPrice -=
//                                           product.price * product.quantity;
//                                     });
//                                   },
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                 ),
//                 if (cartProducts.isNotEmpty)
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16.0,5,16,16),
//                     child: Column(
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               "Total Price:",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                             Text(
//                               "₹${totalPrice.toStringAsFixed(2)}",
//                               style: GoogleFonts.poppins(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 10),
//                         TextField(
//                         controller: addressController,
//                         decoration: const InputDecoration(
//                           labelText: 'Enter Delivery Address',
//                         ),
//                       ),
//                       const SizedBox(height: 20),

//                       const Row(
//                         children: [
//                           Icon(Icons.payment,
//                               color: Color.fromRGBO(14, 190, 127, 1)),
//                           SizedBox(width: 8),
//                           Text(
//                             "Payment Method: Cash on Delivery",
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                           ),
//                         ],
//                       ),

//                         const SizedBox(height: 20),
//                         ElevatedButton(
//                           onPressed: _showConfirmationDialog,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor:
//                                 const Color.fromRGBO(14, 190, 127, 1),
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 50, vertical: 15),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(30),
//                             ),
//                           ),
//                           child: isPlacingOrder
//                               ? const CircularProgressIndicator(
//                                   color: Colors.white,
//                                 )
//                               :  const Text(
//                                 'Place Order',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 20
//                                 ),
//                               ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:caresync/features/patients/presentation/pages/patient_home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lottie/lottie.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

import 'package:caresync/features/pharmacy/data/models/product_details_model.dart';

class Cart extends StatefulWidget {
  final String patientId;
  final String storeId;
  final VoidCallback onProductChanged;

  const Cart({
    super.key,
    required this.patientId,
    required this.storeId,
    required this.onProductChanged,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List<ProductData> cartProducts = [];
  String selectedPaymentMethod = "Cash on Delivery";
  TextEditingController addressController = TextEditingController();
  double totalPrice = 0.0;
  bool isPlacingOrder = false;

  late TwilioFlutter twilioFlutter;

  @override
  void initState() {
    super.initState();
    fetchCartProducts();
    twilioFlutter = TwilioFlutter(
      accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
      authToken: 'YOUR_TWILIO_AUTH_TOKEN',
      twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
    );
  }

  Future<void> fetchCartProducts() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
          .get();

      cartProducts.clear();
      totalPrice = 0.0;
      for (var productDoc in querySnapshot.docs) {
        final product = ProductData(
          name: productDoc.data()['name'] ?? 'No Name',
          productId: productDoc.id,
          price: productDoc.data()['price'] ?? 0,
          image: productDoc.data()['image'] ?? '',
          mrp: productDoc.data()['mrp'] ?? 0,
          quantity: productDoc.data()['quantity'] ?? 1,
        );
        cartProducts.add(product);
        totalPrice += product.price * product.quantity;
      }

      setState(() {});
    } catch (e) {
      print("Error fetching cart products: $e");
    }
  }

  Future<void> _placeOrder() async {
    if (addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter your address.")),
      );
      return;
    }

    setState(() {
      isPlacingOrder = true;
    });

    try {
      final medicalStoreDoc = await FirebaseFirestore.instance
          .collection('Medical Stores')
          .doc(widget.storeId)
          .get();

      if (!medicalStoreDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Medical store details not found.")),
        );
        setState(() {
          isPlacingOrder = false;
        });
        return;
      }

      final medicalStorePhone = medicalStoreDoc.data()?['phone'];

      if (medicalStorePhone == null || medicalStorePhone.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Medical store phone number is missing.")),
        );
        setState(() {
          isPlacingOrder = false;
        });
        return;
      }

      final patientDoc = await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts')
          .doc(widget.patientId)
          .get();

      if (!patientDoc.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Patient details not found.")),
        );
        setState(() {
          isPlacingOrder = false;
        });
        return;
      }

      final patientName = patientDoc.data()?['name'] ?? 'Unknown';
      final patientPhone = patientDoc.data()?['phone'] ?? 'Unknown';

      String productDetails = '';
      for (var product in cartProducts) {
        productDetails +=
            '${product.name} (Qty: ${product.quantity}) - ₹${product.price * product.quantity}\n';
      }

      await FirebaseFirestore.instance
          .collection('CareSync/patients/accounts/${widget.patientId}/MyOrders')
          .add({
        'products': cartProducts
            .map((product) => {
                  'name': product.name,
                  'price': product.price,
                  'image': product.image,
                  'quantity': product.quantity,
                })
            .toList(),
        'totalPrice': totalPrice,
        'paymentMethod': selectedPaymentMethod,
        'address': addressController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      await twilioFlutter.sendSMS(
        toNumber: medicalStorePhone,
        messageBody: '''New order placed!
        
      Patient Name: $patientName
      Phone: $patientPhone
      Total Price: ₹$totalPrice
      Address: ${addressController.text}

      Products:
        $productDetails
        ''',
      );

      for (var product in cartProducts) {
        await FirebaseFirestore.instance
            .collection('CareSync/patients/accounts/${widget.patientId}/Cart')
            .doc(product.productId)
            .delete();
      }

      setState(() {
        cartProducts.clear();
        totalPrice = 0.0;
        isPlacingOrder = false;
      });

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          actions: <Widget>[
            Center(
                child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 6),
              child: Column(
                children: [
                  Lottie.asset("assets/json/delivery.json"),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Thank You !",
                      style: GoogleFonts.poppins(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Order placed successfully!",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PatientHomeScreen()),
                      );
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
            )),
          ],
        ),
      );
    } catch (e) {
      print("Error placing order: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error placing order. Try again.")),
      );
      setState(() {
        isPlacingOrder = false;
      });
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Order"),
        content: const Text("Are you sure you want to proceed with the order?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _placeOrder();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.fromLTRB(16.0, 55, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        height: 43,
                        width: 43,
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
                    const SizedBox(width: 80),
                    Text(
                      'My Cart',
                      style: GoogleFonts.poppins(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: cartProducts.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Lottie.asset("assets/json/cart.json"),
                              const SizedBox(height: 20),
                              const Text(
                                "Your cart is empty!",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "Add some items to your cart to get started.",
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 18),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: cartProducts.length,
                          itemBuilder: (context, index) {
                            final product = cartProducts[index];
                            return Card(
                              margin: const EdgeInsets.all(8.0),
                              child: ListTile(
                                leading: Image.network(
                                  product.image,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),
                                title: Text(
                                  product.name,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Price: ₹${product.price}'),
                                    Text(
                                        'Total: ₹${product.price * product.quantity}'),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.remove),
                                          onPressed: () {
                                            if (product.quantity > 1) {
                                              setState(() {
                                                product.quantity--;
                                                totalPrice -= product.price;
                                              });
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'CareSync/patients/accounts/${widget.patientId}/Cart')
                                                  .doc(product.productId)
                                                  .update({
                                                'quantity': product.quantity,
                                              });
                                            }
                                          },
                                        ),
                                        Text('Qty: ${product.quantity}'),
                                        IconButton(
                                          icon: const Icon(Icons.add),
                                          onPressed: () {
                                            setState(() {
                                              product.quantity++;
                                              totalPrice += product.price;
                                            });
                                            FirebaseFirestore.instance
                                                .collection(
                                                    'CareSync/patients/accounts/${widget.patientId}/Cart')
                                                .doc(product.productId)
                                                .update({
                                              'quantity': product.quantity,
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    await FirebaseFirestore.instance
                                        .collection(
                                            'CareSync/patients/accounts/${widget.patientId}/Cart')
                                        .doc(product.productId)
                                        .delete();
                                    setState(() {
                                      cartProducts.removeAt(index);
                                      totalPrice -=
                                          product.price * product.quantity;
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (cartProducts.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 5, 16, 16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Price:",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "₹${totalPrice.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Enter Delivery Address',
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Row(
                          children: [
                            Icon(Icons.payment,
                                color: Color.fromRGBO(14, 190, 127, 1)),
                            SizedBox(width: 8),
                            Text(
                              "Payment Method: Only Cash on Delivery",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _showConfirmationDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(14, 190, 127, 1),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: isPlacingOrder
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Place Order',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
