import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String placeholder;
  final bool isPassword; // Đây là biến xác định xem ô này có phải là mật khẩu không
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
  // Biến nội bộ để theo dõi trạng thái ẩn/hiện
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          // Nếu là password thì dùng biến _obscureText, nếu không thì luôn hiện (false)
          obscureText: widget.isPassword ? _obscureText : false,
          decoration: InputDecoration(
            hintText: widget.placeholder,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            
            // LOGIC CON MẮT Ở ĐÂY
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      // Chọn icon dựa trên trạng thái
                      _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      // Khi bấm vào thì đảo ngược trạng thái (Ẩn -> Hiện -> Ẩn)
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