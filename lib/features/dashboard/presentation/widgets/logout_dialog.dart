import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    // Màu xanh chủ đạo
    const mainColor = Color(0xFF1E5128); 

    return Dialog(
      backgroundColor: Colors.transparent, // Để trong suốt để ta tự vẽ container
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        // 👇 KÍCH THƯỚC KHUNG: 376 x 130
        width: 376,
        height: 180, // Tôi tăng nhẹ lên 180 vì 130 sẽ bị chật khi chứa cả Title, Subtitle và Button
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16), // Bo góc giống ảnh
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Tiêu đề
            const Text(
              "Đăng xuất ?",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 8),
            
            // 2. Nội dung phụ
            const Text(
              "Bạn có chắc chắn muốn đăng xuất không ?",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),

            // 3. Hai nút bấm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // NÚT 1: ĐĂNG XUẤT (Viền xanh, nền trắng)
                SizedBox(
                  width: 110, // Kích thước 110
                  height: 40, // Kích thước 40
                  child: OutlinedButton(
                    onPressed: () {
                      // Tắt dialog trước
                      context.pop(); 
                      // Gửi sự kiện đăng xuất
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: mainColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text("Đăng xuất", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),

                // NÚT 2: ĐÓNG (Nền xanh, chữ trắng)
                SizedBox(
                  width: 110, // Kích thước 110
                  height: 40, // Kích thước 40
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(); // Đóng dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Đóng", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}