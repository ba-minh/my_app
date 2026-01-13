import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';

import '../../../../core_ui/theme/app_colors.dart';
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
  final _confirmPasswordController = TextEditingController(); 

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        } else if (state is AuthSuccess) {
          context.go('/dashboard'); 
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView( 
          // 👇 1. BỌC TRONG AUTOFILL GROUP
          child: AutofillGroup(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // 2. Email
                CustomTextField(
                  label: "Email của bạn",
                  placeholder: "Nhập Email của bạn.....",
                  controller: _emailController,
                  // 👇 Gợi ý email mới
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // 3. Mật khẩu
                CustomTextField(
                  label: "Tạo mật khẩu",
                  placeholder: "Nhập mật khẩu của bạn.....",
                  isPassword: true,
                  controller: _passwordController,
                  // 👇 Gợi ý mật khẩu mới (thường sẽ đề xuất mật khẩu mạnh)
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 20),

                // 4. Nhập lại mật khẩu
                CustomTextField(
                  label: "Nhập lại mật khẩu",
                  placeholder: "Nhập lại mật khẩu của bạn.....",
                  isPassword: true,
                  controller: _confirmPasswordController,
                  // 👇 Cũng là mật khẩu mới
                  autofillHints: const [AutofillHints.newPassword],
                ),
                const SizedBox(height: 40),

                // 5. Nút Đăng ký
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: "Tiếp tục",
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        // Kiểm tra mật khẩu khớp nhau
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Mật khẩu không khớp!"),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        
                        // Kích hoạt lưu thông tin đăng ký
                        TextInput.finishAutofillContext();
                        
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
      ),
    );
  }
}