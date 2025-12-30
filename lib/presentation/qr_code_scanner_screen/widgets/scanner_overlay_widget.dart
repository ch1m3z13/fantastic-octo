import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Scanner overlay widget with frame and scanning animation
/// Provides visual guidance for QR code positioning
class ScannerOverlayWidget extends StatefulWidget {
  final bool isScanning;

  const ScannerOverlayWidget({super.key, required this.isScanning});

  @override
  State<ScannerOverlayWidget> createState() => _ScannerOverlayWidgetState();
}

class _ScannerOverlayWidgetState extends State<ScannerOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scanAreaSize = 70.w;

    return Stack(
      children: [
        // Dark overlay with transparent center
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.5),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: scanAreaSize,
                  height: scanAreaSize,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Scanning frame with corners
        Center(
          child: Container(
            width: scanAreaSize,
            height: scanAreaSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: widget.isScanning
                    ? theme.colorScheme.primary
                    : Colors.white.withValues(alpha: 0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // Corner indicators
                _buildCorner(Alignment.topLeft, theme),
                _buildCorner(Alignment.topRight, theme),
                _buildCorner(Alignment.bottomLeft, theme),
                _buildCorner(Alignment.bottomRight, theme),

                // Scanning line animation
                if (widget.isScanning)
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value * (scanAreaSize - 4),
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                theme.colorScheme.primary,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Build corner indicator
  Widget _buildCorner(Alignment alignment, ThemeData theme) {
    final isTop = alignment.y < 0;
    final isLeft = alignment.x < 0;

    return Align(
      alignment: alignment,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          border: Border(
            top: isTop
                ? BorderSide(
                    color: widget.isScanning
                        ? theme.colorScheme.primary
                        : Colors.white,
                    width: 4,
                  )
                : BorderSide.none,
            bottom: !isTop
                ? BorderSide(
                    color: widget.isScanning
                        ? theme.colorScheme.primary
                        : Colors.white,
                    width: 4,
                  )
                : BorderSide.none,
            left: isLeft
                ? BorderSide(
                    color: widget.isScanning
                        ? theme.colorScheme.primary
                        : Colors.white,
                    width: 4,
                  )
                : BorderSide.none,
            right: !isLeft
                ? BorderSide(
                    color: widget.isScanning
                        ? theme.colorScheme.primary
                        : Colors.white,
                    width: 4,
                  )
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
