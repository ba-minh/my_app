import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../../../../domain/entities/device_entity.dart';
import '../widgets/device_card.dart';
import '../widgets/dashboard_app_bar.dart';
import '../blocs/device_bloc.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  void _showDeleteDialog(BuildContext context, int index, String deviceName) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text("Xóa tủ điện?", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Text("Bạn có chắc chắn muốn xóa tủ điện:\n'$deviceName' không?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Hủy", style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                context.read<DeviceBloc>().add(DeleteDeviceItem(index, 'cabinet')); 
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Đã xóa $deviceName")),
                );
              },
              child: const Text("Xóa", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DashboardAppBar(
        onAvatarTap: () {
          context.push('/dashboard/profile-detail');
        }, 
      ),
      body: SafeArea(
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.userDevices.isEmpty) {
              return _buildEmptyState();
            }
            return _buildDeviceList(context, state.userDevices);
          },
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return LayoutBuilder(builder: (context, constraints) {
      return SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.kitchen, size: 80, color: AppColors.grey.withOpacity(0.5)),
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

  Widget _buildDeviceList(BuildContext context, List<DeviceEntity> devices) {
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
                
                // Logic Online/Offline (1 là Online)
                final bool isOnline = device.status == 1;

                return DeviceCard(
                  name: device.name, 
                  // Chọn Icon Wifi hoặc Wifi gạch chéo
                  icon: isOnline ? Icons.wifi : Icons.wifi_off,
                  // 👇 TRUYỀN TRẠNG THÁI VÀO ĐÂY ĐỂ ĐỔI MÀU & CHỮ
                  isOnline: isOnline, 
                  
                  onTap: () {
                    context.go('/dashboard/detail', extra: device);
                  },
                  onLongPress: () {
                    _showDeleteDialog(context, index, device.name);
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