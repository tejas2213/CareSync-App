import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/medical_store_model.dart';
import '../../data/models/product_details_model.dart';

abstract class PharmacyRepository {
  Future<List<ProductData>> getCartProducts(String patientId);
  Future<void> updateCartQuantity(
      String patientId, String productId, int quantity);
  Future<void> addToCart(String patientId, ProductData product);
  Future<void> removeFromCart(String patientId, String productId);
  Future<List<ProductData>> getWishlistProducts(String patientId);
  Future<void> addToWishlist(String patientId, ProductData product);
  Future<void> removeFromWishlist(String patientId, String productId);
  Stream<List<MedicalStoresModel>> getMedicalStoresStream();
  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream(
      String storeId);
  Future<List<ProductData>> getProducts(String storeId, String categoryName);
  Future<List<Map<String, dynamic>>> getOrders(String patientId);
  Future<void> placeOrder({
    required String patientId,
    required String storeId,
    required List<ProductData> cartProducts,
    required double totalPrice,
    required String paymentMethod,
    required String address,
  });
}
