import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The user type stored after login.
enum UserType { patient, doctor, admin, unknown }

/// Authentication state managed by Riverpod.
class AuthState {
  final User? user;
  final UserType userType;
  final bool isLoading;
  final String? error;

  const AuthState({
    this.user,
    this.userType = UserType.unknown,
    this.isLoading = false,
    this.error,
  });

  AuthState copyWith({
    User? user,
    UserType? userType,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      userType: userType ?? this.userType,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  bool get isAuthenticated => user != null;
}

/// Provider exposing the current Firebase [User] as a stream.
final firebaseAuthUserProvider = StreamProvider<User?>(
  (ref) => FirebaseAuth.instance.authStateChanges(),
);

/// [AuthNotifier] handles sign-in, sign-up, and sign-out logic.
/// Pages use [authProvider] to read and watch authentication state.
class AuthNotifier extends Notifier<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  AuthState build() => const AuthState();

  // ─── Patient Sign In ──────────────────────────────────────────────────────

  Future<void> signInPatient({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final snap = await _firestore
            .collection('CareSync')
            .doc('patients')
            .collection('accounts')
            .doc(user.uid)
            .get();
        if (snap.exists) {
          await _persistUserType('patient');
          state = state.copyWith(
            user: user,
            userType: UserType.patient,
            isLoading: false,
          );
        } else {
          await _auth.signOut();
          state = state.copyWith(
            isLoading: false,
            error:
                'This account is not registered as a patient. Please check your credentials.',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _friendlyAuthError(e),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ─── Doctor Sign In ───────────────────────────────────────────────────────

  Future<void> signInDoctor({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        final snap = await _firestore
            .collection('CareSync')
            .doc('doctors')
            .collection('accounts')
            .doc(user.uid)
            .get();
        if (snap.exists) {
          await _persistUserType('doctor');
          state = state.copyWith(
            user: user,
            userType: UserType.doctor,
            isLoading: false,
          );
        } else {
          await _auth.signOut();
          state = state.copyWith(
            isLoading: false,
            error:
                'This account is not registered as a doctor. Please check your credentials.',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _friendlyAuthError(e),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ─── Admin Sign In ────────────────────────────────────────────────────────

  Future<void> signInAdmin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user != null) {
        await _persistUserType('admin');
        state = state.copyWith(
          user: user,
          userType: UserType.admin,
          isLoading: false,
        );
      }
    } on FirebaseAuthException catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: _friendlyAuthError(e),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // ─── Sign Out ─────────────────────────────────────────────────────────────

  Future<void> signOut() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLoggedIn');
    await prefs.remove('userType');
    state = const AuthState();
  }

  // ─── Password Reset ───────────────────────────────────────────────────────

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Future<void> _persistUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userType', type);
  }

  String _friendlyAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      default:
        return e.message ?? 'An error occurred. Please try again.';
    }
  }
}

/// The main auth provider. Widgets use [ref.watch(authProvider)] to rebuild
/// on auth state changes and [ref.read(authProvider.notifier)] to trigger actions.
final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

/// Provider to read the persisted user type from SharedPreferences.
/// Used on the splash screen to determine where to redirect.
final persistedUserTypeProvider = FutureProvider<String?>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('userType');
});
