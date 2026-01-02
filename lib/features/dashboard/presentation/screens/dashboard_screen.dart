import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

// Lưu ý: Sửa lại đường dẫn import nếu IDE báo đỏ
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';
import '../../../auth/presentation/blocs/auth_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // BlocListener: Lắng nghe trạng thái AuthBloc
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Nếu trạng thái trở về Initial (tức là đã đăng xuất thành công)
        if (state is AuthInitial) {
          // Chuyển hướng về trang Login
          // Lưu ý: Kiểm tra lại router của bạn xem đường dẫn login là '/' hay '/login'
          context.go('/login'); 
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trang chủ (Dashboard)"),
          backgroundColor: const Color(0xFF055B1D), // Màu xanh nông trại
          foregroundColor: Colors.white,
          actions: [
            // 👇 NÚT ĐĂNG XUẤT TRÊN THANH APPBAR
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: "Đăng xuất",
              onPressed: () {
                // Gửi sự kiện yêu cầu đăng xuất
                context.read<AuthBloc>().add(SignOutRequested());
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
              
              // 👇 NÚT ĐĂNG XUẤT TO GIỮA MÀN HÌNH (CHO DỄ BẤM TEST)
              ElevatedButton.icon(
                onPressed: () {
                  context.read<AuthBloc>().add(SignOutRequested());
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
}