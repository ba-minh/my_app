import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  // Đăng nhập
  @override
  Future<UserEntity> signIn(String email, String password) async {
    return await remoteDataSource.signIn(email, password);
  }

  // Đăng ký (MỚI)
  @override
  Future<UserEntity> signUp(String email, String password) async {
    return await remoteDataSource.signUp(email, password);
  }

  // Quên mật khẩu (MỚI)
  @override
  Future<void> resetPassword(String email) async {
    return await remoteDataSource.resetPassword(email);
  }

  // Hai hàm phụ trợ (Tạm thời để trống hoặc false như cũ)
  @override
  Future<bool> isSignedIn() async => false; 

  @override
  Future<void> signOut() async {} 
}