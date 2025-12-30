import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Bottom sheet for filtering available routes
/// Provides options for departure time, price range, driver rating, and vehicle type
class RouteFilterBottomSheet extends StatefulWidget {
  final Function(Map<String, dynamic>) onApplyFilters;
  final Map<String, dynamic>? currentFilters;

  const RouteFilterBottomSheet({
    super.key,
    required this.onApplyFilters,
    this.currentFilters,
  });

  @override
  State<RouteFilterBottomSheet> createState() => _RouteFilterBottomSheetState();
}

class _RouteFilterBottomSheetState extends State<RouteFilterBottomSheet> {
  late RangeValues _priceRange;
  late RangeValues _timeRange;
  late double _minRating;
  late Set<String> _selectedVehicleTypes;

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.currentFilters?['minPrice'] ?? 500.0,
      widget.currentFilters?['maxPrice'] ?? 2000.0,
    );
    _timeRange = RangeValues(
      widget.currentFilters?['minTime'] ?? 6.0,
      widget.currentFilters?['maxTime'] ?? 20.0,
    );
    _minRating = widget.currentFilters?['minRating'] ?? 3.0;
    _selectedVehicleTypes = Set<String>.from(
      widget.currentFilters?['vehicleTypes'] ?? ['Sedan', 'SUV', 'Minivan'],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(theme),
              SizedBox(height: 3.h),
              _buildPriceRangeSection(theme),
              SizedBox(height: 3.h),
              _buildTimeRangeSection(theme),
              SizedBox(height: 3.h),
              _buildRatingSection(theme),
              SizedBox(height: 3.h),
              _buildVehicleTypeSection(theme),
              SizedBox(height: 3.h),
              _buildActionButtons(theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Filter Routes',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'close',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '₦${_priceRange.start.toInt()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '₦${_priceRange.end.toInt()}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _priceRange,
          min: 500,
          max: 2000,
          divisions: 15,
          labels: RangeLabels(
            '₦${_priceRange.start.toInt()}',
            '₦${_priceRange.end.toInt()}',
          ),
          onChanged: (values) {
            setState(() => _priceRange = values);
          },
        ),
      ],
    );
  }

  Widget _buildTimeRangeSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Departure Time',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_timeRange.start.toInt()}:00',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_timeRange.end.toInt()}:00',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        RangeSlider(
          values: _timeRange,
          min: 6,
          max: 20,
          divisions: 14,
          labels: RangeLabels(
            '${_timeRange.start.toInt()}:00',
            '${_timeRange.end.toInt()}:00',
          ),
          onChanged: (values) {
            setState(() => _timeRange = values);
          },
        ),
      ],
    );
  }

  Widget _buildRatingSection(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Minimum Driver Rating',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _minRating,
                min: 1,
                max: 5,
                divisions: 8,
                label: _minRating.toStringAsFixed(1),
                onChanged: (value) {
                  setState(() => _minRating = value);
                },
              ),
            ),
            SizedBox(width: 2.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'star',
                    color: const Color(0xFFFFA000),
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    _minRating.toStringAsFixed(1),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleTypeSection(ThemeData theme) {
    final vehicleTypes = ['Sedan', 'SUV', 'Minivan', 'Hatchback'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 1.h),
        Wrap(
          spacing: 2.w,
          runSpacing: 1.h,
          children: vehicleTypes.map((type) {
            final isSelected = _selectedVehicleTypes.contains(type);
            return FilterChip(
              label: Text(type),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selected
                      ? _selectedVehicleTypes.add(type)
                      : _selectedVehicleTypes.remove(type);
                });
              },
              backgroundColor: theme.colorScheme.surface,
              selectedColor: theme.colorScheme.primary.withValues(alpha: 0.2),
              checkmarkColor: theme.colorScheme.primary,
              labelStyle: theme.textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.outline,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _priceRange = const RangeValues(500, 2000);
                _timeRange = const RangeValues(6, 20);
                _minRating = 3.0;
                _selectedVehicleTypes = {'Sedan', 'SUV', 'Minivan'};
              });
            },
            child: const Text('Reset'),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              widget.onApplyFilters({
                'minPrice': _priceRange.start,
                'maxPrice': _priceRange.end,
                'minTime': _timeRange.start,
                'maxTime': _timeRange.end,
                'minRating': _minRating,
                'vehicleTypes': _selectedVehicleTypes.toList(),
              });
              Navigator.pop(context);
            },
            child: const Text('Apply Filters'),
          ),
        ),
      ],
    );
  }
}
