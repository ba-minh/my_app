import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword;
  final TextEditingController controller;

  const CustomTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.isPassword = false,
    required this.controller,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    // 1. Lấy bộ Theme từ context
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          // 2. Dùng textTheme chuẩn thay vì style cứng
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _obscureText : false,
          
          // 3. Decoration: Phần lớn sẽ được cấu hình trong AppTheme (Bước 2)
          decoration: InputDecoration(
            hintText: widget.placeholder,
            // (Lưu ý: Nếu cấu hình AppTheme tốt, bạn có thể xóa dòng hintStyle này đi)
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant, // Màu xám chuẩn của Material 3
            ),
            
            // Phần border nên để AppTheme lo, nhưng nếu muốn giữ ở đây thì dùng theme:
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      // 4. Dùng màu icon chuẩn
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