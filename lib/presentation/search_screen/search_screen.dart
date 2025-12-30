import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/advanced_options_widget.dart';
import './widgets/current_location_widget.dart';
import './widgets/destination_picker_widget.dart';
import './widgets/recent_searches_widget.dart';
import './widgets/time_picker_widget.dart';

/// Search Screen for finding available rides
/// Enables riders to specify journey details with time and destination selection
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  // Current location state
  String _currentLocation = "Dutse Junction, Abuja";

  // Time selection state
  bool _isLeaveNow = true;
  TimeOfDay? _selectedTime;

  // Destination selection state
  String? _selectedDestination;

  // Advanced options state
  bool _isAdvancedOptionsExpanded = false;
  int _passengerCount = 1;
  bool _hasAccessibilityRequirements = false;

  // Loading state
  bool _isSearching = false;

  // Recent searches mock data
  final List<Map<String, String>> _recentSearches = [
    {"destination": "Jabi", "time": "08:00 AM"},
    {"destination": "Wuse", "time": "09:30 AM"},
    {"destination": "Maitama", "time": "07:45 AM"},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Find Rides',
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'search',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _canSearch() ? _handleSearch : null,
            tooltip: 'Search',
          ),
          SizedBox(width: 2.w),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Current Location Section
                    CurrentLocationWidget(
                      currentLocation: _currentLocation,
                      onUseCurrentLocation: _handleUseCurrentLocation,
                      onManualInput: _handleManualLocationInput,
                    ),
                    SizedBox(height: 2.h),

                    // Time Picker Section
                    TimePickerWidget(
                      isLeaveNow: _isLeaveNow,
                      selectedTime: _selectedTime,
                      onLeaveNowToggle: _handleLeaveNowToggle,
                      onSelectTime: _handleSelectTime,
                    ),
                    SizedBox(height: 2.h),

                    // Destination Picker Section
                    DestinationPickerWidget(
                      selectedDestination: _selectedDestination,
                      onDestinationSelected: _handleDestinationSelected,
                    ),
                    SizedBox(height: 2.h),

                    // Advanced Options Section
                    AdvancedOptionsWidget(
                      isExpanded: _isAdvancedOptionsExpanded,
                      passengerCount: _passengerCount,
                      hasAccessibilityRequirements:
                          _hasAccessibilityRequirements,
                      onToggleExpanded: _handleToggleAdvancedOptions,
                      onPassengerCountChanged: _handlePassengerCountChanged,
                      onAccessibilityToggle: _handleAccessibilityToggle,
                    ),
                    SizedBox(height: 2.h),

                    // Recent Searches Section
                    RecentSearchesWidget(
                      recentSearches: _recentSearches,
                      onSearchSelected: _handleRecentSearchSelected,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),

            // Search Button
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.08),
                    blurRadius: 8,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _canSearch() ? _handleSearch : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSearching
                      ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.onPrimary,
                            ),
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconWidget(
                              iconName: 'search',
                              color: theme.colorScheme.onPrimary,
                              size: 20,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              'Search Routes',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.onPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Check if search can be performed
  bool _canSearch() {
    return _selectedDestination != null && !_isSearching;
  }

  /// Handle use current location
  void _handleUseCurrentLocation() {
    HapticFeedback.lightImpact();
    setState(() {
      _currentLocation = "Dutse Junction, Abuja";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Using current location'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  /// Handle manual location input
  void _handleManualLocationInput(String value) {
    setState(() {
      _currentLocation = value.isNotEmpty ? value : "Dutse Junction, Abuja";
    });
  }

  /// Handle leave now toggle
  void _handleLeaveNowToggle(bool value) {
    HapticFeedback.lightImpact();
    setState(() {
      _isLeaveNow = value;
      if (value) {
        _selectedTime = null;
      }
    });
  }

  /// Handle time selection
  Future<void> _handleSelectTime() async {
    HapticFeedback.lightImpact();

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(data: Theme.of(context), child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _isLeaveNow = false;
      });
    }
  }

  /// Handle destination selection
  void _handleDestinationSelected(String destination) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDestination = destination;
    });
  }

  /// Handle toggle advanced options
  void _handleToggleAdvancedOptions() {
    HapticFeedback.lightImpact();
    setState(() {
      _isAdvancedOptionsExpanded = !_isAdvancedOptionsExpanded;
    });
  }

  /// Handle passenger count change
  void _handlePassengerCountChanged(int count) {
    HapticFeedback.lightImpact();
    setState(() {
      _passengerCount = count;
    });
  }

  /// Handle accessibility toggle
  void _handleAccessibilityToggle(bool value) {
    HapticFeedback.lightImpact();
    setState(() {
      _hasAccessibilityRequirements = value;
    });
  }

  /// Handle recent search selection
  void _handleRecentSearchSelected(Map<String, String> search) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedDestination = search["destination"];

      // Parse time if available
      final timeString = search["time"];
      if (timeString != null) {
        final timeParts = timeString.split(":");
        if (timeParts.length == 2) {
          final hour = int.tryParse(timeParts[0]);
          final minutePart = timeParts[1].split(" ");
          final minute = int.tryParse(minutePart[0]);

          if (hour != null && minute != null) {
            _selectedTime = TimeOfDay(hour: hour, minute: minute);
            _isLeaveNow = false;
          }
        }
      }
    });
  }

  /// Handle search action
  Future<void> _handleSearch() async {
    if (!_canSearch()) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _isSearching = true;
    });

    // Simulate route discovery
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSearching = false;
    });

    // Navigate to available routes screen
    Navigator.pushNamed(
      context,
      '/available-routes-screen',
      arguments: {
        'origin': _currentLocation,
        'destination': _selectedDestination,
        'departureTime': _isLeaveNow ? 'Now' : _selectedTime?.format(context),
        'passengerCount': _passengerCount,
        'hasAccessibilityRequirements': _hasAccessibilityRequirements,
      },
    );
  }
}