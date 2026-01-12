import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../../../../domain/entities/device_entity.dart';
import '../widgets/detail_app_bar.dart';
import '../blocs/device_bloc.dart'; 
import '../widgets/device_card.dart'; 

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      appBar: const DetailAppBar(
        title: "Lịch biểu",
        showBackButton: false,
      ),

      body: BlocBuilder<DeviceBloc, DeviceState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 👇 2. SỬA: Dùng userDevices (Danh sách Tủ) thay vì uiIODevices
          if (state.userDevices.isEmpty) {
            return const Center(
              child: Text("Chưa có tủ điều khiển nào để đặt lịch."),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              // 👇 3. SỬA: Số lượng theo danh sách tủ
              itemCount: state.userDevices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, 
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                // 👇 4. Lấy dữ liệu kiểu Entity
                final device = state.userDevices[index];
                final bool isOnline = device.status == 1;
                
                return DeviceCard(
                  name: device.name, // Lấy tên từ Entity
                  
                  // Chọn icon Lịch để phù hợp ngữ cảnh màn hình này
                  icon: Icons.calendar_month, 
                  
                  // 👇 5. SỬA LỖI QUAN TRỌNG: Truyền tham số isOnline bắt buộc
                  isOnline: isOnline,
                  
                  onTap: () {
                    // Chuyển sang chi tiết lịch, truyền theo object device
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