import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInGoogleUseCase {
  final AuthRepository repository;

  SignInGoogleUseCase(this.repository);

  Future<UserEntity> call() {
    return repository.signInWithGoogle();
  }
}