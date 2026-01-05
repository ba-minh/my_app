import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class IODeviceCard extends StatelessWidget {
  final String name;
  final bool isOn;
  final VoidCallback onTap; // Hàm xử lý khi bấm nút

  const IODeviceCard({
    super.key,
    required this.name,
    required this.isOn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nút nguồn tròn (Custom theo thiết kế)
          Align(
            alignment: Alignment.topRight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: Ink(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // Logic màu: Bật -> Xanh, Tắt -> Xám nhạt
                    color: isOn ? AppColors.primary : const Color(0xFFE0E0E0),
                  ),
                  child: const Icon(
                    Icons.power_settings_new,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
          
          const Spacer(),
          
          // Tên thiết bị
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold, 
              fontSize: 16
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}