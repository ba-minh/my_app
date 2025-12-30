import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../domain/usecases/sign_in_usecase.dart';
import '../../../../domain/usecases/sign_up_usecase.dart'; 
import '../../../../domain/usecases/reset_password_usecase.dart'; 
import '../../../../app/utils/auth_error_translator.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;          
  final ResetPasswordUseCase resetPasswordUseCase; 

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,           // Nhận vào
    required this.resetPasswordUseCase,    // Nhận vào
  }) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<SignUpRequested>(_onSignUpRequested);
    on<ResetPasswordRequested>(_onResetPasswordRequested);
  }

  // 1. Xử lý Đăng nhập
  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      // 1. Gọi hàm đăng nhập như bình thường
      final userEntity = await signInUseCase(event.email, event.password);

      // 2. [QUAN TRỌNG] Kiểm tra kỹ lại trạng thái Email
      // Phải gọi instance trực tiếp để reload trạng thái mới nhất từ server
      final firebaseUser = FirebaseAuth.instance.currentUser;
      
      if (firebaseUser != null) {
        // Làm mới thông tin (đề phòng trường hợp vừa bấm link xong nhưng app chưa cập nhật)
        await firebaseUser.reload(); 
        
        if (!firebaseUser.emailVerified) {
          // 3. NẾU CHƯA XÁC THỰC:
          // - Đăng xuất ngay lập tức
          await FirebaseAuth.instance.signOut();
          // - Báo lỗi bắt đi xác thực
          emit(const AuthFailure("Email chưa được xác thực. Vui lòng kiểm tra hộp thư của bạn!"));
          return; // Dừng lại, không cho chạy xuống dưới nữa
        }
      }

      // 4. Nếu đã xác thực -> Cho vào Dashboard
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
      
      // Đăng ký xong -> KHÔNG vào Dashboard ngay
      // Mà báo lỗi (thực ra là thông báo) để UI hiện lên bắt check mail
      emit(const AuthFailure("Tài khoản đã tạo thành công! Vui lòng kiểm tra Email để xác thực trước khi đăng nhập."));
    } on FirebaseAuthException catch (e) {
       // Dịch lỗi tiếng Việt
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
      // Mẹo: Tạm dùng AuthFailure để hiện thông báo thành công (vì UI đang hiện SnackBar cho Failure)
      // Sau này ta sẽ làm chuẩn hơn.
      emit(const AuthFailure("Đã gửi email khôi phục! Vui lòng kiểm tra hộp thư."));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}