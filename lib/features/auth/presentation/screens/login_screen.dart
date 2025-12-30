import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/custom_textfield.dart'; // Widget ô nhập đẹp
import '../../../../app/widgets/primary_button.dart'; // Widget nút bấm đẹp
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AuthSuccess) {
          context.go('/dashboard');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0), // Căn lề 4 phía
        child: SingleChildScrollView( // Cho phép cuộn nếu bàn phím che mất
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // 1. Ô nhập Email (Dùng Widget đẹp)
            CustomTextField(
              label: "Email của bạn",
              placeholder: "Nhập Email của bạn.....",
              controller: _emailController,
            ),
            const SizedBox(height: 20),

            // 2. Ô nhập Mật khẩu (Dùng Widget đẹp)
            CustomTextField(
              label: "Mật khẩu",
              placeholder: "Nhập mật khẩu của bạn.....",
              isPassword: true,
              controller: _passwordController,
            ),
            
            // 3. Nút Quên mật khẩu
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  context.push('/forgot-password'); // Chuyển sang màn Quên mật khẩu
                },
                child: const Text(
                  "Quên mật khẩu?",
                  style: TextStyle(color: Color(0xFF1E5128), fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 4. Nút Đăng nhập (Dùng Widget đẹp)
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                return PrimaryButton(
                  text: "Tiếp tục", // Giống thiết kế
                  isLoading: state is AuthLoading,
                  onPressed: () {
                    context.read<AuthBloc>().add(
                          LoginRequested(
                            _emailController.text,
                            _passwordController.text,
                          ),
                        );
                  },
                );
              },
            ),
            
            // 5. Phần "Hoặc đăng nhập bằng Google" (Để sau làm sau, tạm vẽ giao diện)
            const SizedBox(height: 30),
            const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("Or", style: TextStyle(color: Colors.grey))), Expanded(child: Divider())]),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {}, // Chưa làm chức năng này
                icon: const Icon(Icons.g_mobiledata, size: 30, color: Colors.red), // Tạm dùng icon có sẵn
                label: const Text("Đăng nhập bằng Google", style: TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
        ),
        
      ),
    );
  }
}