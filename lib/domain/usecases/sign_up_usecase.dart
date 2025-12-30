import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  // Gọi hàm này để thực thi đăng ký
  Future<UserEntity> call(String email, String password) {
    return repository.signUp(email, password);
  }
}