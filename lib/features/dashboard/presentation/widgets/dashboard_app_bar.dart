import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';
// ❌ XÓA: import 'logout_dialog.dart'; (Không cần nữa)

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  // 👇 ĐỔI TÊN: Thay vì onLogout thì là onAvatarTap
  final VoidCallback onAvatarTap;

  const DashboardAppBar({
    super.key,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      toolbarHeight: 100, 
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0), 
              child: const Icon(Icons.eco, color: AppColors.white, size: 40),
            ),
            
            const SizedBox(height: 4), 

            const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Trang trại của tôi",
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22, 
                  fontWeight: FontWeight.bold,
                  height: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: GestureDetector(
            // 👇 GỌI HÀM CHUYỂN TRANG
            onTap: onAvatarTap, 
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                color: Colors.white30,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                backgroundImage: const NetworkImage("https://i.pravatar.cc/150?img=11"),
                onBackgroundImageError: (_, __) {},
                child: const Icon(Icons.person, color: AppColors.white, size: 20),
              ),
            ),
          ),
        )
      ],
    );
  }

  // ❌ ĐÃ XÓA HÀM _showLogoutDialog

  @override
  Size get preferredSize => const Size.fromHeight(100);
}