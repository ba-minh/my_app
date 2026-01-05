import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: 376,
        height: 180,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
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
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            
            // 2. Nội dung phụ
            const Text(
              "Bạn có chắc chắn muốn đăng xuất không ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),

            // 3. Hai nút bấm
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // NÚT 1: ĐĂNG XUẤT (Viền xanh, Chữ xanh)
                SizedBox(
                  width: 110,
                  height: 42, // 👇 Tăng nhẹ height lên 42 để thoải mái hơn
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop(); 
                      context.read<AuthBloc>().add(SignOutRequested());
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero, // Bỏ padding mặc định
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text(
                      "Đăng xuất", 
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        height: 1.2, // 👇 Thêm dòng này để căn dòng chuẩn
                      ),
                    ),
                  ),
                ),

                // NÚT 2: ĐÓNG (Nền xanh, Chữ trắng)
                SizedBox(
                  width: 110,
                  height: 42, // 👇 Tăng nhẹ height lên 42
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero, // 👇 QUAN TRỌNG: Bỏ padding mặc định để chữ không bị đẩy
                    ),
                    child: const Text(
                      "Đóng", 
                      style: TextStyle(
                        fontSize: 15, 
                        fontWeight: FontWeight.bold,
                        height: 1.2, // 👇 QUAN TRỌNG: Fix lỗi mất chân chữ g
                      ),
                    ),
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