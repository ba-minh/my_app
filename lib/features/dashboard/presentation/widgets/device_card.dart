import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class DeviceCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isOnline; // 👇 THÊM: Trạng thái kết nối
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const DeviceCard({
    super.key,
    required this.name,
    required this.icon,
    required this.isOnline, // 👇 Bắt buộc truyền vào
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Xác định màu sắc dựa trên trạng thái
    final statusColor = isOnline ? AppColors.primary : Colors.grey;
    final statusText = isOnline ? "Đang kết nối" : "Mất kết nối";
    final statusTextColor = isOnline ? Colors.green : Colors.grey;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon tròn
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1), // Nền nhạt theo màu trạng thái
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: statusColor, size: 32), // Icon theo màu trạng thái
            ),
            const SizedBox(height: 12),
            
            // Tên thiết bị
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                name,
                style: const TextStyle(
                  fontSize: 16, 
                  fontWeight: FontWeight.bold,
                  color: Colors.black87
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 4),
            
            // Trạng thái text
            Text(
              statusText, // Hiện "Đang kết nối" hoặc "Mất kết nối"
              style: TextStyle(fontSize: 12, color: statusTextColor),
            ),
          ],
        ),
      ),
    );
  }
}