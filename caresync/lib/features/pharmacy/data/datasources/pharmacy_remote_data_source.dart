import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twilio_flutter/twilio_flutter.dart';
import '../models/medical_store_model.dart';
import '../models/product_details_model.dart';

class PharmacyRemoteDataSource {
  final FirebaseFirestore _firestore;

  PharmacyRemoteDataSource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<ProductData>> getCartProducts(String patientId) async {
    final querySnapshot = await _firestore
        .collection('CareSync/patients/accounts/$patientId/Cart')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ProductData(
        name: data['name'] ?? 'No Name',
        productId: doc.id,
        price: data['price'] ?? 0,
        image: data['image'] ?? '',
        mrp: data['mrp'] ?? 0,
        quantity: data['quantity'] ?? 1,
      );
    }).toList();
  }

  Future<void> updateCartQuantity(
      String patientId, String productId, int quantity) async {
    final cartDoc = _firestore
        .collection('CareSync/patients/accounts/$patientId/Cart')
        .doc(productId);

    if (quantity > 0) {
      await cartDoc.update({'quantity': quantity});
    } else {
      await cartDoc.delete();
    }
  }

  Future<void> addToCart(String patientId, ProductData product) async {
    await _firestore
        .collection('CareSync/patients/accounts/$patientId/Cart')
        .doc(product.productId)
        .set({
      'name': product.name,
      'price': product.price,
      'mrp': product.mrp,
      'image': product.image,
      'quantity': product.quantity,
    });
  }

  Future<void> removeFromCart(String patientId, String productId) async {
    await _firestore
        .collection('CareSync/patients/accounts/$patientId/Cart')
        .doc(productId)
        .delete();
  }

  Future<List<ProductData>> getWishlistProducts(String patientId) async {
    final querySnapshot = await _firestore
        .collection('CareSync/patients/accounts/$patientId/Wishlist')
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return ProductData(
        name: data['name'] ?? 'No Name',
        productId: doc.id,
        price: data['price'] ?? 0,
        image: data['image'] ?? '',
        mrp: data['mrp'] ?? 0,
      );
    }).toList();
  }

  Future<void> addToWishlist(String patientId, ProductData product) async {
    await _firestore
        .collection('CareSync/patients/accounts/$patientId/Wishlist')
        .doc(product.productId)
        .set({
      'name': product.name,
      'price': product.price,
      'mrp': product.mrp,
      'image': product.image,
    });
  }

  Future<void> removeFromWishlist(String patientId, String productId) async {
    await _firestore
        .collection('CareSync/patients/accounts/$patientId/Wishlist')
        .doc(productId)
        .delete();
  }

  Stream<List<MedicalStoresModel>> getMedicalStoresStream() {
    return _firestore
        .collection('Medical Stores')
        .snapshots()
        .asyncMap((querySnapshot) async {
      List<MedicalStoresModel> medicals = [];
      for (var doc in querySnapshot.docs) {
        try {
          final categoriesSnapshot =
              await doc.reference.collection('categories').get();
          List<String> categoryImages = categoriesSnapshot.docs.map((catDoc) {
            return (catDoc.data()['image_url'] ?? '') as String;
          }).toList();

          medicals.add(MedicalStoresModel(
            id: doc.id,
            title: doc.data()['name'] ?? 'No Name',
            address: doc.data()['address'] ?? 'No Address',
            phoneNo: doc.data()['phone'] ?? 'No Phone',
            image: doc.data()['image_url'] ?? '',
            categoryImages: categoryImages,
            categories: const [],
          ));
        } catch (_) {}
      }
      return medicals;
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream(
      String storeId) {
    return _firestore
        .collection('Medical Stores/$storeId/categories')
        .snapshots();
  }

  Future<List<ProductData>> getProducts(
      String storeId, String categoryName) async {
    final productsSnapshot = await _firestore
        .collection('Medical Stores/$storeId/categories/$categoryName/products')
        .get();

    List<ProductData> products = [];
    for (var productDoc in productsSnapshot.docs) {
      final data = productDoc.data();
      if (data.isEmpty) continue;
      products.add(
        ProductData(
          name: data['name'] ?? 'Unknown Product',
          productId: productDoc.id,
          price: (data['price'] as num?)?.toDouble() ?? 0.0,
          image: data['imageUrl'] ?? '',
          mrp: (data['mrp'] as num?)?.toDouble() ?? 0.0,
        ),
      );
    }
    return products;
  }

  Future<List<Map<String, dynamic>>> getOrders(String patientId) async {
    final querySnapshot = await _firestore
        .collection('CareSync/patients/accounts/$patientId/MyOrders')
        .orderBy('timestamp', descending: true)
        .get();

    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> placeOrder({
    required String patientId,
    required String storeId,
    required List<ProductData> cartProducts,
    required double totalPrice,
    required String paymentMethod,
    required String address,
  }) async {
    final medicalStoreDoc =
        await _firestore.collection('Medical Stores').doc(storeId).get();
    if (!medicalStoreDoc.exists) {
      throw Exception("Medical store details not found.");
    }
    final medicalStorePhone = medicalStoreDoc.data()?['phone'];

    final patientDoc = await _firestore
        .collection('CareSync/patients/accounts')
        .doc(patientId)
        .get();
    if (!patientDoc.exists) {
      throw Exception("Patient details not found.");
    }

    final patientName = patientDoc.data()?['name'] ?? 'Unknown';
    final patientPhone = patientDoc.data()?['phone'] ?? 'Unknown';

    String productDetails = '';
    for (var product in cartProducts) {
      productDetails +=
          '${product.name} (Qty: ${product.quantity}) - ₹${product.price * product.quantity}\n';
    }

    await _firestore
        .collection('CareSync/patients/accounts/$patientId/MyOrders')
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
      'paymentMethod': paymentMethod,
      'address': address,
      'timestamp': FieldValue.serverTimestamp(),
    });

    if (medicalStorePhone != null && medicalStorePhone.toString().isNotEmpty) {
      try {
        final twilioFlutter = TwilioFlutter(
          accountSid: 'YOUR_TWILIO_ACCOUNT_SID',
          authToken: 'YOUR_TWILIO_AUTH_TOKEN',
          twilioNumber: 'YOUR_TWILIO_PHONE_NUMBER',
        );
        await twilioFlutter.sendSMS(
          toNumber: medicalStorePhone.toString(),
          messageBody: '''New order placed!

Patient Name: $patientName
Phone: $patientPhone
Total Price: ₹$totalPrice
Address: $address

Products:
$productDetails
''',
        );
      } catch (_) {}
    }

    for (var product in cartProducts) {
      await _firestore
          .collection('CareSync/patients/accounts/$patientId/Cart')
          .doc(product.productId)
          .delete();
    }
  }
}
