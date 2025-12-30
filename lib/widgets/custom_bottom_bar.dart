import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Navigation item configuration for the bottom bar
class CustomBottomBarItem {
  final String label;
  final IconData icon;
  final IconData? activeIcon;
  final String route;
  final int? badgeCount;

  const CustomBottomBarItem({
    required this.label,
    required this.icon,
    this.activeIcon,
    required this.route,
    this.badgeCount,
  });
}

/// Custom bottom navigation bar widget for ridesharing application
/// Implements role-aware navigation with badge notifications
/// Optimized for thumb-reach zones and one-handed operation
class CustomBottomBar extends StatelessWidget {
  /// Current selected index
  final int currentIndex;

  /// Callback when navigation item is tapped
  final Function(int) onTap;

  /// Badge count for bookings/requests tab (optional)
  /// Applied to index 1 if using default navigation items
  final int? badgeCount;

  /// User role to determine navigation items (rider/driver)
  /// This is the primary parameter - if provided, determines which nav items to show
  final UserRole? userRole;

  /// Alternative variant parameter (for backward compatibility)
  final CustomBottomBarVariant? variant;

  /// Custom navigation items (overrides role-based defaults)
  final List<CustomBottomBarItem>? customItems;

  /// Whether to automatically navigate when tapped (default: true for convenience)
  final bool autoNavigate;

  const CustomBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badgeCount,
    this.userRole,
    this.variant,
    this.customItems,
    this.autoNavigate = true, // Changed default to true for better DX
  });

  /// Factory constructor for rider role
  factory CustomBottomBar.rider({
    required int currentIndex,
    required Function(int) onTap,
    int? badgeCount,
    bool autoNavigate = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      badgeCount: badgeCount,
      userRole: UserRole.rider,
      autoNavigate: autoNavigate,
    );
  }

  /// Factory constructor for driver role
  factory CustomBottomBar.driver({
    required int currentIndex,
    required Function(int) onTap,
    int? badgeCount,
    bool autoNavigate = true,
  }) {
    return CustomBottomBar(
      currentIndex: currentIndex,
      onTap: onTap,
      badgeCount: badgeCount,
      userRole: UserRole.driver,
      autoNavigate: autoNavigate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final items = _getNavigationItems();

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.08),
            offset: const Offset(0, -2),
            blurRadius: 8,
            spreadRadius: 0,
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) => _buildNavigationItem(
                context: context,
                item: items[index],
                index: index,
                isSelected: currentIndex == index,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build individual navigation item
  Widget _buildNavigationItem({
    required BuildContext context,
    required CustomBottomBarItem item,
    required int index,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Check if this item should show a badge
    // Priority: item's own badge > widget-level badge for index 1
    final showBadge = item.badgeCount != null && item.badgeCount! > 0 ||
        (index == 1 && badgeCount != null && badgeCount! > 0);
    final effectiveBadgeCount = item.badgeCount ?? (index == 1 ? badgeCount : null);

    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Haptic feedback for touch confirmation
            HapticFeedback.lightImpact();
            onTap(index);

            // Auto-navigate if enabled and route is different
            if (autoNavigate && 
                ModalRoute.of(context)?.settings.name != item.route) {
              Navigator.pushNamed(context, item.route);
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      isSelected ? (item.activeIcon ?? item.icon) : item.icon,
                      size: 24,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                    if (showBadge && effectiveBadgeCount != null)
                      Positioned(
                        right: -8,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: colorScheme.error,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 16,
                            minHeight: 16,
                          ),
                          child: Text(
                            effectiveBadgeCount > 99 
                                ? '99+' 
                                : effectiveBadgeCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: colorScheme.onError,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              height: 1.0,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: 12,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Get navigation items based on user role or custom items
  List<CustomBottomBarItem> _getNavigationItems() {
    // If custom items are provided, use them
    if (customItems != null && customItems!.isNotEmpty) {
      return customItems!;
    }

    // Determine role from either userRole or variant parameter
    final effectiveRole = userRole ?? 
        (variant == CustomBottomBarVariant.driver 
            ? UserRole.driver 
            : UserRole.rider);

    // Return role-based navigation items
    if (effectiveRole == UserRole.driver) {
      return _getDriverNavigationItems();
    } else {
      return _getRiderNavigationItems();
    }
  }

  /// Get rider navigation items with updated routes
  List<CustomBottomBarItem> _getRiderNavigationItems() {
    return const [
      CustomBottomBarItem(
        label: 'Home',
        icon: Icons.home_outlined,
        activeIcon: Icons.home,
        route: '/rider-home-screen',
      ),
      CustomBottomBarItem(
        label: 'Bookings',
        icon: Icons.receipt_long_outlined,
        activeIcon: Icons.receipt_long,
        route: '/my-bookings-screen',
      ),
      CustomBottomBarItem(
        label: 'Wallet',
        icon: Icons.account_balance_wallet_outlined,
        activeIcon: Icons.account_balance_wallet,
        route: '/wallet-screen',
      ),
      CustomBottomBarItem(
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        route: '/profile-screen',
      ),
    ];
  }

  /// Get driver navigation items with updated routes
  List<CustomBottomBarItem> _getDriverNavigationItems() {
    return const [
      CustomBottomBarItem(
        label: 'Dashboard',
        icon: Icons.dashboard_outlined,
        activeIcon: Icons.dashboard,
        route: '/driver-home-screen',
      ),
      CustomBottomBarItem(
        label: 'Requests',
        icon: Icons.notifications_outlined,
        activeIcon: Icons.notifications,
        route: '/pending-booking-requests-screen',
      ),
      CustomBottomBarItem(
        label: 'Manifest',
        icon: Icons.qr_code_scanner_outlined,
        activeIcon: Icons.qr_code_scanner,
        route: '/manifest-screen',
      ),
      CustomBottomBarItem(
        label: 'Profile',
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        route: '/profile-screen',
      ),
    ];
  }
}

/// User role enum for role-based navigation
enum UserRole { 
  rider, 
  driver 
}

/// Variants for different user roles (backward compatibility)
enum CustomBottomBarVariant {
  /// Rider interface with booking and trip management
  rider,

  /// Driver interface with passenger management and route oversight
  driver,
}