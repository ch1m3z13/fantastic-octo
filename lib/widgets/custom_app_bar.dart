import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The Custom App Bar Widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Primary title text
  final String? title;

  /// Optional subtitle (only used in 'withSubtitle' variant)
  final String? subtitle;

  /// Custom widget to replace the standard title text
  final Widget? titleWidget;

  /// Actions to display on the right
  final List<Widget>? actions;

  /// Custom leading widget
  final Widget? leading;

  /// Whether to show the back button automatically
  final bool automaticallyImplyLeading;

  /// Whether to center the title
  final bool centerTitle;

  /// Elevation (shadow depth)
  final double elevation;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom icon/text color
  final Color? foregroundColor;

  /// The visual style of the app bar
  final AppBarVariant variant;

  /// Custom callback for back button (overrides default pop)
  final VoidCallback? onBackPressed;

  /// Bottom widget (e.g. TabBar)
  final PreferredSizeWidget? bottom;

  /// Notification count for the badge
  final int? notificationBadgeCount;

  /// Callback for search action (used with search variant)
  final VoidCallback? onSearchPressed;

  /// Callback for settings action (used with profile variant)
  final VoidCallback? onSettingsPressed;

  /// Callback for notifications action (used with notifications variant)
  final VoidCallback? onNotificationsPressed;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.titleWidget,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.centerTitle = false,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.variant = AppBarVariant.standard,
    this.onBackPressed,
    this.bottom,
    this.notificationBadgeCount,
    this.onSearchPressed,
    this.onSettingsPressed,
    this.onNotificationsPressed,
  });

  // Factory Constructors
  
  /// Standard App Bar Factory
  factory CustomAppBar.standard({
    required String title,
    bool centerTitle = false,
    List<Widget>? actions,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      centerTitle: centerTitle,
      actions: actions,
      onBackPressed: onBackPressed,
      variant: AppBarVariant.standard,
    );
  }

  /// Large Header Factory
  factory CustomAppBar.large({
    required String title,
    List<Widget>? actions,
    int? notificationBadgeCount,
  }) {
    return CustomAppBar(
      title: title,
      actions: actions,
      automaticallyImplyLeading: false,
      variant: AppBarVariant.large,
      notificationBadgeCount: notificationBadgeCount,
    );
  }

  /// Transparent Overlay Factory
  factory CustomAppBar.transparent({
    String? title,
    VoidCallback? onBackPressed,
    List<Widget>? actions,
  }) {
    return CustomAppBar(
      title: title,
      onBackPressed: onBackPressed,
      actions: actions,
      variant: AppBarVariant.transparent,
      elevation: 0,
    );
  }

  /// Primary colored app bar (default)
  factory CustomAppBar.primary({
    required String title,
    String? subtitle,
    List<Widget>? actions,
    int? notificationBadgeCount,
    bool centerTitle = false,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      actions: actions,
      variant: AppBarVariant.primary,
      notificationBadgeCount: notificationBadgeCount,
      centerTitle: centerTitle,
    );
  }

  /// Minimal app bar without actions
  factory CustomAppBar.minimal({
    required String title,
    String? subtitle,
    bool centerTitle = false,
    VoidCallback? onBackPressed,
  }) {
    return CustomAppBar(
      title: title,
      subtitle: subtitle,
      variant: AppBarVariant.minimal,
      centerTitle: centerTitle,
      onBackPressed: onBackPressed,
    );
  }

  /// Search variant with search icon
  factory CustomAppBar.search({
    required String title,
    VoidCallback? onSearchPressed,
    VoidCallback? onBackPressed,
    bool centerTitle = false,
  }) {
    return CustomAppBar(
      title: title,
      variant: AppBarVariant.search,
      onSearchPressed: onSearchPressed,
      onBackPressed: onBackPressed,
      centerTitle: centerTitle,
    );
  }

  /// Profile variant with settings icon
  factory CustomAppBar.profile({
    required String title,
    VoidCallback? onSettingsPressed,
    VoidCallback? onBackPressed,
    bool centerTitle = false,
  }) {
    return CustomAppBar(
      title: title,
      variant: AppBarVariant.profile,
      onSettingsPressed: onSettingsPressed,
      onBackPressed: onBackPressed,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0.0));

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine colors based on variant
    final isTransparent = variant == AppBarVariant.transparent;
    final effectiveBgColor = isTransparent
        ? Colors.transparent
        : (backgroundColor ?? colorScheme.surface);
    final effectiveFgColor = isTransparent
        ? Colors.white
        : (foregroundColor ?? colorScheme.onSurface);

    return AppBar(
      title: titleWidget ?? _buildTitle(context, effectiveFgColor),
      leading: _buildLeading(context, effectiveFgColor),
      actions: _buildActions(context, effectiveFgColor),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: isTransparent ? 0 : elevation,
      backgroundColor: effectiveBgColor,
      foregroundColor: effectiveFgColor,
      bottom: bottom,
      surfaceTintColor: Colors.transparent,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            theme.brightness == Brightness.light && !isTransparent
                ? Brightness.dark
                : Brightness.light,
      ),
    );
  }

  Widget? _buildTitle(BuildContext context, Color fgColor) {
    if (title == null) return null;
    final theme = Theme.of(context);

    switch (variant) {
      case AppBarVariant.large:
        return Text(
          title!,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: fgColor,
          ),
        );
      case AppBarVariant.withSubtitle:
      case AppBarVariant.primary:
      case AppBarVariant.surface:
        if (subtitle != null) {
          return Column(
            crossAxisAlignment: centerTitle
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title!,
                style: theme.appBarTheme.titleTextStyle?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: fgColor.withOpacity(0.7),
                ),
              ),
            ],
          );
        }
        return Text(
          title!,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: fgColor,
          ),
        );
      default:
        return Text(
          title!,
          style: theme.appBarTheme.titleTextStyle?.copyWith(
            color: fgColor,
          ),
        );
    }
  }

  Widget? _buildLeading(BuildContext context, Color fgColor) {
    if (leading != null) return leading;
    if (!automaticallyImplyLeading) return null;

    final canPop = Navigator.of(context).canPop();
    if (!canPop) return null;

    return IconButton(
      icon: Icon(Icons.arrow_back, color: fgColor),
      onPressed: () {
        HapticFeedback.lightImpact();
        if (onBackPressed != null) {
          onBackPressed!();
        } else {
          Navigator.of(context).pop();
        }
      },
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  List<Widget>? _buildActions(BuildContext context, Color fgColor) {
    // If actions are provided explicitly, return them
    if (actions != null && actions!.isNotEmpty) return actions;

    // Build variant-specific default actions
    return _buildVariantActions(context, fgColor);
  }

  List<Widget>? _buildVariantActions(BuildContext context, Color fgColor) {
    final theme = Theme.of(context);

    switch (variant) {
      case AppBarVariant.search:
        return [
          IconButton(
            icon: Icon(Icons.search, color: fgColor),
            onPressed: () {
              HapticFeedback.lightImpact();
              onSearchPressed?.call();
            },
            tooltip: 'Search',
          ),
          const SizedBox(width: 8),
        ];

      case AppBarVariant.profile:
        return [
          IconButton(
            icon: Icon(Icons.settings_outlined, color: fgColor),
            onPressed: () {
              HapticFeedback.lightImpact();
              onSettingsPressed?.call();
            },
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ];

      case AppBarVariant.notifications:
        return [
          _buildNotificationButton(context, fgColor),
          const SizedBox(width: 8),
        ];

      case AppBarVariant.minimal:
        return null;

      default:
        // For standard, primary, surface, etc. - show notification if badge count is set
        if (notificationBadgeCount != null) {
          return [
            _buildNotificationButton(context, fgColor),
            const SizedBox(width: 8),
          ];
        }
        return null;
    }
  }

  Widget _buildNotificationButton(BuildContext context, Color fgColor) {
    final hasNotifications = notificationBadgeCount != null && notificationBadgeCount! > 0;
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          icon: Icon(
            hasNotifications
                ? Icons.notifications_active
                : Icons.notifications_outlined,
            color: fgColor,
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            onNotificationsPressed?.call();
          },
          tooltip: 'Notifications',
        ),
        if (hasNotifications)
          Positioned(
            right: 8,
            top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: theme.colorScheme.error,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
              child: Text(
                notificationBadgeCount! > 99 ? '99+' : notificationBadgeCount.toString(),
                style: TextStyle(
                  color: theme.colorScheme.onError,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }
}

/// App Bar Variants - Unified enum for all app bar styles
enum AppBarVariant {
  /// Standard app bar with default styling
  standard,
  
  /// App bar with subtitle support
  withSubtitle,
  
  /// Large header app bar
  large,
  
  /// Transparent app bar for overlays
  transparent,
  
  /// App bar with notification badge
  notifications,
  
  /// Primary colored app bar
  primary,
  
  /// Minimal app bar without default actions
  minimal,
  
  /// Surface colored app bar
  surface,

  /// App bar with search functionality
  search,

  /// App bar for profile/settings screens
  profile,
}

// Custom Search AppBar
class CustomSearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String hintText;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final TextEditingController? controller;
  final bool autofocus;

  const CustomSearchAppBar({
    super.key,
    this.hintText = 'Search destinations...',
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.controller,
    this.autofocus = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomSearchAppBar> createState() => _CustomSearchAppBarState();
}

class _CustomSearchAppBarState extends State<CustomSearchAppBar> {
  late TextEditingController _controller;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _controller.text.isNotEmpty;
    });
    widget.onSearchChanged?.call(_controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      elevation: 2.0,
      backgroundColor: theme.colorScheme.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          HapticFeedback.lightImpact();
          Navigator.of(context).pop();
        },
      ),
      title: TextField(
        controller: _controller,
        autofocus: widget.autofocus,
        decoration: InputDecoration(
          hintText: widget.hintText,
          border: InputBorder.none,
          hintStyle: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
        style: theme.textTheme.titleMedium,
        onSubmitted: (_) => widget.onSearchSubmitted?.call(),
      ),
      actions: [
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              HapticFeedback.lightImpact();
              _controller.clear();
              widget.onSearchChanged?.call('');
            },
          ),
      ],
    );
  }
}

