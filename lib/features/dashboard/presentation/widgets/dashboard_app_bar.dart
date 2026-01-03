import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';
import 'logout_dialog.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onLogout;

  const DashboardAppBar({
    super.key,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary, // 👇 Dùng biến màu chung
      elevation: 0,
      toolbarHeight: 120,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            const Icon(Icons.eco, color: AppColors.white, size: 50), // 👇 Dùng AppColors.white
            
            // Khoảng cách
            const SizedBox(height: 8), 

            // Text
            const Text(
              "Trang trại của tôi",
              style: TextStyle(
                color: AppColors.white, // 👇 Dùng AppColors.white
                fontSize: 23,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.white24,
              backgroundImage: const NetworkImage("https://i.pravatar.cc/150?img=11"),
              onBackgroundImageError: (_, __) {},
              child: const Icon(Icons.person, color: AppColors.white),
            ),
          ),
        )
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Dismiss",
      barrierColor: Colors.black.withOpacity(0.25),
      transitionDuration: Duration.zero,
      pageBuilder: (context, animation1, animation2) => const LogoutDialog(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120);
}