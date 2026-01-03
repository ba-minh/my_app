import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // 1. CẤU HÌNH MÀU SẮC (ColorScheme)
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary, // Màu hạt giống (0xFF055B1D)
        primary: AppColors.primary,
        background: AppColors.background,
        error: AppColors.error,
        surface: AppColors.background, // Màu bề mặt (card, dialog)
      ),

      // 2. CẤU HÌNH MÀU NỀN SCAFFOLD
      scaffoldBackgroundColor: AppColors.background,

      // 3. CẤU HÌNH PHÔNG CHỮ (TEXT THEME)
      textTheme: GoogleFonts.interTextTheme(), 
      
      // 4. CẤU HÌNH APP BAR MẶC ĐỊNH
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white, // Màu chữ/icon trên AppBar
        elevation: 0,
        centerTitle: false,
      ),

      // 5. CẤU HÌNH NÚT BẤM (ElevatedButton)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0, 
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), 
          ),
          textStyle: GoogleFonts.inter( 
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      
      // 6. CẤU HÌNH NÚT TRÒN (FloatingActionButton)
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.primary,
        elevation: 2,
      ),

      // 7. CẤU HÌNH Ô NHẬP LIỆU (InputDecoration) - MỚI THÊM
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white, 
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
        
        // Viền khi bình thường (chưa bấm vào)
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        
        // Viền khi đang nhập (Focus) -> Màu Xanh chủ đạo
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        
        // Viền khi báo lỗi (Error) -> Màu Đỏ
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        
        // Viền khi đang nhập mà bị lỗi
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
    );
  }
}