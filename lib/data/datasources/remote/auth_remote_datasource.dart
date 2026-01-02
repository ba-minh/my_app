import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart'; 

import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(String email, String password);
  Future<void> resetPassword(String email);
  Future<UserModel> signInWithGoogle();
  
  // 👇 2 hàm mới thêm vào
  Future<void> signOut(); 
  Future<UserModel?> getCurrentUser(); 
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final GoogleSignIn _googleSignIn = GoogleSignIn(); 

  AuthRemoteDataSourceImpl({required this.firebaseAuth, required this.firestore});

  // 1. ĐĂNG NHẬP (Giữ nguyên)
  @override
  Future<UserModel> signIn(String email, String password) async {
    final userCredential = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    
    final userDoc = await firestore.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      return UserModel.fromJson(userDoc.data()!, user.uid);
    } else {
      return UserModel(id: user.uid, email: email, role: 'viewer');
    }
  }

  // 2. ĐĂNG KÝ (Giữ nguyên)
  @override
  Future<UserModel> signUp(String email, String password) async {
    final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user;
    if (user == null) throw Exception('Đăng ký thất bại');

    await user.sendEmailVerification();

    final newUser = UserModel(id: user.uid, email: email, role: 'user');
    await firestore.collection('users').doc(user.uid).set(newUser.toJson());

    return newUser;
  }

  // 3. QUÊN MẬT KHẨU (Giữ nguyên)
  @override
  Future<void> resetPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // 4. ĐĂNG NHẬP GOOGLE (Giữ nguyên)
  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Đã hủy đăng nhập Google'); 
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, 
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user!;

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!, user.uid);
      } else {
        final newUser = UserModel(
          id: user.uid, 
          email: user.email ?? "", 
          role: 'user'
        );
        await firestore.collection('users').doc(user.uid).set(newUser.toJson());
        return newUser;
      }
    } catch (e) {
      throw Exception(e.toString()); 
    }
  }

  // 👇 5. ĐĂNG XUẤT (MỚI - Sửa lỗi Google nhớ tài khoản cũ)
  @override
  Future<void> signOut() async {
    // Quan trọng: Đăng xuất Google trước để xóa cache tài khoản
    await _googleSignIn.signOut(); 
    // Sau đó đăng xuất Firebase
    await firebaseAuth.signOut();
  }

  // 👇 6. LẤY USER HIỆN TẠI (MỚI - Để tự động đăng nhập)
  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      // Nếu Firebase báo đã có người đăng nhập -> Lấy thông tin từ Firestore
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!, user.uid);
      }
    }
    return null; // Chưa đăng nhập
  }
}