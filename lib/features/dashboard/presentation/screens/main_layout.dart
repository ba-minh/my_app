import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
import '../../../../core_ui/theme/app_colors.dart';

import '../widgets/dashboard_app_bar.dart';
import '../widgets/dashboard_bottom_bar.dart';
import '../widgets/dashboard_fab.dart';

import '../tabs/home_tab.dart'; 

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  // Danh sách các màn hình con
  final List<Widget> _tabs = [
    const HomeTab(),
    const Center(child: Text("Màn hình Lịch")),
    const Center(child: Text("Màn hình Thông báo")),
    const Center(child: Text("Màn hình Cá nhân")),
  ];

  // Hàm chuyển tab
  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Hàm xử lý khi bấm nút (+) thêm tủ
  void _onAddDevicePressed() {
     // TODO: Code logic mở màn hình thêm tủ ở Bước 5
     print("Mở màn hình thêm tủ");
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background, 
        
        // 1. APP BAR
        appBar: DashboardAppBar(
          onLogout: () {}, 
        ),

        // 2. BODY
        body: IndexedStack(
          index: _selectedIndex,
          children: _tabs,
        ),

        // 3. FAB
        floatingActionButton: DashboardFab(
          onPressed: _onAddDevicePressed,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

        // 4. BOTTOM BAR
        bottomNavigationBar: DashboardBottomBar(
          currentIndex: _selectedIndex,
          onTap: _onTabSelected,
        ),
      ),
    );
  }
}