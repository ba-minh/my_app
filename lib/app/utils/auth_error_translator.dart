class AuthErrorTranslator {
  static String translate(String code) {
    switch (code) {
      case 'user-not-found':
        return 'Tài khoản này không tồn tại.';
      case 'wrong-password':
        return 'Mật khẩu không chính xác.';
      case 'email-already-in-use':
        return 'Email này đã được đăng ký rồi.';
      case 'invalid-email':
        return 'Định dạng Email không hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu (cần ít nhất 6 ký tự).';
      case 'network-request-failed':
        return 'Không có kết nối mạng. Vui lòng kiểm tra lại.';
      case 'too-many-requests':
        return 'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau.';
      default:
        return 'Đã có lỗi xảy ra: $code'; // Hiện mã lỗi gốc nếu không biết dịch
    }
  }
}