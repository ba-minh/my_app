import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Import thư viện quét mã
import '../../../../core_ui/theme/app_colors.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  // Controller để quản lý văn bản nhập vào
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _deviceIdController = TextEditingController();

  // Biến để quản lý trạng thái flash của camera (nếu cần)
  bool _isFlashOn = false;

  @override
  void dispose() {
    _nameController.dispose();
    _deviceIdController.dispose();
    super.dispose();
  }

  // Hàm mở giao diện quét QR
  void _openQRScanner() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: AppColors.black,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const Text("Quét mã QR trên tủ", style: TextStyle(color: AppColors.white)),
              centerTitle: true,
            ),
            Expanded(
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  for (final barcode in barcodes) {
                    if (barcode.rawValue != null) {
                      setState(() {
                        // Điền mã quét được vào ô nhập liệu
                        _deviceIdController.text = barcode.rawValue!;
                      });
                      // Đóng camera và thông báo thành công
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã tìm thấy thiết bị: ${barcode.rawValue}")),
                      );
                      break; // Chỉ lấy mã đầu tiên
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Di chuyển camera đến mã QR dán trên tủ điều khiển",
                style: TextStyle(color: AppColors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Thêm tủ điện mới",
            style: TextStyle(color: AppColors.black, fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- FORM NHẬP LIỆU ---
              const Text("Thông tin thiết bị",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.black87)),
              const SizedBox(height: 15),

              // 1. Ô nhập tên tủ
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Tên tủ điện (VD: Tủ vườn ươm 1)",
                  prefixIcon: const Icon(Icons.edit_note, color: AppColors.grey),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),
              const SizedBox(height: 20),

              // 2. Ô nhập mã ID + Nút quét QR
              TextField(
                controller: _deviceIdController,
                decoration: InputDecoration(
                  labelText: "Mã thiết bị (Device ID)",
                  hintText: "Nhập thủ công hoặc quét mã",
                  prefixIcon: const Icon(Icons.qr_code, color: AppColors.grey),
                  suffixIcon: IconButton(
                    onPressed: _openQRScanner, // Gọi hàm mở camera
                    icon: const Icon(Icons.center_focus_strong, color: AppColors.primary),
                    tooltip: "Quét mã QR",
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: AppColors.background,
                ),
              ),

              const Spacer(),

              // --- NÚT XÁC NHẬN ---
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate: Kiểm tra xem đã nhập đủ chưa
                    if (_nameController.text.isEmpty || _deviceIdController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Vui lòng nhập tên và mã thiết bị!")),
                      );
                      return;
                    }

                    // TRẢ VỀ DỮ LIỆU THỰC TẾ
                    Navigator.pop(context, {
                      'name': _nameController.text.trim(),
                      'deviceId': _deviceIdController.text.trim(),
                      'isOn': false, // Mặc định khi thêm mới là tắt
                      'icon': Icons.settings_input_component,
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Kết nối & Thêm",
                      style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}