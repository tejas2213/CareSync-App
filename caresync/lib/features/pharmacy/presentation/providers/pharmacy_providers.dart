import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/medical_store_model.dart';
import '../../data/models/product_details_model.dart';
import '../../data/repositories/pharmacy_repository_impl.dart';
import '../../domain/repositories/pharmacy_repository.dart';

final pharmacyRepositoryProvider = Provider<PharmacyRepository>((ref) {
  return PharmacyRepositoryImpl();
});

// ─── Cart State & Notifier ───────────────────────────────────────────────────

class CartState {
  final List<ProductData> products;
  final double totalPrice;
  final bool isLoading;
  final bool isPlacingOrder;
  final String? error;

  const CartState({
    this.products = const [],
    this.totalPrice = 0.0,
    this.isLoading = false,
    this.isPlacingOrder = false,
    this.error,
  });

  CartState copyWith({
    List<ProductData>? products,
    double? totalPrice,
    bool? isLoading,
    bool? isPlacingOrder,
    String? error,
  }) {
    return CartState(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      isLoading: isLoading ?? this.isLoading,
      isPlacingOrder: isPlacingOrder ?? this.isPlacingOrder,
      error: error,
    );
  }
}

class CartNotifier extends FamilyNotifier<CartState, String> {
  late final PharmacyRepository _repository;

  @override
  CartState build(String arg) {
    _repository = ref.watch(pharmacyRepositoryProvider);
    fetchCartProducts();
    return const CartState(isLoading: true);
  }

