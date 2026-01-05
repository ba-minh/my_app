import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

import '../widgets/sensor_card.dart';
import '../widgets/io_device_card.dart';
import '../widgets/detail_app_bar.dart';
// 👇 Import DashboardFab để dùng nút to đẹp đồng bộ
import '../widgets/dashboard_fab.dart'; 

class CabinetDetailScreen extends StatefulWidget {
  final String cabinetName;

  const CabinetDetailScreen({super.key, required this.cabinetName});

  @override
  State<CabinetDetailScreen> createState() => _CabinetDetailScreenState();
}

class _CabinetDetailScreenState extends State<CabinetDetailScreen> {
  final List<Map<String, dynamic>> _ioDevices = [
    {'name': 'Đầu ra 1', 'isOn': false},
    {'name': 'Đầu ra 2', 'isOn': true},
    {'name': 'Đầu ra 3', 'isOn': false},
    {'name': 'Đầu ra 4', 'isOn': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      
      appBar: DetailAppBar(
        title: widget.cabinetName,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECTION: CẢM BIẾN
            const Text("Cảm biến môi trường", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  SensorCard(title: "Nhiệt độ (CB1)", value: "24", unit: "°C"),
                  SensorCard(title: "Nhiệt độ (CB2)", value: "29", unit: "°C"),
                  SensorCard(title: "Độ ẩm", value: "70", unit: "%"),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // SECTION: THIẾT BỊ IO
            const Text("Thiết bị trong trang trại", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _ioDevices.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemBuilder: (context, index) {
                return IODeviceCard(
                  name: _ioDevices[index]['name'],
                  isOn: _ioDevices[index]['isOn'],
                  onTap: () {
                    setState(() {
                      _ioDevices[index]['isOn'] = !_ioDevices[index]['isOn'];
                    });
                  },
                );
              },
            ),
            
            // Padding dưới để không bị FAB che mất
            const SizedBox(height: 100), 
          ],
        ),
      ),

      // 👇 Dùng DashboardFab thay vì nút mặc định để đồng bộ thiết kế
      floatingActionButton: DashboardFab(
        onPressed: () {
          setState(() {
            _ioDevices.add({'name': 'Đầu ra ${_ioDevices.length + 1}', 'isOn': false});
          });
        },
      ),
      
      // 👇 Vị trí đồng bộ: Góc dưới bên phải
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}