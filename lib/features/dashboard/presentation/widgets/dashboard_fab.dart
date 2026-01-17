import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class DashboardFab extends StatelessWidget {
  final VoidCallback onPressed;

  const DashboardFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: FloatingActionButton(
        onPressed: onPressed,
        // 👇 Nền xanh Primary
        backgroundColor: AppColors.primary, 
        shape: const CircleBorder(),
        elevation: 4,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thanh ngang (Màu trắng)
            Container(
              width: 32,
              height: 7, 
              decoration: BoxDecoration(
                color: AppColors.white, // 👇 Đổi thành màu trắng
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Thanh dọc (Màu trắng)
            Container(
              width: 7, 
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.white, // 👇 Đổi thành màu trắng
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}