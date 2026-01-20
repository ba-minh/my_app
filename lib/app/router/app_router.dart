import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 👇 1. IMPORT ENTITY ĐỂ ROUTER HIỂU KIỂU DỮ LIỆU
import '../../domain/entities/device_entity.dart';

// Import các màn hình
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/dashboard/presentation/screens/main_layout.dart';

// Import các Tab con
import '../../features/dashboard/presentation/tabs/home_tab.dart';
import '../../features/dashboard/presentation/screens/cabinet_detail_screen.dart';
import '../../features/dashboard/presentation/screens/profile_screen.dart';
import '../../features/dashboard/presentation/screens/notification_screen.dart';
import '../../features/dashboard/presentation/screens/calendar_screen.dart';
import '../../features/dashboard/presentation/screens/cabinet_schedule_screen.dart';

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

    // 4. CẤU HÌNH SHELL ROUTE (Bottom Navigation Bar)
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
                    // 👇 SỬA LỖI TẠI ĐÂY: Ép kiểu về DeviceEntity
                    final device = state.extra as DeviceEntity;
                    return CabinetDetailScreen(
                      device: device,
                    );
                  },
                ),
                // Route con: Trang cá nhân (truy cập từ avatar ở Home)
                GoRoute(
                  path: 'profile-detail', 
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
              builder: (context, state) => const CalendarScreen(),
              routes: [
                // Route con: Chi tiết lịch biểu
                GoRoute(
                  path: 'detail', 
                  builder: (context, state) {
                    // 👇 SỬA LỖI TẠI ĐÂY: Cũng ép kiểu về DeviceEntity
                    final device = state.extra as DeviceEntity;
                    
                    return CabinetScheduleScreen(
                      device: device,
                    );
                  },
                ),
              ],
            ),
          ],
        ),

        // --- NHÁNH 2: THÔNG BÁO ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationScreen(),
            ),
          ],
        ),

        // --- NHÁNH 3: CÁ NHÂN (Tab BottomBar) ---
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);