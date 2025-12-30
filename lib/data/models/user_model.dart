import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.role,
  });

  // Chuyển từ JSON (Firebase) sang Object (App)
  factory UserModel.fromJson(Map<String, dynamic> json, String uid) {
    return UserModel(
      id: uid,
      email: json['email'] ?? '',
      role: json['role'] ?? 'user', // Mặc định là user nếu chưa phân quyền
    );
  }

  // Chuyển từ Object (App) sang JSON (để gửi lên Firebase)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'role': role,
    };
  }
}