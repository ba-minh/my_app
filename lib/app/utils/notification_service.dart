import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart'; // Để dùng kDebugMode

// 1. Hàm xử lý tin nhắn khi App đang tắt (Background/Terminated)
// BẮT BUỘC phải là top-level function (nằm ngoài class)
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("🌙 Nhận thông báo ngầm (Background): ${message.messageId}");
}

class NotificationService {
  // Singleton instance
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Hàm khởi tạo chính
  Future<void> init() async {
    // 1. Xin quyền thông báo (Quan trọng cho iOS & Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Người dùng đã cấp quyền thông báo');
      
      // 2. Lấy FCM Token (Vé mời)
      await _getToken();

      // 3. Đăng ký hàm xử lý khi App tắt
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      // 4. Lắng nghe khi App đang mở (Foreground)
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('☀️ Nhận thông báo khi mở App: ${message.notification?.title}');
        
        if (message.notification != null) {
          // TODO: Sau này sẽ hiện Dialog hoặc Snackbar ở đây
          print('Nội dung: ${message.notification?.body}');
        }
      });

    } else {
      print('❌ Người dùng từ chối quyền thông báo');
    }
  }

  // Hàm lấy Token
  Future<void> _getToken() async {
    try {
      String? token = await _messaging.getToken();
      if (token != null) {
        print('================================================');
        print('🎟️ FCM TOKEN CỦA BẠN (Copy cái này):');
        print(token);
        print('================================================');
        // TODO: Sau này sẽ gọi API gửi token này lên Server FastAPI
      }
    } catch (e) {
      print('❌ Lỗi lấy FCM Token: $e');
    }
  }
}