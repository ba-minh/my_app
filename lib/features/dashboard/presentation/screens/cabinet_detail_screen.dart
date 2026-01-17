import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core_ui/theme/app_colors.dart';
// 👇 Import Entity
import '../../../../domain/entities/device_entity.dart'; 

import '../widgets/sensor_card.dart';
import '../widgets/io_device_card.dart';
import '../widgets/detail_app_bar.dart';
import '../widgets/dashboard_fab.dart';
import '../widgets/add_edit_device_sheet.dart'; 
import '../widgets/device_option_sheet.dart';   
import '../blocs/device_bloc.dart';

class CabinetDetailScreen extends StatefulWidget {
  // 👇 Thay đổi: Nhận vào cả Object Device thay vì chỉ tên
  final DeviceEntity device;
  
  const CabinetDetailScreen({super.key, required this.device});

  @override
  State<CabinetDetailScreen> createState() => _CabinetDetailScreenState();
}

class _CabinetDetailScreenState extends State<CabinetDetailScreen> {
  
  // 👇 INIT STATE: GỌI SỰ KIỆN SELECT DEVICE KHI MỞ MÀN HÌNH
  @override
  void initState() {
    super.initState();
    // Gửi dữ liệu tủ vừa chọn vào Bloc để Bloc tách (Mapping) ra Sensors và IO
    context.read<DeviceBloc>().add(SelectDevice(widget.device));
  }

  // --- LOGIC 1: MỞ FORM THÊM/SỬA ---
  void _openAddEditSheet({int? index, String? type}) {
    final state = context.read<DeviceBloc>().state;
    Map<String, dynamic>? currentData;
    if (index != null && type != null) {
      currentData = type == 'device' ? state.uiIODevices[index] : state.uiSensors[index];
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddEditDeviceSheet(
        index: index,
        data: currentData,
        onConfirm: (result) {
          final newData = result['data'];
          final resultType = result['type']; 

          if (index != null) {
            context.read<DeviceBloc>().add(UpdateDeviceItem(index: index, newData: newData, type: resultType));
          } else {
            if (resultType == 'device') {
              if (newData['name'] == "Đầu ra Mới") newData['name'] = "Đầu ra Mới";
            } else {
              if (newData['title'] == "Cảm biến Mới") newData['title'] = "Cảm biến Mới";
            }
            context.read<DeviceBloc>().add(AddDeviceItem(newData, resultType));
          }
        },
      ),
    );
  }

  // --- LOGIC 2: MENU TÙY CHỌN ---
  void _showOptions(int index, String type) {
    final state = context.read<DeviceBloc>().state;
    final bool isDevice = type == 'device';
    final name = isDevice ? state.uiIODevices[index]['name'] : state.uiSensors[index]['title'];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DeviceOptionSheet(
        name: name,
        onEdit: () => _openAddEditSheet(index: index, type: type),
        onDelete: () => _showDeleteConfirm(index, name, type),
      ),
    );
  }

  // --- LOGIC 3: XÁC NHẬN XÓA ---
  void _showDeleteConfirm(int index, String name, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận xóa"),
        content: Text("Bạn có chắc muốn xóa '$name'?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy", style: TextStyle(color: AppColors.grey))),
          TextButton(
            onPressed: () {
              context.read<DeviceBloc>().add(DeleteDeviceItem(index, type));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã xóa $name")));
            },
            child: const Text("Xóa", style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: DetailAppBar(title: widget.device.name),
      body: BlocListener<DeviceBloc, DeviceState>(
        listenWhen: (previous, current) =>
            previous.errorTimestamp != current.errorTimestamp,
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: AppColors.error,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<DeviceBloc, DeviceState>(
          builder: (context, state) {
            final sensors = state.uiSensors;
            final ioDevices = state.uiIODevices;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- SECTION: CẢM BIẾN ---
                  if (sensors.isNotEmpty) ...[
                    Text("Cảm biến môi trường",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: sensors.length,
                        itemBuilder: (context, index) {
                          final sensor = sensors[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: InkWell(
                              onLongPress: () => _showOptions(index, 'sensor'),
                              borderRadius: BorderRadius.circular(12),
                              child: SensorCard(
                                title: sensor['title'],
                                value: sensor['value'],
                                unit: sensor['unit'],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // --- SECTION: THIẾT BỊ I/O ---
                  if (ioDevices.isNotEmpty) ...[
                    Text("Thiết bị trong trang trại",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ioDevices.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.1,
                      ),
                      itemBuilder: (context, index) {
                        final device = ioDevices[index];
                        return InkWell(
                          onLongPress: () => _showOptions(index, 'device'),
                          borderRadius: BorderRadius.circular(20),
                          child: IODeviceCard(
                            name: device['name'],
                            isOn: device['isOn'],
                            deviceIcon: device['icon'] ?? Icons.devices,
                            onTap: () {
                              context
                                  .read<DeviceBloc>()
                                  .add(ToggleDeviceStatus(index));
                            },
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: DashboardFab(
        onPressed: () => _openAddEditSheet(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}