import 'package:flutter/material.dart';

class CustomIconWidget extends StatelessWidget {
  final String iconName;
  final Color? color;
  final double? size;

  const CustomIconWidget({
    super.key,
    required this.iconName,
    this.color,
    this.size,
  });

  IconData _getIconData(String name) {
    switch (name) {
      case 'directions_bus':
        return Icons.directions_bus;
      case 'person':
        return Icons.person;
      case 'lock':
        return Icons.lock;
      case 'email':
        return Icons.email;
      case 'phone':
        return Icons.phone;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Icon(
      _getIconData(iconName),
      color: color,
      size: size,
    );
  }
}