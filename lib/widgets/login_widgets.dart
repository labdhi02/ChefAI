import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ThemeColors {
  static const Color primary = Color(0xFFFF8F00);
  static const Color primaryDark = Color(0xFFFF6F00);
  static const Color secondary = Color(0xFF795548);
  static const Color dividerColor = Color(0xFFBDBDBD);
  static const Color borderColor = Color(0xFFE0E0E0);
}

class LoginWidgets {
  static Widget buildHeader() {
    return Column(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.restaurant_rounded,
              size: 60,
              color: ThemeColors.primary,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Chef AI',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: ThemeColors.primaryDark,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Your Personal Recipe Generator',
          style: TextStyle(
            fontSize: 16,
            color: ThemeColors.secondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  static InputDecoration inputDecoration({
    required String labelText,
    required IconData prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(color: ThemeColors.secondary),
      prefixIcon: Icon(prefixIcon, color: ThemeColors.primary),
      suffixIcon: suffixIcon,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: ThemeColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      errorStyle: TextStyle(color: Colors.red.shade700),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
    );
  }

  static Widget buildDivider() {
    return Row(
      children: const [
        Expanded(
          child: Divider(
            color: ThemeColors.dividerColor,
            thickness: 1,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'OR',
            style: TextStyle(
              color: ThemeColors.secondary,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Expanded(
          child: Divider(
            color: ThemeColors.dividerColor,
            thickness: 1,
          ),
        ),
      ],
    );
  }

  static Widget buildGoogleSignInButton(VoidCallback onPressed) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: const FaIcon(FontAwesomeIcons.google,
            color: Color(0xFFDB4437), size: 20),
        label: const Text(
          'Continue with Google',
          style: TextStyle(
            color: ThemeColors.secondary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: const BorderSide(color: ThemeColors.borderColor, width: 1),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}
