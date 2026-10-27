import 'dart:io';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl({AdminRemoteDataSource? remoteDataSource})
      : _remoteDataSource = remoteDataSource ?? AdminRemoteDataSourceImpl();

  @override
  Future<Map<String, dynamic>?> getAdminDetails() {
    return _remoteDataSource.getAdminDetails();
  }

  @override
  Future<void> addAmbulance(Map<String, dynamic> data) {
    return _remoteDataSource.addAmbulance(data);
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAmbulances() {
    return _remoteDataSource.streamAmbulances();
  }

  @override
  Future<List<Map<String, dynamic>>> getAmbulances() {
    return _remoteDataSource.getAmbulances();
  }

  @override
  Future<void> updateAmbulance(String id, Map<String, dynamic> data) {
    return _remoteDataSource.updateAmbulance(id, data);
  }

  @override
  Future<void> deleteAmbulance(String id) {
    return _remoteDataSource.deleteAmbulance(id);
  }

  @override
  Future<String> addMedicalStore({
    required String name,
    required String address,
    required String phone,
    File? image,
  }) {
    return _remoteDataSource.addMedicalStore(
      name: name,
      address: address,
      phone: phone,
      image: image,
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> streamMedicalStores() {
    return _remoteDataSource.streamMedicalStores();
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicalStores() {
    return _remoteDataSource.getMedicalStores();
  }

  @override
  Future<void> deleteMedicalStore(String storeId) {
    return _remoteDataSource.deleteMedicalStore(storeId);
  }

  @override
  Future<Map<String, dynamic>?> getMedicalStore(String storeId) {
    return _remoteDataSource.getMedicalStore(storeId);
  }

  @override
  Future<void> updateMedicalStore({
    required String storeId,
    required String name,
    required String address,
    required String phone,
  }) {
    return _remoteDataSource.updateMedicalStore(
      storeId: storeId,
      name: name,
      address: address,
      phone: phone,
    );
  }

  @override
  Future<void> saveStoreCategories({
    required String storeId,
    required Map<String, String?> categories,
  }) {
    return _remoteDataSource.saveStoreCategories(
      storeId: storeId,
      categories: categories,
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> streamStoreCategories(String storeId) {
    return _remoteDataSource.streamStoreCategories(storeId);
  }

  @override
  Future<void> deleteStoreCategory({
    required String storeId,
    required String categoryName,
  }) {
    return _remoteDataSource.deleteStoreCategory(
      storeId: storeId,
      categoryName: categoryName,
    );
  }

  @override
  Future<void> updateCategoryName({
    required String storeId,
    required String categoryId,
    required String newName,
  }) {
    return _remoteDataSource.updateCategoryName(
      storeId: storeId,
      categoryId: categoryId,
      newName: newName,
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> streamCategoryProducts({
    required String storeId,
    required String categoryId,
  }) {
    return _remoteDataSource.streamCategoryProducts(
      storeId: storeId,
      categoryId: categoryId,
    );
  }

  @override
  Future<void> updateProductName({
    required String storeId,
    required String categoryId,
    required String productId,
    required String newName,
  }) {
    return _remoteDataSource.updateProductName(
      storeId: storeId,
      categoryId: categoryId,
      productId: productId,
      newName: newName,
    );
  }

  @override
  Future<void> deleteProduct({
    required String storeId,
    required String categoryId,
    required String productId,
  }) {
    return _remoteDataSource.deleteProduct(
      storeId: storeId,
      categoryId: categoryId,
      productId: productId,
    );
  }

  @override
  Future<void> saveStoreProducts({
    required String storeId,
    required String categoryName,
    required List<Map<String, dynamic>> products,
  }) {
    return _remoteDataSource.saveStoreProducts(
      storeId: storeId,
      categoryName: categoryName,
      products: products,
    );
  }

  @override
  Future<void> addAyurvedaItem({
    required String name,
    required String description,
    required File image,
  }) {
    return _remoteDataSource.addAyurvedaItem(
      name: name,
      description: description,
      image: image,
    );
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAyurvedaItems() {
    return _remoteDataSource.streamAyurvedaItems();
  }

  @override
  Future<List<Map<String, dynamic>>> getAyurvedaItems() {
    return _remoteDataSource.getAyurvedaItems();
  }

  @override
  Future<void> updateAyurvedaItem({
    required String documentId,
    required String name,
    required String description,
    File? image,
  }) {
    return _remoteDataSource.updateAyurvedaItem(
      documentId: documentId,
      name: name,
      description: description,
      image: image,
    );
  }

  @override
  Future<void> deleteAyurvedaItem(String documentId) {
    return _remoteDataSource.deleteAyurvedaItem(documentId);
  }
}
