import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/widgets/custom_textfield.dart';
import '../../../../app/widgets/primary_button.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController(); // Thêm ô nhập lại pass

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        } else if (state is AuthSuccess) {
          context.go('/dashboard'); // Đăng ký thành công cũng vào Dashboard
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( // Cho phép cuộn nếu bàn phím che mất
          child: Column(
            children: [
              const SizedBox(height: 20),
              
              // 1. Email
              CustomTextField(
                label: "Email của bạn",
                placeholder: "Nhập Email của bạn.....",
                controller: _emailController,
              ),
              const SizedBox(height: 20),

              // 2. Mật khẩu
              CustomTextField(
                label: "Tạo mật khẩu",
                placeholder: "Nhập mật khẩu của bạn.....",
                isPassword: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 20),

              // 3. Nhập lại mật khẩu
              CustomTextField(
                label: "Nhập lại mật khẩu",
                placeholder: "Nhập lại mật khẩu của bạn.....",
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 40),

              // 4. Nút Đăng ký
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: "Tiếp tục",
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      // Kiểm tra mật khẩu khớp nhau trước khi gửi
                      if (_passwordController.text != _confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Mật khẩu không khớp!")),
                        );
                        return;
                      }
                      
                      // Gửi sự kiện Đăng ký
                      context.read<AuthBloc>().add(
                            SignUpRequested(
                              _emailController.text,
                              _passwordController.text,
                            ),
                          );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}