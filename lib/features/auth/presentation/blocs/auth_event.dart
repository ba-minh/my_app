import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object> get props => [];
}

// 1. Sự kiện khi người dùng bấm nút "Đăng nhập"
class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

// 2. Sự kiện Đăng ký 
class SignUpRequested extends AuthEvent {
  final String email;
  final String password;
  const SignUpRequested(this.email, this.password);
  @override
  List<Object> get props => [email, password];
}

// 3. Sự kiện Quên mật khẩu 
class ResetPasswordRequested extends AuthEvent {
  final String email;
  const ResetPasswordRequested(this.email);
  @override
  List<Object> get props => [email];
}