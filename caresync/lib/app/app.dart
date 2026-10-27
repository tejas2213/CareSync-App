import 'package:caresync/app/router/app_router.dart';
import 'package:caresync/app/theme/app_theme.dart';
import 'package:caresync/features/onboarding/presentation/pages/splash_page.dart';
import 'package:flutter/material.dart';

/// Root application widget.
///
/// [ProviderScope] is placed in [main.dart] so that providers are available
/// to the whole widget tree. This widget only configures the MaterialApp.
class CareSync extends StatelessWidget {
  const CareSync({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareSync',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
