import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Manual entry widget for backup passenger verification
/// Allows drivers to enter booking reference number manually
class ManualEntryWidget extends StatefulWidget {
  final Function(String) onSubmit;
  final VoidCallback onCancel;

  const ManualEntryWidget({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  State<ManualEntryWidget> createState() => _ManualEntryWidgetState();
}

class _ManualEntryWidgetState extends State<ManualEntryWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Auto-focus on text field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    final bookingRef = _controller.text.trim().toUpperCase();
    widget.onSubmit(bookingRef);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: Container(
          width: 85.w,
          constraints: BoxConstraints(maxHeight: 40.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'keyboard',
                        color: theme.colorScheme.primary,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Manual Entry',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onCancel,
                        icon: CustomIconWidget(
                          iconName: 'close',
                          color: theme.colorScheme.onSurface,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Instruction text
                  Text(
                    'Enter the booking reference number shown on the passenger\'s booking confirmation.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Booking reference input
                  TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      labelText: 'Booking Reference',
                      hintText: 'e.g., BK001',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: CustomIconWidget(
                          iconName: 'confirmation_number',
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => _handleSubmit(),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: widget.onCancel,
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _handleSubmit,
                          child: const Text('Verify'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
