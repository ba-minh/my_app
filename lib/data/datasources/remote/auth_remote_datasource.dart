import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  // Thêm 2 dòng mới
  Future<UserModel> signUp(String email, String password);
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore});

  // 1. ĐĂNG NHẬP (Giữ nguyên logic cũ)
  @override
  Future<UserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    
    // Lấy thông tin từ kho Firestore
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data()!, user.uid);
    } else {
      // Nếu chưa có trong kho thì tạo tạm user viewer
      return UserModel(id: user.uid, email: email, role: 'viewer');
    }
  }

  // 2. ĐĂNG KÝ (MỚI TINH)
  @override
  Future<UserModel> signUp(String email, String password) async {
    // 1. Tạo tài khoản
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) throw Exception('Đăng ký thất bại');

    // --- ĐOẠN MỚI THÊM VÀO: GỬI MAIL XÁC THỰC ---
    await user.sendEmailVerification();
    // --------------------------------------------

    // 2. Lưu vào Firestore
    final newUser = UserModel(id: user.uid, email: email, role: 'user');
    await firestore.collection('users').doc(user.uid).set(newUser.toJson());

    return newUser;
  }

  // 3. QUÊN MẬT KHẨU (MỚI TINH)
  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}