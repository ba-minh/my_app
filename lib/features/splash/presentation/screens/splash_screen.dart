import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Đếm ngược 1.5 giây (1500 milliseconds) rồi chuyển sang trang Login
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        context.go('/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [


            // Logo CROP TEX
            Image.asset(
              'assets/images/Logo.png', // Đảm bảo bạn đã có ảnh này
              height: 148, // Kích thước logo
            ),
          ],
        ),
      ),
    );
  }
}