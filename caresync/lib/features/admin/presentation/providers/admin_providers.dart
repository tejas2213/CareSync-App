import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepositoryImpl();
});

final adminDetailsFutureProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.getAdminDetails();
});

final adminAmbulancesStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.streamAmbulances();
});

final adminStoresStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.streamMedicalStores();
});

final adminAyurvedaStreamProvider =
    StreamProvider.autoDispose<List<Map<String, dynamic>>>((ref) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.streamAyurvedaItems();
});

final adminStoreCategoriesStreamProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, storeId) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.streamStoreCategories(storeId);
});

final adminCategoryProductsStreamProvider = StreamProvider.autoDispose
    .family<List<Map<String, dynamic>>, ({String storeId, String categoryId})>(
        (ref, param) {
  final repository = ref.watch(adminRepositoryProvider);
  return repository.streamCategoryProducts(
    storeId: param.storeId,
    categoryId: param.categoryId,
  );
});

class AdminActionState {
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  const AdminActionState({
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  AdminActionState copyWith({
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return AdminActionState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AdminActionNotifier extends StateNotifier<AdminActionState> {
  final AdminRepository _repository;

  AdminActionNotifier(this._repository) : super(const AdminActionState());

  Future<bool> addAmbulance(Map<String, dynamic> data) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.addAmbulance(data);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> updateAmbulance(String id, Map<String, dynamic> data) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateAmbulance(id, data);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> deleteAmbulance(String id) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.deleteAmbulance(id);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<String?> addMedicalStore({
    required String name,
    required String address,
    required String phone,
    File? image,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      final id = await _repository.addMedicalStore(
        name: name,
        address: address,
        phone: phone,
        image: image,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return id;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return null;
    }
  }

  Future<bool> deleteMedicalStore(String storeId) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.deleteMedicalStore(storeId);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> updateMedicalStore({
    required String storeId,
    required String name,
    required String address,
    required String phone,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateMedicalStore(
        storeId: storeId,
        name: name,
        address: address,
        phone: phone,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> saveStoreCategories({
    required String storeId,
    required Map<String, String?> categories,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.saveStoreCategories(
        storeId: storeId,
        categories: categories,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> deleteStoreCategory({
    required String storeId,
    required String categoryName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.deleteStoreCategory(
        storeId: storeId,
        categoryName: categoryName,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> updateCategoryName({
    required String storeId,
    required String categoryId,
    required String newName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateCategoryName(
        storeId: storeId,
        categoryId: categoryId,
        newName: newName,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> updateProductName({
    required String storeId,
    required String categoryId,
    required String productId,
    required String newName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateProductName(
        storeId: storeId,
        categoryId: categoryId,
        productId: productId,
        newName: newName,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> deleteProduct({
    required String storeId,
    required String categoryId,
    required String productId,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.deleteProduct(
        storeId: storeId,
        categoryId: categoryId,
        productId: productId,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> saveStoreProducts({
    required String storeId,
    required String categoryName,
    required List<Map<String, dynamic>> products,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.saveStoreProducts(
        storeId: storeId,
        categoryName: categoryName,
        products: products,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> addAyurvedaItem({
    required String name,
    required String description,
    required File image,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.addAyurvedaItem(
        name: name,
        description: description,
        image: image,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> updateAyurvedaItem({
    required String documentId,
    required String name,
    required String description,
    File? image,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.updateAyurvedaItem(
        documentId: documentId,
        name: name,
        description: description,
        image: image,
      );
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }

  Future<bool> deleteAyurvedaItem(String documentId) async {
    state =
        state.copyWith(isLoading: true, errorMessage: null, isSuccess: false);
    try {
      await _repository.deleteAyurvedaItem(documentId);
      state = state.copyWith(isLoading: false, isSuccess: true);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
      return false;
    }
  }
}

final adminActionNotifierProvider =
    StateNotifierProvider.autoDispose<AdminActionNotifier, AdminActionState>(
  (ref) {
    final repository = ref.watch(adminRepositoryProvider);
    return AdminActionNotifier(repository);
  },
);
