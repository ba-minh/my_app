import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class IODeviceCard extends StatelessWidget {
  final String name;
  final bool isOn;
  final VoidCallback onTap;
  final IconData deviceIcon; // Icon minh họa thiết bị

  const IODeviceCard({
    super.key,
    required this.name,
    required this.isOn,
    required this.onTap,
    this.deviceIcon = Icons.devices, // Icon mặc định
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        // Viền xanh khi bật
        border: Border.all(
          color: isOn ? AppColors.primary : AppColors.transparent, 
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            // Đổ bóng xanh khi bật
            color: isOn 
                ? AppColors.primary.withOpacity(0.15) 
                : AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HÀNG TRÊN: ICON THIẾT BỊ & NÚT NGUỒN TRÒN ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // Căn lề trên
            children: [
              // 1. Icon thiết bị (Bên trái)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isOn ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  deviceIcon,
                  color: isOn ? AppColors.primary : AppColors.grey,
                  size: 24,
                ),
              ),

              // 2. Nút nguồn tròn (Bên phải - Code cũ của bạn)
              Material(
                color: AppColors.transparent,
                child: InkWell(
                  onTap: onTap,
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      // Logic màu: Bật -> Xanh, Tắt -> Xám nhạt
                      color: isOn ? AppColors.primary : AppColors.grey300,
                    ),
                    child: const Icon(
                      Icons.power_settings_new,
                      color: AppColors.white, // Icon nguồn luôn màu trắng cho nổi
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const Spacer(),
          
          // --- HÀNG DƯỚI: TÊN & TRẠNG THÁI ---
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16,
              color: AppColors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          
          // Dòng trạng thái text
          Text(
            isOn ? "Đang hoạt động" : "Đã tắt", 
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isOn ? AppColors.primary : AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}