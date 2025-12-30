import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/utils/auth_error_translator.dart';
import '../../../../app/widgets/custom_textfield.dart';
import '../../../../app/widgets/primary_button.dart';
import '../blocs/auth_bloc.dart';
import '../blocs/auth_event.dart';
import '../blocs/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => context.pop(), // Quay lại màn đăng nhập
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            // Logic cũ của ta: Nếu thành công gửi mail thì AuthBloc cũng trả về AuthFailure kèm thông báo
            // Nên ta hiển thị thông báo ra (Dù đỏ hay xanh thì người dùng vẫn đọc được)
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                // Nếu thông báo chứa chữ "thành công" hoặc "gửi" thì hiện màu xanh, còn lại màu đỏ
                backgroundColor: state.message.contains("gửi") ? const Color(0xFF1E5128) : Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Tiêu đề to
              const Text(
                "Quên mật khẩu",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              // Dòng mô tả xám
              const Text(
                "Vui lòng nhập số email để đặt lại mật khẩu",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              // Ô nhập Email
              CustomTextField(
                label: "Email của bạn",
                placeholder: "contact@gmail.com",
                controller: _emailController,
              ),
              const SizedBox(height: 30),

              // Nút bấm
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  return PrimaryButton(
                    text: "Đặt lại mật khẩu",
                    isLoading: state is AuthLoading,
                    onPressed: () {
                      if (_emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Vui lòng nhập email!")),
                        );
                        return;
                      }
                      // Gửi sự kiện yêu cầu Reset
                      context.read<AuthBloc>().add(
                            ResetPasswordRequested(_emailController.text.trim()),
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