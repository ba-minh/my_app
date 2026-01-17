import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';
import '../widgets/detail_app_bar.dart';

class CabinetScheduleScreen extends StatelessWidget {
  final String cabinetName;

  const CabinetScheduleScreen({
    super.key,
    required this.cabinetName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // Hoặc AppColors.white
      // 👇 Sử dụng DetailAppBar có nút Back
      appBar: DetailAppBar(
        title: "Lịch biểu: $cabinetName",
        showBackButton: true,
      ),
      body: const Center(
        child: Text(
          "Nội dung cài đặt lịch biểu sẽ hiển thị ở đây\n(Khác với màn hình điều khiển)",
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.grey, fontSize: 16),
        ),
      ),
    );
  }
}