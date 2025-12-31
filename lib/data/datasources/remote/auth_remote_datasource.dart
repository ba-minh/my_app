import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart'; // <--- 1. Import thư viện Google

import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> resetPassword(String email);
  Future<UserModel> signInWithGoogle(); // <--- 2. Khai báo hàm mới
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); // <--- 3. Khởi tạo GoogleSignIn

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

  // 2. ĐĂNG KÝ (Giữ nguyên logic cũ)
  @override
  Future<UserModel> signUp(String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) throw Exception('Đăng ký thất bại');

    // Gửi mail xác thực
    await user.sendEmailVerification();

    // Lưu vào Firestore
    final newUser = UserModel(id: user.uid, email: email, role: 'user');
    await firestore.collection('users').doc(user.uid).set(newUser.toJson());

    return newUser;
  }

  // 3. QUÊN MẬT KHẨU (Giữ nguyên logic cũ)
  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // 4. ĐĂNG NHẬP GOOGLE (MỚI TINH - Logic chuẩn v6.2.1)
  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // A. Mở cửa sổ đăng nhập Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Đã hủy đăng nhập Google'); // Người dùng tự tắt cửa sổ
      }

      // B. Lấy Token (Authentication)
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // C. Tạo Credential (Vé thông hành)
      // Ở bản 6.2.1, accessToken VẪN CÓ và hoạt động tốt -> Code này rất an toàn
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, 
        idToken: googleAuth.idToken,
      );

      // D. Đăng nhập vào Firebase bằng vé đó
      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      // E. Lưu/Lấy thông tin từ Firestore (Logic giống hàm signIn thường)
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!, user.uid);
      } else {
        // Nếu là user mới lần đầu login bằng Google -> Tạo mới trong Firestore
        final newUser = UserModel(
          id: user.uid, 
          email: user.email ?? "", 
          role: 'user'
        );
        await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      }
    } catch (e) {
      throw Exception(e.toString()); // Ném lỗi ra để Bloc bắt
    }
  }
}