import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../core/app_export.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_icon_widget.dart';

/// Splash Screen for Abuja Commuter
/// Provides branded app launch experience while initializing core services
/// and determining user authentication status for role-based navigation
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  bool _showRetry = false;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  /// Setup logo scale and fade animations
  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );

    _animationController.forward();
  }

  /// Initialize app services and determine navigation route
  Future<void> _initializeApp() async {
    setState(() {
      _isInitializing = true;
      _showRetry = false;
    });

    try {
      // Initialize authentication service
      final authService = context.read<AuthService>();
      await authService.initialize();

      // Additional initialization tasks can be added here:
      // - Load user preferences
      // - Fetch route configurations
      // - Prepare cached virtual bus stop data
      // - Initialize analytics/crash reporting
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Ensure smooth animation completion
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate based on authentication status
      final route = authService.getHomeRoute();
      Navigator.pushReplacementNamed(context, route);
      
    } catch (e) {
      // Handle initialization errors
      debugPrint('Initialization error: $e');
      
      if (!mounted) return;

      // Show retry option after 2 seconds
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
        _showRetry = true;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Set system UI overlay style to match brand colors
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: theme.colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primaryContainer,
              Colors.white,
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              _buildAnimatedLogo(theme),
              const SizedBox(height: 24),
              _buildAppName(theme),
              const SizedBox(height: 8),
              _buildTagline(theme),
              const Spacer(flex: 2),
              if (_isInitializing) _buildLoadingIndicator(theme),
              if (_showRetry) _buildRetryButton(theme),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  /// Build animated logo with scale and fade effects
  Widget _buildAnimatedLogo(ThemeData theme) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _fadeAnimation.value,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'directions_bus',
                  color: theme.colorScheme.primary,
                  size: 64,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// Build app name text
  Widget _buildAppName(ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        'Abuja Commuter',
        style: theme.textTheme.headlineLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build tagline text
  Widget _buildTagline(ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Text(
        'Safe. Scheduled. Secure.',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: Colors.white.withValues(alpha: 0.9),
          letterSpacing: 0.8,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  /// Build loading indicator
  Widget _buildLoadingIndicator(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(
              Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Initializing...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  /// Build retry button for failed initialization
  Widget _buildRetryButton(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Connection timeout',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _initializeApp,
          icon: CustomIconWidget(
            iconName: 'refresh',
            color: theme.colorScheme.primary,
            size: 20,
          ),
          label: Text(
            'Retry',
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: theme.colorScheme.primary,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }
}