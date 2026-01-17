import 'package:flutter/material.dart';

class DeviceOptionSheet extends StatelessWidget {
  final String name;           // Tên thiết bị hiển thị trên đầu
  final VoidCallback onEdit;   // Hành động khi bấm "Cài đặt"
  final VoidCallback onDelete; // Hành động khi bấm "Xóa"

  const DeviceOptionSheet({
    super.key,
    required this.name,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Padding bottom để tránh bị sát cạnh dưới quá
      padding: const EdgeInsets.only(top: 20, bottom: 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Tiêu đề
          Text(
            name, 
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 10),
          const Divider(),
          
          // Nút Cài đặt
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blue),
            title: const Text("Cài đặt / Đổi tên"),
            onTap: () {
              Navigator.pop(context); // Đóng menu trước
              onEdit();               // Gọi hàm sửa ở màn hình cha
            },
          ),
          
          // Nút Xóa
          ListTile(
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text("Xóa thiết bị", style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context); // Đóng menu trước
              onDelete();             // Gọi hàm xóa ở màn hình cha
            },
          ),
        ],
      ),
    );
  }
}