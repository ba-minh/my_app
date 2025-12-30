import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  // Gọi hàm này để thực thi đăng nhập
  Future<UserEntity> call(String email, String password) async {
    return await repository.signIn(email, password);
  }
}