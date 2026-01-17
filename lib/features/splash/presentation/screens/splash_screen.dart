import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core_ui/theme/app_colors.dart';
import '../../../auth/presentation/blocs/auth_bloc.dart';
import '../../../auth/presentation/blocs/auth_state.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // 1. Nếu tìm thấy User -> Vào thẳng Dashboard
        if (state is AuthSuccess) {
          context.go('/dashboard');
        } 
        // 2. Nếu không có User -> Về Login
        else if (state is AuthInitial) {
          context.go('/login');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.white, 
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo CROP TEX
              Image.asset(
                'assets/images/Logo.png', 
                height: 148,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.agriculture, 
                    size: 100, 
                    color: AppColors.primary
                  );
                },
              ),
            
              const SizedBox(height: 20),
              
              const CircularProgressIndicator(
                color: AppColors.primary, 
              ),
            ],
          ),
        ),
      ),
    );
  }
}