import 'dart:io';

abstract class AdminRepository {
  Future<Map<String, dynamic>?> getAdminDetails();

  // Ambulances
  Future<void> addAmbulance(Map<String, dynamic> data);
  Stream<List<Map<String, dynamic>>> streamAmbulances();
  Future<List<Map<String, dynamic>>> getAmbulances();
  Future<void> updateAmbulance(String id, Map<String, dynamic> data);
  Future<void> deleteAmbulance(String id);

  // Medical Stores
  Future<String> addMedicalStore({
    required String name,
    required String address,
    required String phone,
    File? image,
  });
  Stream<List<Map<String, dynamic>>> streamMedicalStores();
  Future<List<Map<String, dynamic>>> getMedicalStores();
  Future<void> deleteMedicalStore(String storeId);
  Future<Map<String, dynamic>?> getMedicalStore(String storeId);
  Future<void> updateMedicalStore({
    required String storeId,
    required String name,
    required String address,
    required String phone,
  });

  // Store Categories
  Future<void> saveStoreCategories({
    required String storeId,
    required Map<String, String?> categories,
  });
  Stream<List<Map<String, dynamic>>> streamStoreCategories(String storeId);
  Future<void> deleteStoreCategory({
    required String storeId,
    required String categoryName,
  });
  Future<void> updateCategoryName({
    required String storeId,
    required String categoryId,
    required String newName,
  });

  // Store Category Products
  Future<void> saveStoreProducts({
    required String storeId,
    required String categoryName,
    required List<Map<String, dynamic>> products,
  });
  Stream<List<Map<String, dynamic>>> streamCategoryProducts({
    required String storeId,
    required String categoryId,
  });
  Future<void> updateProductName({
    required String storeId,
    required String categoryId,
    required String productId,
    required String newName,
  });
  Future<void> deleteProduct({
    required String storeId,
    required String categoryId,
    required String productId,
  });

  // Ayurveda
  Future<void> addAyurvedaItem({
    required String name,
    required String description,
    required File image,
  });
  Stream<List<Map<String, dynamic>>> streamAyurvedaItems();
  Future<List<Map<String, dynamic>>> getAyurvedaItems();
  Future<void> updateAyurvedaItem({
    required String documentId,
    required String name,
    required String description,
    File? image,
  });
  Future<void> deleteAyurvedaItem(String documentId);
}
