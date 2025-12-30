import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/account_info_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/support_section_widget.dart';
import './widgets/vehicle_info_widget.dart';
import './widgets/wallet_widget.dart';

/// Profile Screen - Manages user account information with role-specific details
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final int _currentBottomNavIndex = 3; // Profile tab active
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "name": "Chukwuemeka Okonkwo",
    "email": "chukwuemeka.okonkwo@example.com",
    "phone": "+234 803 456 7890",
    "profilePhoto":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1073e8bde-1764705856495.png",
    "isDriver": true,
    "rating": 4.8,
    "reviewCount": 127,
    "registrationDate": DateTime(2024, 3, 15),
    "isVerified": true,
    "walletBalance": 15750.50,
  };

  // Mock vehicle data for drivers
  final Map<String, dynamic> _vehicleData = {
    "make": "Toyota",
    "model": "Corolla",
    "year": 2020,
    "color": "Silver",
    "licensePlate": "ABC-123-XY",
    "insuranceExpiry": DateTime(2025, 6, 30),
    "inspectionExpiry": DateTime(2025, 4, 15),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDriver = _userData['isDriver'] as bool? ?? false;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Profile'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeaderWidget(
              userData: _userData,
              onEditPhoto: _handleEditPhoto,
            ),
            AccountInfoWidget(userData: _userData),
            if (isDriver) VehicleInfoWidget(vehicleData: _vehicleData),
            WalletWidget(
              balance: _userData['walletBalance'] as double? ?? 0.0,
              onAddFunds: _handleAddFunds,
              onViewTransactions: _handleViewTransactions,
            ),
            SettingsSectionWidget(
              isDriver: isDriver,
              notificationsEnabled: _notificationsEnabled,
              darkModeEnabled: _darkModeEnabled,
              onNotificationsChanged: (value) {
                setState(() => _notificationsEnabled = value);
                _showSnackBar(
                  'Notifications ${value ? 'enabled' : 'disabled'}',
                );
              },
              onDarkModeChanged: (value) {
                setState(() => _darkModeEnabled = value);
                _showSnackBar('Dark mode ${value ? 'enabled' : 'disabled'}');
              },
              onLanguagePressed: _handleLanguageSettings,
              onPrivacyPressed: _handlePrivacySettings,
              onSecurityPressed: _handleSecuritySettings,
            ),
            SupportSectionWidget(
              onHelpCenterPressed: _handleHelpCenter,
              onContactPressed: _handleContactSupport,
              onFeedbackPressed: _handleSendFeedback,
            ),
            _buildAccountActions(context),
            SizedBox(height: 2.h),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
      ),
    );
  }

  Widget _buildAccountActions(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _handleLogout,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 1.5.h),
                side: BorderSide(color: theme.colorScheme.error, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'logout',
                    color: theme.colorScheme.error,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Logout',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 1.h),
          TextButton(
            onPressed: _handleDeleteAccount,
            child: Text(
              'Delete Account',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error.withValues(alpha: 0.7),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleBottomNavTap(int index) {
    if (index == _currentBottomNavIndex) return;

    HapticFeedback.lightImpact();

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/rider-home-screen');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/search-screen');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/booking-confirmation-screen');
        break;
      case 3:
        // Already on profile screen
        break;
    }
  }

  void _handleEditPhoto() {
    HapticFeedback.mediumImpact();
    _showSnackBar('Photo editing functionality coming soon');
  }

  void _handleAddFunds() {
    HapticFeedback.mediumImpact();
    _showDialog(
      title: 'Add Funds',
      content: 'Select payment method to add funds to your wallet',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showSnackBar('Payment processing...');
          },
          child: const Text('Continue'),
        ),
      ],
    );
  }

  void _handleViewTransactions() {
    HapticFeedback.lightImpact();
    _showSnackBar('Transaction history coming soon');
  }

  void _handleLanguageSettings() {
    HapticFeedback.lightImpact();
    _showSnackBar('Language settings coming soon');
  }

  void _handlePrivacySettings() {
    HapticFeedback.lightImpact();
    _showSnackBar('Privacy settings coming soon');
  }

  void _handleSecuritySettings() {
    HapticFeedback.lightImpact();
    _showSnackBar('Security settings coming soon');
  }

  void _handleHelpCenter() {
    HapticFeedback.lightImpact();
    _showSnackBar('Help center coming soon');
  }

  void _handleContactSupport() {
    HapticFeedback.lightImpact();
    _showSnackBar('Contact support coming soon');
  }

  void _handleSendFeedback() {
    HapticFeedback.lightImpact();
    _showSnackBar('Feedback form coming soon');
  }

  void _handleLogout() {
    HapticFeedback.mediumImpact();
    _showDialog(
      title: 'Logout',
      content: 'Are you sure you want to logout?',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showSnackBar('Logged out successfully');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Logout'),
        ),
      ],
    );
  }

  void _handleDeleteAccount() {
    HapticFeedback.mediumImpact();
    _showDialog(
      title: 'Delete Account',
      content:
          'This action cannot be undone. All your data will be permanently deleted.',
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
            _showSnackBar('Account deletion request submitted');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showDialog({
    required String title,
    required String content,
    required List<Widget> actions,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions,
      ),
    );
  }
}