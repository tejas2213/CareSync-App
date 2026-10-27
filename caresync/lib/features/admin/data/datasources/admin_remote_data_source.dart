import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

abstract class AdminRemoteDataSource {
  Future<Map<String, dynamic>?> getAdminDetails();

  Future<void> addAmbulance(Map<String, dynamic> data);
  Stream<List<Map<String, dynamic>>> streamAmbulances();
  Future<List<Map<String, dynamic>>> getAmbulances();
  Future<void> updateAmbulance(String id, Map<String, dynamic> data);
  Future<void> deleteAmbulance(String id);

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

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AdminRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  @override
  Future<Map<String, dynamic>?> getAdminDetails() async {
    final doc = await _firestore.collection('CareSync').doc('admin').get();
    return doc.data();
  }

  @override
  Future<void> addAmbulance(Map<String, dynamic> data) async {
    await _firestore.collection('Ambulances').add(data);
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAmbulances() {
    return _firestore.collection('Ambulances').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAmbulances() async {
    final snapshot = await _firestore.collection('Ambulances').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  @override
  Future<void> updateAmbulance(String id, Map<String, dynamic> data) async {
    await _firestore.collection('Ambulances').doc(id).update(data);
  }

  @override
  Future<void> deleteAmbulance(String id) async {
    await _firestore.collection('Ambulances').doc(id).delete();
  }

  @override
  Future<String> addMedicalStore({
    required String name,
    required String address,
    required String phone,
    File? image,
  }) async {
    String imageUrl = '';
    if (image != null) {
      final storageRef = _storage.ref().child(
          'CareSync/medical_stores/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = await storageRef.putFile(image);
      imageUrl = await uploadTask.ref.getDownloadURL();
    }

    final newStoreRef = _firestore.collection('Medical Stores').doc();
    await newStoreRef.set({
      'name': name,
      'phone': phone,
      'address': address,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });

    return newStoreRef.id;
  }

  @override
  Stream<List<Map<String, dynamic>>> streamMedicalStores() {
    return _firestore
        .collection('Medical Stores')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getMedicalStores() async {
    final snapshot = await _firestore
        .collection('Medical Stores')
        .orderBy('timestamp', descending: true)
        .get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  @override
  Future<void> deleteMedicalStore(String storeId) async {
    await _firestore.collection('Medical Stores').doc(storeId).delete();
  }

  @override
  Future<Map<String, dynamic>?> getMedicalStore(String storeId) async {
    final doc =
        await _firestore.collection('Medical Stores').doc(storeId).get();
    return doc.data();
  }

  @override
  Future<void> updateMedicalStore({
    required String storeId,
    required String name,
    required String address,
    required String phone,
  }) async {
    await _firestore.collection('Medical Stores').doc(storeId).update({
      'name': name,
      'address': address,
      'phone': phone,
    });
  }

  @override
  Future<void> saveStoreCategories({
    required String storeId,
    required Map<String, String?> categories,
  }) async {
    final storeCategories = _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories');

    for (var entry in categories.entries) {
      String? imageUrl;
      if (entry.value != null && entry.value!.isNotEmpty) {
        final file = File(entry.value!);
        if (await file.exists()) {
          final storageRef = _storage.ref().child(
              'CareSync/medical_stores/$storeId/categories/${entry.key}.jpg');
          final uploadTask = await storageRef.putFile(file);
          imageUrl = await uploadTask.ref.getDownloadURL();
        }
      }

      await storeCategories.doc(entry.key).set({
        'categoryName': entry.key,
        'image': imageUrl,
      });
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> streamStoreCategories(String storeId) {
    return _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Future<void> deleteStoreCategory({
    required String storeId,
    required String categoryName,
  }) async {
    await _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories')
        .doc(categoryName)
        .delete();
  }

  @override
  Future<void> updateCategoryName({
    required String storeId,
    required String categoryId,
    required String newName,
  }) async {
    await _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories')
        .doc(categoryId)
        .update({'name': newName});
  }

  @override
  Stream<List<Map<String, dynamic>>> streamCategoryProducts({
    required String storeId,
    required String categoryId,
  }) {
    return _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Future<void> updateProductName({
    required String storeId,
    required String categoryId,
    required String productId,
    required String newName,
  }) async {
    await _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .doc(productId)
        .update({'name': newName});
  }

  @override
  Future<void> deleteProduct({
    required String storeId,
    required String categoryId,
    required String productId,
  }) async {
    await _firestore
        .collection('Medical Stores')
        .doc(storeId)
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .doc(productId)
        .delete();
  }

  @override
  Future<void> saveStoreProducts({
    required String storeId,
    required String categoryName,
    required List<Map<String, dynamic>> products,
  }) async {
    final productCol = _firestore.collection(
        'Medical Stores/$storeId/categories/$categoryName/products');

    for (var product in products) {
      String? imageUrl;
      final localImagePath = product['localImagePath'] as String?;
      if (localImagePath != null && localImagePath.isNotEmpty) {
        final file = File(localImagePath);
        if (await file.exists()) {
          final ref = _storage.ref().child(
              'CareSync/medical_stores/$storeId/categories/$categoryName/products/${DateTime.now().toIso8601String()}_${product['name']}.jpg');
          final uploadTask = await ref.putFile(file);
          imageUrl = await uploadTask.ref.getDownloadURL();
        }
      }

      await productCol.add({
        'name': product['name'],
        'price': product['price'],
        'mrp': product['mrp'],
        'imageUrl': imageUrl ?? product['imageUrl'],
        'category': categoryName,
      });
    }
  }

  @override
  Future<void> addAyurvedaItem({
    required String name,
    required String description,
    required File image,
  }) async {
    final storageRef = _storage
        .ref()
        .child('CareSync/ayurveda/${DateTime.now().toIso8601String()}');
    final uploadTask = await storageRef.putFile(image);
    final imageUrl = await uploadTask.ref.getDownloadURL();

    await _firestore.collection('Ayurveda').add({
      'name': name,
      'description': description,
      'image': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Map<String, dynamic>>> streamAyurvedaItems() {
    return _firestore
        .collection('Ayurveda')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getAyurvedaItems() async {
    final querySnapshot = await _firestore
        .collection('Ayurveda')
        .orderBy('createdAt', descending: true)
        .get();
    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
  }

  @override
  Future<void> updateAyurvedaItem({
    required String documentId,
    required String name,
    required String description,
    File? image,
  }) async {
    final updateData = <String, dynamic>{
      'name': name,
      'description': description,
    };
    if (image != null) {
      final storageRef = _storage
          .ref()
          .child('CareSync/ayurveda/${DateTime.now().toIso8601String()}');
      final uploadTask = await storageRef.putFile(image);
      updateData['image'] = await uploadTask.ref.getDownloadURL();
    }
    await _firestore.collection('Ayurveda').doc(documentId).update(updateData);
  }

  @override
  Future<void> deleteAyurvedaItem(String documentId) async {
    await _firestore.collection('Ayurveda').doc(documentId).delete();
  }
}
