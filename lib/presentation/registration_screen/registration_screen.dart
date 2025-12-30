import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import './widgets/driver_details_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/registration_form_widget.dart';
import './widgets/terms_and_conditions_widget.dart';

/// Registration screen for new user account creation
/// Supports both rider and driver registration with role-specific fields
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Basic form controllers
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController(text: '+234');
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Driver-specific controllers
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _vehiclePlateController = TextEditingController();
  final _licenseNumberController = TextEditingController();

  // State variables
  bool _isDriver = false;
  String? _selectedRoute;
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _isLoading = false;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupProgressTracking();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _vehiclePlateController.dispose();
    _licenseNumberController.dispose();
    super.dispose();
  }

  void _setupProgressTracking() {
    _fullNameController.addListener(_updateProgress);
    _phoneController.addListener(_updateProgress);
    _usernameController.addListener(_updateProgress);
    _passwordController.addListener(_updateProgress);
    _confirmPasswordController.addListener(_updateProgress);
    _vehicleMakeController.addListener(_updateProgress);
    _vehicleModelController.addListener(_updateProgress);
    _vehicleYearController.addListener(_updateProgress);
    _vehiclePlateController.addListener(_updateProgress);
    _licenseNumberController.addListener(_updateProgress);
  }

  void _updateProgress() {
    int totalFields = _isDriver ? 12 : 7;
    int filledFields = 0;

    if (_fullNameController.text.isNotEmpty) filledFields++;
    if (_phoneController.text.length > 4) filledFields++;
    if (_usernameController.text.isNotEmpty) filledFields++;
    if (_passwordController.text.isNotEmpty) filledFields++;
    if (_confirmPasswordController.text.isNotEmpty) filledFields++;
    if (_termsAccepted) filledFields++;
    if (_privacyAccepted) filledFields++;

    if (_isDriver) {
      if (_vehicleMakeController.text.isNotEmpty) filledFields++;
      if (_vehicleModelController.text.isNotEmpty) filledFields++;
      if (_vehicleYearController.text.isNotEmpty) filledFields++;
      if (_vehiclePlateController.text.isNotEmpty) filledFields++;
      if (_licenseNumberController.text.isNotEmpty) filledFields++;
    }

    setState(() {
      _progress = filledFields / totalFields;
    });
  }

  bool _canSubmit() {
    if (!_termsAccepted || !_privacyAccepted) return false;

    if (_isDriver) {
      return _fullNameController.text.isNotEmpty &&
          _phoneController.text.length > 4 &&
          _usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _confirmPasswordController.text.isNotEmpty &&
          _vehicleMakeController.text.isNotEmpty &&
          _vehicleModelController.text.isNotEmpty &&
          _vehicleYearController.text.isNotEmpty &&
          _vehiclePlateController.text.isNotEmpty &&
          _licenseNumberController.text.isNotEmpty &&
          _selectedRoute != null;
    }

    return _fullNameController.text.isNotEmpty &&
        _phoneController.text.length > 4 &&
        _usernameController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty;
  }

  Future<void> _handleRegistration() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Please fill all required fields correctly');
      return;
    }

    if (!_termsAccepted || !_privacyAccepted) {
      _showErrorSnackBar('Please accept Terms of Service and Privacy Policy');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    // Check for duplicate username (mock validation)
    if (_usernameController.text.toLowerCase() == 'testuser') {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('Username already exists. Please choose another.');
      return;
    }

    setState(() {
      _isLoading = false;
    });

    // Show success message
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: theme.colorScheme.secondary,
              size: 32,
            ),
            SizedBox(width: 12),
            Text('Welcome!'),
          ],
        ),
        content: Text(
          'Your account has been created successfully. You can now start using Abuja Commuter.',
          style: theme.textTheme.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(
                context,
                _isDriver ? '/driver-home-screen' : '/login-screen',
              );
            },
            child: Text('Get Started'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            HapticFeedback.lightImpact();
            Navigator.pop(context);
          },
        ),
        title: Text('Register'),
        elevation: 0,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Progress Indicator
                  ProgressIndicatorWidget(progress: _progress),
                  SizedBox(height: 3.h),

                  // Welcome Text
                  Text(
                    'Create Your Account',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Join Abuja Commuter for safe and reliable ridesharing',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 3.h),

                  // Registration Form
                  RegistrationFormWidget(
                    formKey: _formKey,
                    fullNameController: _fullNameController,
                    phoneController: _phoneController,
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    isDriver: _isDriver,
                    onDriverToggle: (value) {
                      setState(() {
                        _isDriver = value;
                      });
                      _updateProgress();
                    },
                  ),

                  // Driver Details (conditionally shown)
                  _isDriver
                      ? DriverDetailsWidget(
                          vehicleMakeController: _vehicleMakeController,
                          vehicleModelController: _vehicleModelController,
                          vehicleYearController: _vehicleYearController,
                          vehiclePlateController: _vehiclePlateController,
                          licenseNumberController: _licenseNumberController,
                          selectedRoute: _selectedRoute,
                          onRouteChanged: (value) {
                            setState(() {
                              _selectedRoute = value;
                            });
                            _updateProgress();
                          },
                        )
                      : SizedBox.shrink(),

                  SizedBox(height: 3.h),

                  // Terms and Conditions
                  TermsAndConditionsWidget(
                    termsAccepted: _termsAccepted,
                    privacyAccepted: _privacyAccepted,
                    onTermsChanged: (value) {
                      setState(() {
                        _termsAccepted = value ?? false;
                      });
                      _updateProgress();
                    },
                    onPrivacyChanged: (value) {
                      setState(() {
                        _privacyAccepted = value ?? false;
                      });
                      _updateProgress();
                    },
                  ),

                  SizedBox(height: 3.h),

                  // Create Account Button
                  SizedBox(
                    width: double.infinity,
                    height: 6.h,
                    child: ElevatedButton(
                      onPressed: _canSubmit() && !_isLoading
                          ? _handleRegistration
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _canSubmit()
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surface,
                        foregroundColor: _canSubmit()
                            ? theme.colorScheme.onPrimary
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                      child: _isLoading
                          ? SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              'Create Account',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Login Link
                  Center(
                    child: TextButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        Navigator.pushReplacementNamed(
                          context,
                          '/login-screen',
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 2.h),
                ],
              ),
            ),

            // Loading Overlay
            _isLoading
                ? Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: Center(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 16),
                              Text(
                                'Creating Account...',
                                style: theme.textTheme.titleMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
