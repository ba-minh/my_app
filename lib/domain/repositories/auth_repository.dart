import '../entities/user_entity.dart';

abstract class AuthRepository {
  // Hàm đăng nhập: Nhận email, pass -> Trả về UserEntity
  Future<UserEntity> signIn(String email, String password);

  // Hàm đăng xuất
  Future<void> signOut();
  
  // Hàm kiểm tra xem hiện tại có ai đang đăng nhập không
  Future<bool> isSignedIn();

  // 1. Đăng ký
  Future<UserEntity> signUp(String email, String password);

  // 2. Quên mật khẩu
  Future<void> resetPassword(String email);
}