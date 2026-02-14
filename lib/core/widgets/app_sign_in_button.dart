import 'package:flutter/material.dart';

class AppSignInButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool fullWidth;
  final String label;

  const AppSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.fullWidth = true,
    this.label = "Sign In",
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        onPressed: isLoading ? null : onPressed,
        child:
            isLoading
                ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
                : Text(label),
      ),
    );
  }
}
