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
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        } else if (state is AuthSuccess) {
          // Kết thúc phiên Autofill khi đăng nhập thành công để đề xuất lưu mật khẩu
          // TextInput.finishAutofillContext(); 
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
                
                // 2. Ô nhập Email
                CustomTextField(
                  label: "Email của bạn",
                  placeholder: "Nhập Email của bạn.....",
                  controller: _emailController,
                  // 👇 Khai báo gợi ý Email
                  autofillHints: const [AutofillHints.email],
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),

                // 3. Ô nhập Mật khẩu
                CustomTextField(
                  label: "Mật khẩu",
                  placeholder: "Nhập mật khẩu của bạn.....",
                  isPassword: true,
                  controller: _passwordController,
                  // 👇 Khai báo gợi ý Password
                  autofillHints: const [AutofillHints.password],
                  onEditingComplete: () => TextInput.finishAutofillContext(),
                ),
                
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      context.push('/forgot-password');
                    },
                    child: const Text(
                      "Quên mật khẩu?",
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return PrimaryButton(
                      text: "Tiếp tục",
                      isLoading: state is AuthLoading,
                      onPressed: () {
                        // Kích hoạt lưu mật khẩu
                        TextInput.finishAutofillContext(); 
                        context.read<AuthBloc>().add(
                              LoginRequested(
                                _emailController.text,
                                _passwordController.text,
                              ),
                            );
                      },
                    );
                  }
                ),
                
                const SizedBox(height: 30),
                const Row(children: [
                  Expanded(child: Divider()), 
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10), 
                    child: Text("Or", style: TextStyle(color: AppColors.grey))
                  ), 
                  Expanded(child: Divider())
                ]),
                const SizedBox(height: 20),
                
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.read<AuthBloc>().add(GoogleSignInRequested());
                    }, 
                    icon: const Icon(Icons.g_mobiledata, size: 30, color: AppColors.error), 
                    label: const Text("Đăng nhập bằng Google", style: TextStyle(color: AppColors.black)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}