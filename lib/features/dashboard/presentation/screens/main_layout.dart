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

// 👇 CHUYỂN THÀNH STATEFUL WIDGET ĐỂ DÙNG INITSTATE
class MainLayout extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainLayout({
    super.key,
    required this.navigationShell,
  });

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  
  // 👇 GỌI LỆNH LOAD DỮ LIỆU KHI MÀN HÌNH ĐƯỢC TẠO
  @override
  void initState() {
    super.initState();
    // Kiểm tra: Nếu danh sách tủ đang trống (do vừa đăng nhập lại) thì tải lại
    final deviceBloc = context.read<DeviceBloc>();
    if (deviceBloc.state.userDevices.isEmpty) {
      deviceBloc.add(LoadDevices());
    }
  }

  void _onTabSelected(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  // Chức năng 1: Thêm Tủ (Home)
  Future<void> _onAddDevice(BuildContext context) async {
    final result = await Navigator.push(
      context, 
      MaterialPageRoute(builder: (context) => const AddDeviceScreen())
    );
    if (result != null && result is Map<String, dynamic>) {
      // 👇 SỬA QUAN TRỌNG: Gửi type là 'cabinet' (Tủ điện)
      context.read<DeviceBloc>().add(AddDeviceItem(result, 'cabinet'));
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đã thêm tủ thành công!"), backgroundColor: AppColors.primary),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    VoidCallback? fabAction;
    bool showFab = false;

    if (location == '/dashboard') {
      showFab = true;
      fabAction = () => _onAddDevice(context);
    }

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background, 

        body: widget.navigationShell, // Dùng widget.navigationShell

        floatingActionButton: showFab 
            ? DashboardFab(onPressed: fabAction!)
            : null,
        
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

        bottomNavigationBar: DashboardBottomBar(
          currentIndex: widget.navigationShell.currentIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}