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
    // 👇 1. Tăng chiều cao lên 85 để chứa đủ Icon + Text
    const double barHeight = 75.0; 
    const double borderRadius = 20.0; 

    return Container(
      height: barHeight,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(borderRadius),
          topRight: Radius.circular(borderRadius),
        ),
        border: Border(
          top: BorderSide(color: AppColors.primary, width: 2.0),
          left: BorderSide(color: AppColors.primary, width: 2.0),
          right: BorderSide(color: AppColors.primary, width: 2.0),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(borderRadius - 2),
          topRight: Radius.circular(borderRadius - 2),
        ),
        child: BottomAppBar(
          shape: null, 
          color: AppColors.white,
          elevation: 0,
          height: barHeight,
          padding: EdgeInsets.zero,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround, 
            children: [
              // 👇 2. Thay Icon đậm hơn & Thêm nhãn Text
              _buildNavItem(Icons.grid_view_rounded, "Danh sách", 0),
              _buildNavItem(Icons.calendar_month, "Lịch biểu", 1),
              _buildNavItem(Icons.notifications, "Thông báo", 2),
              _buildNavItem(Icons.person, "Cá nhân", 3),
            ],
          ),
        ),
      ),
    );
  }

  // 👇 Sửa hàm này để nhận thêm String label
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;
    // Màu sắc: Chọn thì xanh, không chọn thì xám đậm (để trông đậm hơn)
    final Color itemColor = isSelected ? AppColors.primary : Colors.black87;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Icon(
              icon,
              size: 28, // Kích thước vừa phải
              color: itemColor,
            ),
            
            const SizedBox(height: 4), // Khoảng cách giữa Icon và Chữ

            // Text Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12, // Cỡ chữ nhỏ vừa vặn
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, // Chọn thì chữ đậm
                color: itemColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}