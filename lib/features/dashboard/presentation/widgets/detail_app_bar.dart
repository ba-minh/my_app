import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class DetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  // 👇 THÊM THAM SỐ NÀY
  final bool showBackButton; 

  const DetailAppBar({
    super.key,
    required this.title,
    this.onBackPressed,
    // Mặc định là hiện nút Back (true)
    this.showBackButton = true, 
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 0,
      centerTitle: true,
      // 👇 LOGIC ẨN/HIỆN NÚT BACK
      leading: showBackButton 
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null, // Nếu false thì không hiện gì
      automaticallyImplyLeading: false, // Tắt nút back mặc định của Android/iOS để mình tự quản lý
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}