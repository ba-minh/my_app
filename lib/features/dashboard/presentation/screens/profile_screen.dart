import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_event.dart';
import '../../../auth/presentation/blocs/auth_state.dart';

// 👇 Import DeviceBloc để gọi lệnh Reset
import '../blocs/device_bloc.dart'; 

import '../widgets/detail_app_bar.dart';
import '../widgets/logout_dialog.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showEditNameDialog(BuildContext context, String currentName) {
    final TextEditingController nameController = TextEditingController(text: currentName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đổi tên hiển thị"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Nhập tên mới"),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy", style: TextStyle(color: AppColors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (nameController.text.trim().isNotEmpty) {
                context.read<AuthBloc>().add(
                  UpdateProfileRequested(displayName: nameController.text.trim()),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("Lưu", style: TextStyle(color: AppColors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final bool isMainTab = location == '/profile';

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
          // 1. Gửi lệnh xóa sạch dữ liệu thiết bị cũ
          context.read<DeviceBloc>().add(ResetDeviceEvent());

          // 2. Sau đó mới chuyển về màn hình Login
          context.go('/login');
        }
      },
      builder: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final String displayName = user?.displayName ?? "Chưa đặt tên";
        final String? photoUrl = user?.photoURL;
        final String email = user?.email ?? "";

        return Scaffold(
          backgroundColor: AppColors.white,
          
          appBar: DetailAppBar(
            title: "Trang cá nhân",
            showBackButton: !isMainTab, 
            onBackPressed: () => context.pop(),
          ),
          
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // --- AVATAR ---
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    shape: BoxShape.circle,
                    image: (photoUrl != null)
                        ? DecorationImage(
                            image: NetworkImage(photoUrl),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: (photoUrl == null)
                      ? Text(
                          displayName.isNotEmpty ? displayName[0].toUpperCase() : "U",
                          style: const TextStyle(fontSize: 40, color: AppColors.primary, fontWeight: FontWeight.bold),
                        )
                      : null,
                ),
                
                const SizedBox(height: 16),
                
                // --- TÊN & BÚT CHÌ ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Opacity(
                      opacity: 0.0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        child: const Icon(Icons.edit, size: 20),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        displayName,
                        style: const TextStyle(
                          fontSize: 22, 
                          fontWeight: FontWeight.bold
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => _showEditNameDialog(context, displayName),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        color: AppColors.transparent, 
                        child: const Icon(Icons.edit, size: 20, color: AppColors.grey),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 4), 
                Text(
                  email,
                  style: const TextStyle(fontSize: 14, color: AppColors.grey),
                ),

                const SizedBox(height: 30),

                _buildOptionButton("Thông tin tài khoản"),
                const SizedBox(height: 16),
                _buildOptionButton("Cài đặt ứng dụng"),
                const SizedBox(height: 16),
                _buildOptionButton("Trợ giúp & Phản hồi"),
                const SizedBox(height: 40),

                // --- NÚT ĐĂNG XUẤT ---
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const LogoutDialog(),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary), 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Đăng xuất",
                      style: TextStyle(
                        color: AppColors.error,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background, 
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary), 
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: AppColors.black87, fontWeight: FontWeight.w500),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
        ],
      ),
    );
  }
}