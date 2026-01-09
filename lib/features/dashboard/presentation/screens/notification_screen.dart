import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

import '../widgets/notification_card.dart';
import '../widgets/detail_app_bar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      // ... (Giữ nguyên dữ liệu cũ của bạn)
      {
        "title": "Cảnh báo mất điện",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
      {
        "title": "Cảnh báo nhiệt độ",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
      {
        "title": "Cảnh báo độ ẩm",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
      {
        "title": "Quạt 1",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
      {
        "title": "Đèn sưởi 1",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
       {
        "title": "Cảnh báo mất điện",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
       {
        "title": "Cảnh báo nhiệt độ",
        "content": "Nội dung cảnh báo",
        "time": "16:21, 04/12/2025"
      },
    ];

    return Scaffold(
      backgroundColor: AppColors.white,
      
      // 👇 2. SỬ DỤNG DETAIL APP BAR
      appBar: const DetailAppBar(
        title: "Thông báo",
        showBackButton: false, // Ẩn nút back vì đây là màn hình chính
      ),
      
      body: ListView.builder(
        padding: const EdgeInsets.all(20.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          return NotificationCard(
            title: item['title']!,
            content: item['content']!,
            time: item['time']!,
          );
        },
      ),
    );
  }
}