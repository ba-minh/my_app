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

  // Đăng ký
  @override
  Future<UserEntity> signUp(String email, String password) async {
    return await remoteDataSource.signUp(email, password);
  }

  // Quên mật khẩu
  @override
  Future<void> resetPassword(String email) async {
    return await remoteDataSource.resetPassword(email);
  }

  // Đăng nhập bằng Google
  @override
  Future<UserEntity> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  // 👇 ĐĂNG XUẤT (ĐÃ SỬA)
  // Gọi xuống DataSource để clear cả Google và Firebase
  @override
  Future<void> signOut() async {
    return await remoteDataSource.signOut();
  }

  // 👇 LẤY USER HIỆN TẠI (MỚI)
  @override
  Future<UserEntity?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  // Hàm phụ trợ cũ (giữ nguyên hoặc return false cũng được)
  @override
  Future<bool> isSignedIn() async => false; 
}