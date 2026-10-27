import 'dart:io';
import 'package:caresync/features/authentication/domain/repositories/auth_repository.dart';
import 'package:caresync/features/authentication/presentation/providers/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  String? persistedType;
  bool loggedIn = false;
  bool shouldThrow = false;

  @override
  Stream<User?> get authStateChanges => Stream.value(null);

  @override
  User? get currentUser => null;

  @override
  Future<UserCredential> signInPatient({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw Exception('Invalid credentials');
    loggedIn = true;
    persistedType = 'patient';
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInDoctor({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw Exception('Doctor sign in error');
    loggedIn = true;
    persistedType = 'doctor';
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signInAdmin({
    required String email,
    required String password,
  }) async {
    if (shouldThrow) throw Exception('Admin sign in error');
    loggedIn = true;
    persistedType = 'admin';
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signUpPatient({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
  }) async {
    if (shouldThrow) throw Exception('Sign up error');
    loggedIn = true;
    throw UnimplementedError();
  }

  @override
  Future<UserCredential> signUpDoctor({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String gender,
    required String specialization,
    required String clinicLocation,
    File? imageFile,
  }) async {
    if (shouldThrow) throw Exception('Doctor sign up error');
    loggedIn = true;
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    loggedIn = false;
    persistedType = null;
  }

  @override
  Future<String?> sendPasswordResetEmail(String email) async {
    if (shouldThrow) return 'User not found';
    return null;
  }

  @override
  Future<String?> getPersistedUserType() async => persistedType;

  @override
  Future<void> persistUserType(String type) async {
    persistedType = type;
  }

  @override
  Future<bool> isUserLoggedIn() async => loggedIn;
}

void main() {
  group('AuthNotifier Tests', () {
    late FakeAuthRepository fakeRepo;
    late ProviderContainer container;

    setUp(() {
      fakeRepo = FakeAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(fakeRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is unauthenticated and not loading', () {
      final state = container.read(authProvider);
      expect(state.isLoading, false);
      expect(state.error, null);
      expect(state.isAuthenticated, false);
    });

    test('signOut resets persisted values and sets isAuthenticated to false',
        () async {
      fakeRepo.persistedType = 'patient';
      fakeRepo.loggedIn = true;

      await container.read(authProvider.notifier).signOut();

      expect(fakeRepo.loggedIn, false);
      expect(fakeRepo.persistedType, null);
      expect(container.read(authProvider).isAuthenticated, false);
    });

    test('sendPasswordResetEmail handles error correctly', () async {
      fakeRepo.shouldThrow = true;
      final result = await container
          .read(authProvider.notifier)
          .sendPasswordResetEmail('nonexistent@test.com');

      expect(result, 'User not found');
    });

    test('persistUserType stores the user type', () async {
      await fakeRepo.persistUserType('doctor');
      expect(await fakeRepo.getPersistedUserType(), 'doctor');
    });
  });
}
