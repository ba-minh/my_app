import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';
// 👇 Import Widget Dialog mà bạn vừa tạo ở Bước 1
import '../widgets/logout_dialog.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // Khi Bloc báo về trạng thái Initial (đã đăng xuất xong) -> Chuyển về Login
          context.go('/login'); 
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trang chủ (Dashboard)"),
          backgroundColor: const Color(0xFF055B1D),
          foregroundColor: Colors.white,
          actions: [
            // 👇 1. NÚT TRÊN APPBAR
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Đăng xuất",
              onPressed: () {
                // Thay vì gọi Bloc ngay, ta hiện Dialog
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.agriculture, size: 80, color: Color(0xFF055B1D)),
              const SizedBox(height: 20),
              const Text(
                "Xin chào! Bạn đã đăng nhập.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Test tính năng Logout bên dưới 👇"),
              const SizedBox(height: 30),
              
              // 👇 2. NÚT GIỮA MÀN HÌNH
              ElevatedButton.icon(
                onPressed: () {
                   // Thay vì gọi Bloc ngay, ta hiện Dialog
                  _showLogoutDialog(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text("Đăng xuất ngay"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade100,
                  foregroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 👇 HÀM HIỆN DIALOG THEO ĐÚNG YÊU CẦU FIGMA
  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Cho phép bấm ra ngoài để đóng
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.25), // 👇 Background tối 25%
      transitionDuration: Duration.zero, // 👇 Animation Instant (Hiện ngay lập tức)
      pageBuilder: (context, animation1, animation2) {
        return const LogoutDialog(); // Gọi Widget Dialog bạn đã tạo ở Bước 1
      },
    );
  }
}