import 'package:caresync/features/pharmacy/data/models/product_details_model.dart';
import 'package:caresync/features/pharmacy/domain/repositories/pharmacy_repository.dart';
import 'package:caresync/features/pharmacy/presentation/providers/pharmacy_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakePharmacyRepository implements PharmacyRepository {
  List<ProductData> cart = [];
  bool shouldThrow = false;

  @override
  Future<void> addToCart(String patientId, ProductData product) async {
    if (shouldThrow) throw Exception('Add to cart failed');
    cart.add(product);
  }

  @override
  Future<void> removeFromCart(String patientId, String productId) async {
    cart.removeWhere((p) => p.productId == productId);
  }

  @override
  Future<void> updateCartQuantity(
    String patientId,
    String productId,
    int quantity,
  ) async {
    final idx = cart.indexWhere((p) => p.productId == productId);
    if (idx != -1) {
      cart[idx].quantity = quantity;
    }
  }

  @override
  Future<List<ProductData>> getCartProducts(String patientId) async => cart;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('CartState and Pharmacy Tests', () {
    test('CartState defaults and copyWith', () {
      const state = CartState();
      expect(state.products.isEmpty, true);
      expect(state.totalPrice, 0.0);
      expect(state.isLoading, false);
      expect(state.isPlacingOrder, false);

      final product = ProductData(
        productId: 'prod_1',
        name: 'Paracetamol',
        price: 25.0,
        mrp: 30.0,
        image: 'img.png',
        quantity: 2,
      );

      final updated = state.copyWith(
        products: [product],
        totalPrice: 50.0,
        isLoading: false,
      );

      expect(updated.products.length, 1);
      expect(updated.totalPrice, 50.0);
    });

    test('CartNotifier fetch, updateQuantity, and removeItem', () async {
      final fakeRepo = FakePharmacyRepository();
      fakeRepo.cart = [
        ProductData(
          productId: 'prod_aspirin',
          name: 'Aspirin',
          price: 10.0,
          mrp: 12.0,
          image: 'aspirin.png',
          quantity: 3,
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          pharmacyRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );

      final notifier =
          container.read(cartNotifierProvider('patient_123').notifier);
      await notifier.fetchCartProducts();

      final state = container.read(cartNotifierProvider('patient_123'));
      expect(state.products.length, 1);
      expect(state.totalPrice, 30.0);

      await notifier.updateQuantity(state.products.first, 2);
      final updatedState = container.read(cartNotifierProvider('patient_123'));
      expect(updatedState.totalPrice, 50.0);

      await notifier.removeItem('prod_aspirin');
      final emptyState = container.read(cartNotifierProvider('patient_123'));
      expect(emptyState.products.isEmpty, true);
      expect(emptyState.totalPrice, 0.0);
    });
  });
}
