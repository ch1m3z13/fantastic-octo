import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

/// Top-Up Bottom Sheet Widget - Handles wallet top-up flow
class TopUpBottomSheetWidget extends StatefulWidget {
  final String paymentMethod;
  final Function(double) onTopUpComplete;

  const TopUpBottomSheetWidget({
    super.key,
    required this.paymentMethod,
    required this.onTopUpComplete,
  });

  @override
  State<TopUpBottomSheetWidget> createState() => _TopUpBottomSheetWidgetState();
}

class _TopUpBottomSheetWidgetState extends State<TopUpBottomSheetWidget> {
  final TextEditingController _amountController = TextEditingController();
  final List<double> _presetAmounts = [1000, 2000, 5000, 10000];
  double? _selectedAmount;
  bool _isProcessing = false;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        padding: EdgeInsets.all(5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Top Up Wallet',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Payment Method Info
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Row(
                children: [
                  Icon(_getPaymentIcon(), color: theme.colorScheme.primary),
                  SizedBox(width: 3.w),
                  Text(
                    _getPaymentMethodName(),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 3.h),

            // Preset Amount Buttons
            Text(
              'Select Amount',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.5.h),
            Wrap(
              spacing: 2.w,
              runSpacing: 1.h,
              children: _presetAmounts.map((amount) {
                final isSelected = _selectedAmount == amount;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAmount = amount;
                      _amountController.text = amount.toStringAsFixed(0);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      '₦${amount.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 3.h),

            // Custom Amount Input
            Text(
              'Or Enter Custom Amount',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 1.5.h),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                prefixText: '₦ ',
                hintText: 'Enter amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide(
                    color: theme.colorScheme.primary,
                    width: 2,
                  ),
                ),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  setState(() {
                    _selectedAmount = double.tryParse(value);
                  });
                }
              },
            ),
            SizedBox(height: 3.h),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    _selectedAmount != null &&
                        _selectedAmount! > 0 &&
                        !_isProcessing
                    ? _processTopUp
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 0,
                ),
                child: _isProcessing
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Proceed to Payment',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  IconData _getPaymentIcon() {
    switch (widget.paymentMethod) {
      case 'bank':
        return Icons.account_balance;
      case 'card':
        return Icons.credit_card;
      case 'mobile':
        return Icons.phone_android;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentMethodName() {
    switch (widget.paymentMethod) {
      case 'bank':
        return 'Bank Transfer';
      case 'card':
        return 'Card Payment';
      case 'mobile':
        return 'Mobile Money';
      default:
        return 'Payment';
    }
  }

  Future<void> _processTopUp() async {
    if (_selectedAmount == null || _selectedAmount! <= 0) return;

    setState(() => _isProcessing = true);

    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 2));

    setState(() => _isProcessing = false);

    widget.onTopUpComplete(_selectedAmount!);
  }
}