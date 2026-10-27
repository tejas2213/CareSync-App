import 'package:caresync/features/admin/domain/repositories/admin_repository.dart';
import 'package:caresync/features/admin/presentation/providers/admin_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAdminRepository implements AdminRepository {
  bool shouldFail = false;
  List<Map<String, dynamic>> ambulances = [];

  @override
  Future<void> addAmbulance(Map<String, dynamic> data) async {
    if (shouldFail) throw Exception('Failed to add ambulance');
    ambulances.add(data);
  }

  @override
  Future<void> deleteAmbulance(String id) async {
    if (shouldFail) throw Exception('Failed to delete ambulance');
    ambulances.removeWhere((a) => a['id'] == id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('AdminActionNotifier Tests', () {
    late FakeAdminRepository fakeRepo;
    late ProviderContainer container;

    setUp(() {
      fakeRepo = FakeAdminRepository();
      container = ProviderContainer(
        overrides: [
          adminRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('addAmbulance succeeds and updates state', () async {
      final notifier = container.read(adminActionNotifierProvider.notifier);
      final success = await notifier.addAmbulance({
        'id': 'amb_1',
        'name': 'City Ambulance',
        'phone': '1234567890',
        'location': 'Pune',
      });

      expect(success, true);
      expect(fakeRepo.ambulances.length, 1);
      final state = container.read(adminActionNotifierProvider);
      expect(state.isLoading, false);
      expect(state.isSuccess, true);
      expect(state.errorMessage, null);
    });

    test('addAmbulance handles failure and sets error message', () async {
      fakeRepo.shouldFail = true;
      final notifier = container.read(adminActionNotifierProvider.notifier);
      final success = await notifier.addAmbulance({'id': 'amb_2'});

      expect(success, false);
      final state = container.read(adminActionNotifierProvider);
      expect(state.isLoading, false);
      expect(state.isSuccess, false);
      expect(state.errorMessage, isNotNull);
    });

    test('deleteAmbulance succeeds', () async {
      fakeRepo.ambulances = [
        {'id': 'amb_to_delete'}
      ];
      final notifier = container.read(adminActionNotifierProvider.notifier);
      final success = await notifier.deleteAmbulance('amb_to_delete');

      expect(success, true);
      expect(fakeRepo.ambulances.isEmpty, true);
    });
  });
}
