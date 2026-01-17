import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Hàm đăng nhập
  Future<UserEntity> signIn(String email, String password);

  // Hàm đăng xuất
  Future<void> signOut();
  
  // Hàm kiểm tra xem hiện tại có ai đang đăng nhập không (Có thể dùng hoặc không)
  Future<bool> isSignedIn();

  // 1. Đăng ký
  Future<UserEntity> signUp(String email, String password);

  // 2. Quên mật khẩu
  Future<void> resetPassword(String email);

  // 3. Đăng nhập bằng Google
  Future<UserEntity> signInWithGoogle();

  // 👇 4. LẤY USER HIỆN TẠI (MỚI - Để kiểm tra tự động đăng nhập)
  Future<UserEntity?> getCurrentUser();
}