/// Custom sliver app bar for scrollable screens
class CustomSliverAppBar extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool floating;
  final bool pinned;
  final bool snap;
  final double? expandedHeight;
  final Widget? flexibleSpace;
  final List<Widget>? actions;
  final Color? backgroundColor;
  final int? notificationBadgeCount;

  const CustomSliverAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.floating = false,
    this.pinned = true,
    this.snap = false,
    this.expandedHeight,
    this.flexibleSpace,
    this.actions,
    this.backgroundColor,
    this.notificationBadgeCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;

    return SliverAppBar(
      backgroundColor: backgroundColor ?? appBarTheme.backgroundColor,
      foregroundColor: appBarTheme.foregroundColor,
      elevation: appBarTheme.elevation,
      floating: floating,
      pinned: pinned,
      snap: snap,
      expandedHeight: expandedHeight,
      flexibleSpace: flexibleSpace,
      title: subtitle != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title, style: appBarTheme.titleTextStyle),
                const SizedBox(height: 2),
                Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: appBarTheme.foregroundColor?.withOpacity(0.7),
                  ),
                ),
              ],
            )
          : Text(title, style: appBarTheme.titleTextStyle),
      actions: actions ?? _buildDefaultActions(context),
    );
  }

  List<Widget>? _buildDefaultActions(BuildContext context) {
    final theme = Theme.of(context);
    final showBadge = notificationBadgeCount != null && notificationBadgeCount! > 0;

    return [
      Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              HapticFeedback.lightImpact();
            },
            tooltip: 'Notifications',
          ),
          if (showBadge)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.error,
                  shape: BoxShape.circle,
                ),
                constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                child: Text(
                  notificationBadgeCount! > 99 ? '99+' : notificationBadgeCount.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onError,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
      const SizedBox(width: 8),
    ];
  }
}