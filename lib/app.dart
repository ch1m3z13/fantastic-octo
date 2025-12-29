import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/auth_provider.dart';
import 'presentation/login_screen/login_screen.dart';
import 'theme/app_theme.dart';

class AbujaCommuterApp extends ConsumerWidget {
  const AbujaCommuterApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'Abuja Commuter',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: _buildHomeScreen(authState),
    );
  }

  Widget _buildHomeScreen(AuthState authState) {
    // Show login screen if not authenticated
    if (!authState.isAuthenticated) {
      return const LoginScreen();
    }
    
    // Navigate based on role
    if (authState.role == 'DRIVER') {
      // TODO: Replace with your DriverDashboard
      return Scaffold(
        appBar: AppBar(title: const Text('Driver Dashboard')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome, ${authState.user?.fullName ?? "Driver"}!'),
              const SizedBox(height: 20),
              const Text('Driver Dashboard - Coming Soon'),
            ],
          ),
        ),
      );
    } else {
      // TODO: Replace with your RiderDashboard
      return Scaffold(
        appBar: AppBar(title: const Text('Rider Dashboard')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome, ${authState.user?.fullName ?? "Rider"}!'),
              const SizedBox(height: 20),
              const Text('Rider Dashboard - Coming Soon'),
            ],
          ),
        ),
      );
    }
  }
}