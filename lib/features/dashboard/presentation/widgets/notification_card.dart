import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class NotificationCard extends StatelessWidget {
  final String title;
  final String content;
  final String time;

  const NotificationCard({
    super.key,
    required this.title,
    required this.content,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16), // Khoảng cách giữa các thẻ
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16), // Bo góc 16
        border: Border.all(
          color: AppColors.primary, // Viền màu xanh
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Tiêu đề (Cảnh báo mất điện)
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),

          // 2. Nội dung (Nội dung cảnh báo)
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 12),

          // 3. Thời gian (16:21, 04/12/2025)
          Text(
            time,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey, // Màu xám nhạt
            ),
          ),
        ],
      ),
    );
  }
}