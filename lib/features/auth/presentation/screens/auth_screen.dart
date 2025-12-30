import 'package:flutter/material.dart';

import 'login_screen.dart'; 
import 'sign_up_screen.dart'; 

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 60),
              // 2. Logo CROP TEX
              Image.asset(
                'assets/images/Logo.png',
                height: 148, 
              ),

              const SizedBox(height: 30),
              
              // 3. Thanh TabBar 
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: TabBar(
                  labelColor: Color(0xFF1E5128), 
                  unselectedLabelColor: Colors.grey, 
                  indicatorColor: Color(0xFF1E5128), 
                  indicatorWeight: 3,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  tabs: [
                    Tab(text: "Đăng nhập"),
                    Tab(text: "Đăng ký"),
                  ],
                ),
              ),

              // 4. Nội dung thay đổi
              const Expanded(
                child: TabBarView(
                  children: [
                    LoginScreen(), 
                    SignUpScreen(), 
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}