import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Driver-specific details form widget
class DriverDetailsWidget extends StatefulWidget {
  final TextEditingController vehicleMakeController;
  final TextEditingController vehicleModelController;
  final TextEditingController vehicleYearController;
  final TextEditingController vehiclePlateController;
  final TextEditingController licenseNumberController;
  final String? selectedRoute;
  final Function(String?) onRouteChanged;

  const DriverDetailsWidget({
    super.key,
    required this.vehicleMakeController,
    required this.vehicleModelController,
    required this.vehicleYearController,
    required this.vehiclePlateController,
    required this.licenseNumberController,
    required this.selectedRoute,
    required this.onRouteChanged,
  });

  @override
  State<DriverDetailsWidget> createState() => _DriverDetailsWidgetState();
}

class _DriverDetailsWidgetState extends State<DriverDetailsWidget> {
  final List<String> _routes = [
    'Dutse - Jabi',
    'Dutse - Wuse',
    'Dutse - Maitama',
    'Dutse - Central Area',
  ];

  String? _validateVehicleMake(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter vehicle make';
    }
    return null;
  }

  String? _validateVehicleModel(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter vehicle model';
    }
    return null;
  }

  String? _validateVehicleYear(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter vehicle year';
    }
    final year = int.tryParse(value);
    if (year == null || year < 2000 || year > 2026) {
      return 'Please enter a valid year (2000-2026)';
    }
    return null;
  }

  String? _validateVehiclePlate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter vehicle plate number';
    }
    if (value.length < 6) {
      return 'Please enter a valid plate number';
    }
    return null;
  }

  String? _validateLicenseNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter license number';
    }
    if (value.length < 8) {
      return 'Please enter a valid license number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedSize(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 24),

          // Section Header
          Text(
            'Vehicle Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16),

          // Vehicle Make
          TextFormField(
            controller: widget.vehicleMakeController,
            decoration: InputDecoration(
              labelText: 'Vehicle Make',
              hintText: 'e.g., Toyota, Honda',
              prefixIcon: Icon(
                Icons.directions_car_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: _validateVehicleMake,
          ),
          SizedBox(height: 16),

          // Vehicle Model
          TextFormField(
            controller: widget.vehicleModelController,
            decoration: InputDecoration(
              labelText: 'Vehicle Model',
              hintText: 'e.g., Camry, Accord',
              prefixIcon: Icon(
                Icons.car_rental_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.words,
            validator: _validateVehicleModel,
          ),
          SizedBox(height: 16),

          // Vehicle Year
          TextFormField(
            controller: widget.vehicleYearController,
            decoration: InputDecoration(
              labelText: 'Vehicle Year',
              hintText: 'e.g., 2020',
              prefixIcon: Icon(
                Icons.calendar_today_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
            validator: _validateVehicleYear,
          ),
          SizedBox(height: 16),

          // Vehicle Plate Number
          TextFormField(
            controller: widget.vehiclePlateController,
            decoration: InputDecoration(
              labelText: 'Plate Number',
              hintText: 'e.g., ABC-123-XY',
              prefixIcon: Icon(
                Icons.pin_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            validator: _validateVehiclePlate,
          ),
          SizedBox(height: 24),

          // License Section Header
          Text(
            'License Information',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16),

          // License Number
          TextFormField(
            controller: widget.licenseNumberController,
            decoration: InputDecoration(
              labelText: 'Driver License Number',
              hintText: 'Enter your license number',
              prefixIcon: Icon(
                Icons.badge_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            textCapitalization: TextCapitalization.characters,
            validator: _validateLicenseNumber,
          ),
          SizedBox(height: 24),

          // Route Preference Section Header
          Text(
            'Route Preference',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 16),

          // Route Dropdown
          DropdownButtonFormField<String>(
            initialValue: widget.selectedRoute,
            decoration: InputDecoration(
              labelText: 'Preferred Route',
              hintText: 'Select your primary route',
              prefixIcon: Icon(
                Icons.route_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            items: _routes.map((route) {
              return DropdownMenuItem<String>(value: route, child: Text(route));
            }).toList(),
            onChanged: widget.onRouteChanged,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a route';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
