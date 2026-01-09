import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../widgets/detail_app_bar.dart';
import '../blocs/device_bloc.dart'; // Sử dụng lại Bloc của Home để lấy danh sách tủ
import '../widgets/device_card.dart'; // Tận dụng lại Card thiết bị cũ (hoặc tạo mới nếu muốn khác)

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // 👇 1. Sử dụng DetailAppBar (Không nút Back vì là màn hình chính của Tab)
      appBar: const DetailAppBar(
        title: "Lịch biểu",
        showBackButton: false,
      ),

      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          // Xử lý trạng thái Loading/Empty...
          if (state.devices.isEmpty) {
            return const Center(
              child: Text("Chưa có tủ điều khiển nào để đặt lịch."),
            );
          }

          // 👇 2. Hiển thị danh sách (Chỉ hiển thị tủ, KHÔNG CÓ nút cộng)
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: state.devices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 cột
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final device = state.devices[index];
                
                // Tái sử dụng DeviceCard hoặc custom card khác
                return DeviceCard(
                  name: device['name'],
                  icon: device['icon'], 
                  onTap: () {
                    // 👇 3. Điều hướng sang màn hình Lịch Chi Tiết (Route mới)
                    // Truyền object device đi để bên kia biết là đang đặt lịch cho tủ nào
                    context.go('/calendar/detail', extra: device);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}