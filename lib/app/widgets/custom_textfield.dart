import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final TextEditingController controller;
  
  // 👇 1. THÊM THAM SỐ MỚI
  final Iterable<String>? autofillHints; 
  final TextInputType? keyboardType;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    required this.controller,
    // 👇 2. THÊM VÀO CONSTRUCTOR
    this.autofillHints,
    this.keyboardType,
    this.onEditingComplete,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          
          // 👇 3. TRUYỀN THAM SỐ XUỐNG TEXTFIELD
          autofillHints: widget.autofillHints,
          keyboardType: widget.keyboardType ?? (widget.isPassword 
              ? TextInputType.visiblePassword 
              : TextInputType.emailAddress), // Mặc định thông minh

          onEditingComplete: widget.onEditingComplete,
          
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  )
                : null,
          ),
        ),
      ],
    );
  }
}