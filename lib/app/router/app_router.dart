import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import các màn hình
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/main_layout.dart';

// Import các Tab con
import '../../features/dashboard/presentation/tabs/home_tab.dart';
import '../../features/dashboard/presentation/screens/cabinet_detail_screen.dart';
// 👇 MỚI: Import Profile Screen
import '../../features/dashboard/presentation/screens/profile_screen.dart';

// Key để quản lý Navigator gốc
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
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
      builder: (context, state) => const AuthScreen(),
    ),
    
    // 3. Màn hình Quên mật khẩu
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // 4. CẤU HÌNH SHELL ROUTE
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainLayout(navigationShell: navigationShell);
      },
      branches: [
        // --- NHÁNH 0: HOME (Dashboard) ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const HomeTab(),
              routes: [
                // Route con: Chi tiết tủ
                GoRoute(
                  path: 'detail', 
                  builder: (context, state) {
                    final extra = state.extra as Map<String, dynamic>?;
                    return CabinetDetailScreen(
                      cabinetName: extra?['name'] ?? 'Tủ điều khiển',
                    );
                  },
                ),
                // 👇 MỚI: Route con Trang cá nhân
                GoRoute(
                  path: 'profile-detail', // Đường dẫn: /dashboard/profile-detail
                  parentNavigatorKey: _rootNavigatorKey, // Che lấp BottomBar
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),

        // --- NHÁNH 1: LỊCH ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/calendar',
              builder: (context, state) => const Scaffold(body: Center(child: Text("Màn hình Lịch"))),
            ),
          ],
        ),

        // --- NHÁNH 2: THÔNG BÁO ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const Scaffold(body: Center(child: Text("Màn hình Thông báo"))),
            ),
          ],
        ),

        // --- NHÁNH 3: CÁ NHÂN (Tab BottomBar) ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const Scaffold(body: Center(child: Text("Màn hình Cá nhân"))),
            ),
          ],
        ),
      ],
    ),
  ],
);