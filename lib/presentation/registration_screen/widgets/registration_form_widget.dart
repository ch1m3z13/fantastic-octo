import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Registration form widget containing all input fields
class RegistrationFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isDriver;
  final Function(bool) onDriverToggle;

  const RegistrationFormWidget({
    super.key,
    required this.formKey,
    required this.fullNameController,
    required this.phoneController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isDriver,
    required this.onDriverToggle,
  });

  @override
  State<RegistrationFormWidget> createState() => _RegistrationFormWidgetState();
}

class _RegistrationFormWidgetState extends State<RegistrationFormWidget> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your full name';
    }
    if (value.length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    final phoneRegex = RegExp(r'^\+234[0-9]{10}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Invalid Nigerian phone number format (+234XXXXXXXXXX)';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    if (value.length < 4) {
      return 'Username must be at least 4 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
      return 'Username can only contain letters, numbers, and underscores';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != widget.passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          TextFormField(
            controller: widget.fullNameController,
            decoration: InputDecoration(
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icon(
                Icons.person_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            validator: _validateFullName,
          ),
          SizedBox(height: 16),

          // Phone Number Field
          TextFormField(
            controller: widget.phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              hintText: '+234XXXXXXXXXX',
              prefixIcon: Icon(
                Icons.phone_outlined,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[\d+]')),
              LengthLimitingTextInputFormatter(14),
            ],
            validator: _validatePhone,
          ),
          SizedBox(height: 16),

          // Username Field
          TextFormField(
            controller: widget.usernameController,
            decoration: InputDecoration(
              labelText: 'Username',
              hintText: 'Choose a username',
              prefixIcon: Icon(
                Icons.alternate_email,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9_]')),
            ],
            validator: _validateUsername,
          ),
          SizedBox(height: 16),

          // Password Field
          TextFormField(
            controller: widget.passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              hintText: 'Create a strong password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.next,
            obscureText: _obscurePassword,
            validator: _validatePassword,
          ),
          SizedBox(height: 16),

          // Confirm Password Field
          TextFormField(
            controller: widget.confirmPasswordController,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              hintText: 'Re-enter your password',
              prefixIcon: Icon(
                Icons.lock_outline,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            textInputAction: TextInputAction.done,
            obscureText: _obscureConfirmPassword,
            validator: _validateConfirmPassword,
          ),
          SizedBox(height: 24),

          // Driver Toggle
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outline, width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Register as Driver',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Enable if you want to offer rides',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: widget.isDriver,
                  onChanged: (value) {
                    HapticFeedback.lightImpact();
                    widget.onDriverToggle(value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
