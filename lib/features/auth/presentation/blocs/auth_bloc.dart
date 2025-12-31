import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/usecases/sign_in_usecase.dart';
import '../../../../domain/usecases/sign_up_usecase.dart'; 
import '../../../../domain/usecases/reset_password_usecase.dart';
import '../../../../domain/usecases/sign_in_google_usecase.dart';
import '../../../../domain/usecases/check_auth_usecase.dart';
import '../../../../domain/usecases/sign_out_usecase.dart';

import '../../../../app/utils/auth_error_translator.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;          
  final ResetPasswordUseCase resetPasswordUseCase; 
  final SignInGoogleUseCase signInGoogleUseCase;
  final CheckAuthUseCase checkAuthUseCase;
  final SignOutUseCase signOutUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,           
    required this.resetPasswordUseCase,
    required this.signInGoogleUseCase,
    required this.checkAuthUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
    on<GoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<SignOutRequested>(_onSignOutRequested);
  }

  // 1. Xử lý Đăng nhập
  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final userEntity = await signInUseCase(event.email, event.password);
      final firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser != null) {
        await firebaseUser.reload(); 
        if (!firebaseUser.emailVerified) {
          await FirebaseAuth.instance.signOut();
          emit(const AuthFailure("Email chưa được xác thực. Vui lòng kiểm tra hộp thư của bạn!"));
          return; 
        }
      }
      emit(AuthSuccess(userEntity));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthErrorTranslator.translate(e.code)));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // 2. Xử lý Đăng ký
  Future<void> _onSignUpRequested(SignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await signUpUseCase(event.email, event.password);
      emit(const AuthFailure("Tài khoản đã tạo thành công! Vui lòng kiểm tra Email để xác thực trước khi đăng nhập."));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(AuthErrorTranslator.translate(e.code)));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // 3. Xử lý Quên mật khẩu
  Future<void> _onResetPasswordRequested(ResetPasswordRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase(event.email);
      emit(const AuthFailure("Đã gửi email khôi phục! Vui lòng kiểm tra hộp thư."));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // 4. Xử lý Đăng nhập Google (MỚI TINH)
  Future<void> _onGoogleSignInRequested(GoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await signInGoogleUseCase();
      emit(AuthSuccess(user));
    } catch (e) {
      if (e.toString().contains('hủy')) {
        emit(AuthInitial()); 
      } else {
        emit(AuthFailure(e.toString()));
      }
    }
  }

  // 5: TỰ ĐỘNG KIỂM TRA ĐĂNG NHẬP (Khi mở App)
  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    try {
      // Gọi UseCase kiểm tra xem có ai đang đăng nhập không
      final user = await checkAuthUseCase();
      
      if (user != null) {
        // Kiểm tra kỹ thêm 1 lần nữa xem email đã xác thực chưa (để an toàn)
        final firebaseUser = FirebaseAuth.instance.currentUser;
        if (firebaseUser != null && !firebaseUser.emailVerified) {
             // Có user nhưng chưa xác thực email -> Bắt ra ngoài
             await FirebaseAuth.instance.signOut();
             emit(AuthInitial()); 
        } else {
             // Đã ngon lành -> Vào thẳng Dashboard
             emit(AuthSuccess(user)); 
        }
      } else {
        // Chưa đăng nhập -> Ở lại màn hình Login
        emit(AuthInitial()); 
      }
    } catch (e) {
      emit(AuthInitial());
    }
  }

  // 6: ĐĂNG XUẤT (Sửa lỗi Google nhớ tài khoản cũ)
  Future<void> _onSignOutRequested(SignOutRequested event, Emitter<AuthState> emit) async {
    try {
      await signOutUseCase(); // Lệnh này sẽ xóa cả session Google
      emit(AuthInitial()); // Về màn hình đăng nhập
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}