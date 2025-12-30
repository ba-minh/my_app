import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  // Gọi hàm này để gửi mail khôi phục
  Future<void> call(String email) {
    return repository.resetPassword(email);
  }
}