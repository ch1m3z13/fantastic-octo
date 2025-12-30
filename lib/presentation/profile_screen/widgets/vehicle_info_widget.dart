import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Vehicle information widget for drivers
class VehicleInfoWidget extends StatelessWidget {
  final Map<String, dynamic> vehicleData;

  const VehicleInfoWidget({super.key, required this.vehicleData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final insuranceExpiry =
        vehicleData['insuranceExpiry'] as DateTime? ?? DateTime.now();
    final inspectionExpiry =
        vehicleData['inspectionExpiry'] as DateTime? ?? DateTime.now();
    final daysUntilInsuranceExpiry = insuranceExpiry
        .difference(DateTime.now())
        .inDays;
    final daysUntilInspectionExpiry = inspectionExpiry
        .difference(DateTime.now())
        .inDays;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'directions_car',
                color: theme.colorScheme.primary,
                size: 24,
              ),
              SizedBox(width: 2.w),
              Text(
                'Vehicle Information',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          _buildVehicleDetail(
            context,
            label: 'Make & Model',
            value: '${vehicleData['make']} ${vehicleData['model']}',
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              Expanded(
                child: _buildVehicleDetail(
                  context,
                  label: 'Year',
                  value: vehicleData['year'].toString(),
                ),
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: _buildVehicleDetail(
                  context,
                  label: 'Color',
                  value: vehicleData['color'] as String? ?? 'N/A',
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          _buildVehicleDetail(
            context,
            label: 'License Plate',
            value: vehicleData['licensePlate'] as String? ?? 'N/A',
          ),
          SizedBox(height: 2.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: daysUntilInsuranceExpiry < 30
                  ? const Color(0xFFFF6B35).withValues(alpha: 0.1)
                  : theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'shield',
                  color: daysUntilInsuranceExpiry < 30
                      ? const Color(0xFFFF6B35)
                      : theme.colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Insurance',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.25.h),
                      Text(
                        daysUntilInsuranceExpiry < 30
                            ? 'Expires in $daysUntilInsuranceExpiry days'
                            : 'Valid until ${insuranceExpiry.day}/${insuranceExpiry.month}/${insuranceExpiry.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: daysUntilInsuranceExpiry < 30
                              ? const Color(0xFFFF6B35)
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: daysUntilInspectionExpiry < 30
                  ? const Color(0xFFFF6B35).withValues(alpha: 0.1)
                  : theme.colorScheme.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                CustomIconWidget(
                  iconName: 'verified_user',
                  color: daysUntilInspectionExpiry < 30
                      ? const Color(0xFFFF6B35)
                      : theme.colorScheme.secondary,
                  size: 20,
                ),
                SizedBox(width: 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inspection',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.6,
                          ),
                        ),
                      ),
                      SizedBox(height: 0.25.h),
                      Text(
                        daysUntilInspectionExpiry < 30
                            ? 'Expires in $daysUntilInspectionExpiry days'
                            : 'Valid until ${inspectionExpiry.day}/${inspectionExpiry.month}/${inspectionExpiry.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: daysUntilInspectionExpiry < 30
                              ? const Color(0xFFFF6B35)
                              : theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleDetail(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: 0.25.h),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
