import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class DashboardBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const DashboardBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const double barHeight = 85.0; // Tăng chiều cao lên 85 để chứa bo góc đẹp hơn

    // Container chịu trách nhiệm vẽ Viền và Bo góc
    return Container(
      height: barHeight,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        // 👇 Bo góc 24 ở 2 đỉnh trên
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        // 👇 Viền bao màu xanh (Dùng AppColors.primary)
        border: Border(
          top: BorderSide(color: AppColors.primary, width: 2.0),
          left: BorderSide(color: AppColors.primary, width: 2.0),
          right: BorderSide(color: AppColors.primary, width: 2.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(22),
          topRight: Radius.circular(22),
        ),
        child: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          notchMargin: 8.0,
          color: AppColors.white,
          elevation: 0,
          height: barHeight,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_outlined, 0),
              _buildNavItem(Icons.calendar_today_outlined, 1),
              
              const SizedBox(width: 60), // Khoảng trống rộng hơn cho FAB to
              
              _buildNavItem(Icons.notifications_outlined, 2),
              _buildNavItem(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 30,
              // 👇 Dùng AppColors.primary thay cho biến local cũ
              color: isSelected ? AppColors.primary : AppColors.black,
            ),
          ],
        ),
      ),
    );
  }
}