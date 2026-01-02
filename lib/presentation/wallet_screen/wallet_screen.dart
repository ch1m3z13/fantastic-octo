import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_bottom_bar.dart';
import './widgets/balance_card_widget.dart';
import './widgets/quick_action_button_widget.dart';
import './widgets/transaction_item_widget.dart';
import './widgets/top_up_bottom_sheet_widget.dart';

/// Wallet Screen - Comprehensive financial management for Abuja Commuter
/// Features: Balance tracking, transaction history, top-up functionality
class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _currentBottomNavIndex = 2; // Wallet tab active
  bool _isRefreshing = false;
  String _selectedFilter = 'All';
  final List<String> _filterOptions = ['All', 'Rides', 'Top-ups', 'Refunds'];

  // Mock wallet balance
  double _currentBalance = 15750.50;
  final double _lowBalanceThreshold = 5000.0;

  // Mock transaction history
  final List<Map<String, dynamic>> _transactions = [
    {
      "id": "TXN001",
      "type": "debit",
      "category": "ride",
      "description": "Ride from Dutse to Jabi",
      "amount": 1500.0,
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "completed",
      "receiptId": "RCP_001",
    },
    {
      "id": "TXN002",
      "type": "credit",
      "category": "top-up",
      "description": "Bank Transfer Top-up",
      "amount": 10000.0,
      "timestamp": DateTime.now().subtract(const Duration(hours: 5)),
      "status": "completed",
      "receiptId": "RCP_002",
    },
    {
      "id": "TXN003",
      "type": "debit",
      "category": "ride",
      "description": "Ride from Dutse to Wuse",
      "amount": 1200.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "status": "completed",
      "receiptId": "RCP_003",
    },
    {
      "id": "TXN004",
      "type": "credit",
      "category": "refund",
      "description": "Ride Cancellation Refund",
      "amount": 1500.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "status": "completed",
      "receiptId": "RCP_004",
    },
    {
      "id": "TXN005",
      "type": "debit",
      "category": "ride",
      "description": "Ride from Dutse to Maitama",
      "amount": 1800.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 3)),
      "status": "completed",
      "receiptId": "RCP_005",
    },
    {
      "id": "TXN006",
      "type": "credit",
      "category": "top-up",
      "description": "Card Payment Top-up",
      "amount": 5000.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 5)),
      "status": "completed",
      "receiptId": "RCP_006",
    },
    {
      "id": "TXN007",
      "type": "debit",
      "category": "ride",
      "description": "Ride from Dutse to Central Area",
      "amount": 2000.0,
      "timestamp": DateTime.now().subtract(const Duration(days: 7)),
      "status": "completed",
      "receiptId": "RCP_007",
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filteredTransactions = _getFilteredTransactions();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(title: 'Wallet', centerTitle: true),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          slivers: [
            // Balance Card Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(4.w),
                child: BalanceCardWidget(
                  balance: _currentBalance,
                  isLowBalance: _currentBalance < _lowBalanceThreshold,
                  onTapCard: () => _showBalanceDetails(),
                ),
              ),
            ),

            // Quick Actions Section
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        QuickActionButtonWidget(
                          icon: Icons.account_balance,
                          label: 'Bank Transfer',
                          onTap: () => _showTopUpBottomSheet('bank'),
                        ),
                        QuickActionButtonWidget(
                          icon: Icons.credit_card,
                          label: 'Card Payment',
                          onTap: () => _showTopUpBottomSheet('card'),
                        ),
                        QuickActionButtonWidget(
                          icon: Icons.phone_android,
                          label: 'Mobile Money',
                          onTap: () => _showTopUpBottomSheet('mobile'),
                        ),
                      ],
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            ),

            // Transaction History Header with Filters
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Transaction History',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: _showFilterOptions,
                          icon: Icon(
                            Icons.filter_list,
                            size: 18,
                            color: theme.colorScheme.primary,
                          ),
                          label: Text(
                            _selectedFilter,
                            style: TextStyle(
                              color: theme.colorScheme.primary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                  ],
                ),
              ),
            ),

            // Transaction List
            filteredTransactions.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.receipt_long_outlined,
                            size: 64,
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.3,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'No transactions found',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            'Your transaction history will appear here',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final transaction = filteredTransactions[index];
                        return TransactionItemWidget(
                          transaction: transaction,
                          onTap: () => _showTransactionDetails(transaction),
                        );
                      }, childCount: filteredTransactions.length),
                    ),
                  ),

            // Bottom padding
            SliverToBoxAdapter(child: SizedBox(height: 10.h)),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: (index) {
          if (index != _currentBottomNavIndex) {
            setState(() => _currentBottomNavIndex = index);
            final items = _getNavigationItems();
            Navigator.pushReplacementNamed(context, items[index]['route']!);
          }
        },
        userRole: UserRole.rider,
      ),
    );
  }

  /// Get navigation items for rider
  List<Map<String, String>> _getNavigationItems() {
    return [
      {'route': '/splash-screen'},
      {'route': '/my-bookings-screen'},
      {'route': '/wallet-screen'},
      {'route': '/splash-screen'},
    ];
  }

  /// Handle pull-to-refresh
  Future<void> _handleRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Balance and transactions updated'),
          duration: const Duration(seconds: 2),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
    }
  }

  /// Get filtered transactions based on selected filter
  List<Map<String, dynamic>> _getFilteredTransactions() {
    if (_selectedFilter == 'All') {
      return _transactions;
    }

    final filterMap = {
      'Rides': 'ride',
      'Top-ups': 'top-up',
      'Refunds': 'refund',
    };

    final categoryFilter = filterMap[_selectedFilter];
    return _transactions
        .where((txn) => txn['category'] == categoryFilter)
        .toList();
  }

  /// Show filter options
  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(4.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Transactions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 2.h),
              ..._filterOptions.map((filter) {
                return ListTile(
                  leading: Icon(
                    _selectedFilter == filter
                        ? Icons.radio_button_checked
                        : Icons.radio_button_unchecked,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  title: Text(filter),
                  onTap: () {
                    setState(() => _selectedFilter = filter);
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: 2.h),
            ],
          ),
        );
      },
    );
  }

  /// Show balance details
  void _showBalanceDetails() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Balance Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                'Available Balance',
                '₦${NumberFormat('#,##0.00').format(_currentBalance)}',
                theme,
              ),
              SizedBox(height: 1.h),
              _buildDetailRow('Total Spent (This Month)', '₦6,500.00', theme),
              SizedBox(height: 1.h),
              _buildDetailRow(
                'Total Top-ups (This Month)',
                '₦15,000.00',
                theme,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  /// Show top-up bottom sheet
  void _showTopUpBottomSheet(String paymentMethod) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return TopUpBottomSheetWidget(
          paymentMethod: paymentMethod,
          onTopUpComplete: (amount) {
            setState(() {
              _currentBalance += amount;
              _transactions.insert(0, {
                "id": "TXN${_transactions.length + 1}",
                "type": "credit",
                "category": "top-up",
                "description": "${_getPaymentMethodName(paymentMethod)} Top-up",
                "amount": amount,
                "timestamp": DateTime.now(),
                "status": "completed",
                "receiptId": "RCP_${_transactions.length + 1}",
              });
            });
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Top-up successful! ₦${NumberFormat('#,##0.00').format(amount)} added',
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
            );
          },
        );
      },
    );
  }

  String _getPaymentMethodName(String method) {
    switch (method) {
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

  /// Show transaction details
  void _showTransactionDetails(Map<String, dynamic> transaction) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Transaction Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Transaction ID', transaction['id'], theme),
              SizedBox(height: 1.h),
              _buildDetailRow('Description', transaction['description'], theme),
              SizedBox(height: 1.h),
              _buildDetailRow(
                'Amount',
                '₦${NumberFormat('#,##0.00').format(transaction['amount'])}',
                theme,
              ),
              SizedBox(height: 1.h),
              _buildDetailRow(
                'Date',
                DateFormat(
                  'MMM dd, yyyy - hh:mm a',
                ).format(transaction['timestamp']),
                theme,
              ),
              SizedBox(height: 1.h),
              _buildDetailRow(
                'Status',
                transaction['status'].toString().toUpperCase(),
                theme,
              ),
              SizedBox(height: 1.h),
              _buildDetailRow('Receipt ID', transaction['receiptId'], theme),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}