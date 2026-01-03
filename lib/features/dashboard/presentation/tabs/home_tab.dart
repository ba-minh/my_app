import 'package:flutter/material.dart';

import '../../../../core_ui/theme/app_colors.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  // Biến giả lập dữ liệu (Giai đoạn 1: UI Tĩnh)
  // false = Chưa có tủ nào (Hiện màn hình Rỗng)
  // true = Đã có tủ (Hiện danh sách - Sẽ làm ở Bước 4)
  final bool _hasDevices = false; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, 
      body: _hasDevices 
          ? _buildDeviceList() // Nếu có thiết bị
          : _buildEmptyState(), // Nếu chưa có thiết bị
    );
  }

  // 1. GIAO DIỆN TRẠNG THÁI RỖNG (Empty State)
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              "Chưa có thiết bị nào....",
              style: TextStyle(
                fontSize: 18,
                // 👇 SỬA 2: Dùng AppColors.grey
                color: AppColors.grey, 
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // 2. GIAO DIỆN DANH SÁCH (Placeholder cho Bước 4)
  Widget _buildDeviceList() {
    return const Center(
      child: Text("Danh sách thiết bị sẽ hiện ở đây"),
    );
  }
}