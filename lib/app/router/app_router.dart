import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash', 
  routes: [
    // 1. Màn hình Chào
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    
    // 2. Màn hình Đăng nhập
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const AuthScreen(); 
      },
    ),

    // 3. Màn hình quên mật khẩu
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // 4. Màn hình Dashboard 
    GoRoute(
      path: '/dashboard',
      builder: (context, state) {
        return const Scaffold(
          body: Center(child: Text("Dashboard IoT")),
        );
      },
    ),
  ],
);