  Future<void> fetchCartProducts() async {
    try {
      final products = await _repository.getCartProducts(arg);
      double total = 0.0;
      for (var p in products) {
        total += (p.price as num).toDouble() * p.quantity;
      }
      state = state.copyWith(
        products: products,
        totalPrice: total,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> updateQuantity(ProductData product, int change) async {
    final newQty = product.quantity + change;
    if (newQty < 1) return;

    try {
      await _repository.updateCartQuantity(arg, product.productId, newQty);
      final updatedList = state.products.map((p) {
        if (p.productId == product.productId) {
          p.quantity = newQty;
        }
        return p;
      }).toList();

      double total = 0.0;
      for (var p in updatedList) {
        total += (p.price as num).toDouble() * p.quantity;
      }

      state = state.copyWith(
        products: updatedList,
        totalPrice: total,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> removeItem(String productId) async {
    try {
      await _repository.removeFromCart(arg, productId);
      final updatedList =
          state.products.where((p) => p.productId != productId).toList();

      double total = 0.0;
      for (var p in updatedList) {
        total += (p.price as num).toDouble() * p.quantity;
      }

      state = state.copyWith(
        products: updatedList,
        totalPrice: total,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<bool> placeOrder({
    required String storeId,
    required String address,
    required String paymentMethod,
  }) async {
    state = state.copyWith(isPlacingOrder: true, error: null);
    try {
      await _repository.placeOrder(
        patientId: arg,
        storeId: storeId,
        cartProducts: state.products,
        totalPrice: state.totalPrice,
        paymentMethod: paymentMethod,
        address: address,
      );
      state = state.copyWith(
        products: [],
        totalPrice: 0.0,
        isPlacingOrder: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(
        isPlacingOrder: false,
        error: e.toString(),
      );
      return false;
    }
  }
}

final cartNotifierProvider =
    NotifierProvider.family<CartNotifier, CartState, String>(CartNotifier.new);

// ─── Wishlist Notifier ───────────────────────────────────────────────────────

class WishlistNotifier extends FamilyNotifier<List<ProductData>, String> {
  late final PharmacyRepository _repository;

  @override
  List<ProductData> build(String arg) {
    _repository = ref.watch(pharmacyRepositoryProvider);
    fetchWishlistProducts();
    return const [];
  }

  Future<void> fetchWishlistProducts() async {
    try {
      final products = await _repository.getWishlistProducts(arg);
      state = products;
    } catch (_) {}
  }

  Future<void> removeProduct(String productId) async {
    try {
      await _repository.removeFromWishlist(arg, productId);
      state = state.where((p) => p.productId != productId).toList();
    } catch (_) {}
  }
}

final wishlistNotifierProvider =
    NotifierProvider.family<WishlistNotifier, List<ProductData>, String>(
        WishlistNotifier.new);

// ─── Products State & Notifier ───────────────────────────────────────────────

class ProductsParam {
  final String storeId;
  final String categoryName;
  final String patientId;

  const ProductsParam({
    required this.storeId,
    required this.categoryName,
    required this.patientId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductsParam &&
          runtimeType == other.runtimeType &&
          storeId == other.storeId &&
          categoryName == other.categoryName &&
          patientId == other.patientId;

  @override
  int get hashCode =>
      storeId.hashCode ^ categoryName.hashCode ^ patientId.hashCode;
}

class ProductsState {
  final List<ProductData> products;
  final Map<String, bool> likedProducts;
  final Map<String, bool> cartProducts;
  final Map<String, int> productQuantities;
  final bool isLoading;
  final String? error;

  const ProductsState({
    this.products = const [],
    this.likedProducts = const {},
    this.cartProducts = const {},
    this.productQuantities = const {},
    this.isLoading = false,
    this.error,
  });

  ProductsState copyWith({
    List<ProductData>? products,
    Map<String, bool>? likedProducts,
    Map<String, bool>? cartProducts,
    Map<String, int>? productQuantities,
    bool? isLoading,
    String? error,
  }) {
    return ProductsState(
      products: products ?? this.products,
      likedProducts: likedProducts ?? this.likedProducts,
      cartProducts: cartProducts ?? this.cartProducts,
      productQuantities: productQuantities ?? this.productQuantities,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProductsNotifier extends FamilyNotifier<ProductsState, ProductsParam> {
  late final PharmacyRepository _repository;

  @override
  ProductsState build(ProductsParam arg) {
    _repository = ref.watch(pharmacyRepositoryProvider);
    fetchProducts();
    return const ProductsState(isLoading: true);
  }

  Future<void> fetchProducts() async {
    try {
      final products =
          await _repository.getProducts(arg.storeId, arg.categoryName);
      final wishlist = await _repository.getWishlistProducts(arg.patientId);
      final cart = await _repository.getCartProducts(arg.patientId);

      final wishlistIds = wishlist.map((p) => p.productId).toSet();
      final Map<String, bool> liked = {};
      final Map<String, bool> inCart = {};
      final Map<String, int> quantities = {};

      for (var p in products) {
        liked[p.productId] = wishlistIds.contains(p.productId);
      }
      for (var c in cart) {
        inCart[c.productId] = true;
        quantities[c.productId] = c.quantity;
      }

      state = state.copyWith(
        products: products,
        likedProducts: liked,
        cartProducts: inCart,
        productQuantities: quantities,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> toggleCart(ProductData product) async {
    final inCart = state.cartProducts[product.productId] ?? false;
    final updatedCart = Map<String, bool>.from(state.cartProducts);
    final updatedQuantities = Map<String, int>.from(state.productQuantities);

    if (inCart) {
      await _repository.removeFromCart(arg.patientId, product.productId);
      updatedCart[product.productId] = false;
      updatedQuantities.remove(product.productId);
    } else {
      await _repository.addToCart(arg.patientId, product);
      updatedCart[product.productId] = true;
      updatedQuantities[product.productId] = 1;
    }

    state = state.copyWith(
      cartProducts: updatedCart,
      productQuantities: updatedQuantities,
    );
  }

  Future<void> toggleLike(ProductData product) async {
    final liked = state.likedProducts[product.productId] ?? false;
    final updatedLiked = Map<String, bool>.from(state.likedProducts);

    if (liked) {
      await _repository.removeFromWishlist(arg.patientId, product.productId);
      updatedLiked[product.productId] = false;
    } else {
      await _repository.addToWishlist(arg.patientId, product);
      updatedLiked[product.productId] = true;
    }

    state = state.copyWith(likedProducts: updatedLiked);
  }
}

final productsNotifierProvider =
    NotifierProvider.family<ProductsNotifier, ProductsState, ProductsParam>(
        ProductsNotifier.new);

// ─── Streams & Future Providers ──────────────────────────────────────────────

final medicalStoresStreamProvider =
    StreamProvider<List<MedicalStoresModel>>((ref) {
  return ref.watch(pharmacyRepositoryProvider).getMedicalStoresStream();
});

final storeCategoriesStreamProvider =
    StreamProvider.family<QuerySnapshot<Map<String, dynamic>>, String>(
        (ref, storeId) {
  return ref.watch(pharmacyRepositoryProvider).getCategoriesStream(storeId);
});

final pharmacyOrdersProvider =
    FutureProvider.family<List<Map<String, dynamic>>, String>((ref, patientId) {
  return ref.watch(pharmacyRepositoryProvider).getOrders(patientId);
});
