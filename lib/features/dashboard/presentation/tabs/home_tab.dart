import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../widgets/device_card.dart';

import '../widgets/dashboard_app_bar.dart';

import '../blocs/device_bloc.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      // 👇 SỬA LOGIC: Bấm Avatar -> Chuyển sang màn hình Profile chi tiết
      appBar: DashboardAppBar(
        onAvatarTap: () {
          // Dùng context.push để có thể back lại
          context.push('/dashboard/profile-detail');
        }, 
      ),

      body: SafeArea(
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            
            if (state.devices.isEmpty) {
              return _buildEmptyState();
            }

            return _buildDeviceList(context, state.devices);
          },
        ),
      ),
    );
  }

  // --- GIỮ NGUYÊN CODE DƯỚI ĐÂY ---
  Widget _buildEmptyState() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sensors_off_rounded, size: 80, color: AppColors.grey.withOpacity(0.5)),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Text(
                    "Chưa có tủ điều khiển nào.\nNhấn dấu + để thêm mới.",
                    style: TextStyle(fontSize: 16, color: AppColors.grey, fontWeight: FontWeight.w500, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildDeviceList(BuildContext context, List<Map<String, dynamic>> devices) {
    final width = MediaQuery.of(context).size.width;
    final int crossAxisCount = width < 600 ? 2 : 3;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Danh sách tủ điều khiển", 
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 16),
          
          Expanded(
            child: GridView.builder(
              itemCount: devices.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final device = devices[index];
                
                return DeviceCard(
                  name: device['name'],
                  icon: device['icon'], 
                  onTap: () {
                    context.go('/dashboard/detail', extra: device);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}