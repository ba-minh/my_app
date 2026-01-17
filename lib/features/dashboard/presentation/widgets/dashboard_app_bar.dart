import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart'; 

import '../../../../core_ui/theme/app_colors.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAvatarTap;

  const DashboardAppBar({
    super.key,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Lấy thông tin User từ Firebase (Chỉ lấy ảnh mạng, không lấy ảnh local nữa)
        final user = FirebaseAuth.instance.currentUser;
        final String? photoUrl = user?.photoURL;

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

                // 👇 QUAY VỀ TIÊU ĐỀ CỐ ĐỊNH
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
                onTap: onAvatarTap, 
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.white.withOpacity(0.24),
                    // 👇 Chỉ hiển thị ảnh mạng hoặc icon mặc định
                    backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                        ? NetworkImage(photoUrl)
                        : null,
                    child: (photoUrl == null || photoUrl.isEmpty)
                        ? const Icon(Icons.person, color: AppColors.white, size: 20)
                        : null,
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}