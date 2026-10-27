import 'package:caresync/features/authentication/presentation/providers/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Determines which route to navigate to after the splash animation.
///
/// Returns the route name string based on the persisted user type.
/// The splash page reads this provider to decide where to redirect.
final splashRedirectProvider = FutureProvider<String>((ref) async {
  final userType = await ref.watch(persistedUserTypeProvider.future);
  switch (userType) {
    case 'patient':
      return '/auth/patient/sign-in';
    case 'doctor':
      return '/auth/doctor/sign-in';
    case 'admin':
      return '/auth/admin/sign-in';
    default:
      return '/landing';
  }
});
