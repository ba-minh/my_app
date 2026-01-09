import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../../../../core_ui/theme/app_colors.dart';

import '../widgets/dashboard_bottom_bar.dart';
import '../widgets/dashboard_fab.dart';
import 'add_device_screen.dart';
import '../blocs/device_bloc.dart';

class MainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

  void _onTabSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  // Chức năng 1: Thêm Tủ (Home)
  Future<void> _onAddDevice(BuildContext context) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const AddDeviceScreen())
    );
    if (result != null && result is Map<String, dynamic>) {
      context.read<DeviceBloc>().add(AddDeviceEvent(result));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã thêm tủ thành công!"), backgroundColor: AppColors.primary),
      );
    }
  }

  // Chức năng 2: Thêm Lịch (Calendar)
  void _onAddSchedule(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Chức năng thêm lịch đang phát triển")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lấy đường dẫn hiện tại
    final String location = GoRouterState.of(context).uri.toString();

    VoidCallback? fabAction;
    bool showFab = false;

    // 👇 LOGIC QUYẾT ĐỊNH FAB THEO MÀN HÌNH
    if (location == '/dashboard') {
      // 1. Home -> Hiện nút thêm Tủ
      showFab = true;
      fabAction = () => _onAddDevice(context);
    }
    // Các trường hợp khác (Detail, Notify, Profile...) -> showFab = false -> Ẩn FAB cha

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background, 

        body: navigationShell,

        // FAB
        floatingActionButton: showFab 
            ? DashboardFab(onPressed: fabAction!)
            : null,
        
        // 👇 VỊ TRÍ MỚI: Góc dưới bên phải (EndFloat)
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        bottomNavigationBar: DashboardBottomBar(
          currentIndex: navigationShell.currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}