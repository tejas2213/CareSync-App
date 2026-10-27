import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/pharmacy_repository.dart';
import '../datasources/pharmacy_remote_data_source.dart';
import '../models/medical_store_model.dart';
import '../models/product_details_model.dart';

class PharmacyRepositoryImpl implements PharmacyRepository {
  final PharmacyRemoteDataSource _remoteDataSource;

  PharmacyRepositoryImpl({PharmacyRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? PharmacyRemoteDataSource();

  @override
  Future<List<ProductData>> getCartProducts(String patientId) =>
      _remoteDataSource.getCartProducts(patientId);

  @override
  Future<void> updateCartQuantity(
          String patientId, String productId, int quantity) =>
      _remoteDataSource.updateCartQuantity(patientId, productId, quantity);

  @override
  Future<void> addToCart(String patientId, ProductData product) =>
      _remoteDataSource.addToCart(patientId, product);

  @override
  Future<void> removeFromCart(String patientId, String productId) =>
      _remoteDataSource.removeFromCart(patientId, productId);

  @override
  Future<List<ProductData>> getWishlistProducts(String patientId) =>
      _remoteDataSource.getWishlistProducts(patientId);

  @override
  Future<void> addToWishlist(String patientId, ProductData product) =>
      _remoteDataSource.addToWishlist(patientId, product);

  @override
  Future<void> removeFromWishlist(String patientId, String productId) =>
      _remoteDataSource.removeFromWishlist(patientId, productId);

  @override
  Stream<List<MedicalStoresModel>> getMedicalStoresStream() =>
      _remoteDataSource.getMedicalStoresStream();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getCategoriesStream(
          String storeId) =>
      _remoteDataSource.getCategoriesStream(storeId);

  @override
  Future<List<ProductData>> getProducts(String storeId, String categoryName) =>
      _remoteDataSource.getProducts(storeId, categoryName);

  @override
  Future<List<Map<String, dynamic>>> getOrders(String patientId) =>
      _remoteDataSource.getOrders(patientId);

  @override
  Future<void> placeOrder({
    required String patientId,
    required String storeId,
    required List<ProductData> cartProducts,
    required double totalPrice,
    required String paymentMethod,
    required String address,
  }) =>
      _remoteDataSource.placeOrder(
        patientId: patientId,
        storeId: storeId,
        cartProducts: cartProducts,
        totalPrice: totalPrice,
        paymentMethod: paymentMethod,
        address: address,
      );
}
