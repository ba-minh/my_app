import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class DashboardFab extends StatelessWidget {
  final VoidCallback onPressed;

  const DashboardFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 65,
      child: FloatingActionButton(
        onPressed: onPressed,
        backgroundColor: AppColors.white,
        // Viền tròn dùng AppColors.primary
        shape: const CircleBorder(
          side: BorderSide(color: AppColors.primary, width: 2.5),
        ),
        elevation: 4,
        // 👇 Vẽ dấu cộng dày thay vì dùng Icon mặc định
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Thanh ngang
            Container(
              width: 32,
              height: 7, // Độ dày nét
              decoration: BoxDecoration(
                color: AppColors.primary, // Dùng AppColors
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            // Thanh dọc
            Container(
              width: 7, // Độ dày nét
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.primary, // Dùng AppColors
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}