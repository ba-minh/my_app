import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/di/dependency_injection.dart';
import '../../../../core_ui/theme/app_colors.dart';
import '../../../schedule/domain/entities/schedule_entity.dart';
import '../../../schedule/presentation/blocs/schedule_bloc.dart';
import '../../../schedule/presentation/blocs/schedule_event.dart';
import '../../../schedule/presentation/blocs/schedule_state.dart';
import '../../../schedule/presentation/widgets/schedule_editor_sheet.dart';
import '../widgets/detail_app_bar.dart';
import '../widgets/dashboard_fab.dart';

import '../../../../domain/entities/device_entity.dart';
import '../blocs/device_bloc.dart';

class CabinetScheduleScreen extends StatelessWidget {
  final DeviceEntity device;

  const CabinetScheduleScreen({
    super.key,
    required this.device,
  });

  void _openEditor(BuildContext context, DeviceEntity device, {ScheduleEntity? schedule}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ScheduleEditorSheet(
        device: device,
        schedule: schedule,
        onSave: (newSchedule) {
          if (schedule == null) {
            context.read<ScheduleBloc>().add(AddSchedule(newSchedule));
          } else {
            context.read<ScheduleBloc>().add(UpdateSchedule(newSchedule));
          }
        },
      ),
    );
  }

  String _formatTime(int h, int m) {
    final tod = TimeOfDay(hour: h, minute: m);
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, h, m);
    // Format manually or use standard DateFormat if intl package is available.
    // Assuming no intl, let's manual format for AM/PM
    final period = h < 12 ? "AM" : "PM";
    final hour12 = h == 0 ? 12 : (h > 12 ? h - 12 : h);
    final minuteStr = m.toString().padLeft(2, '0');
    return "$hour12:$minuteStr $period";
  }

  String _formatDays(List<int> days) {
    if (days.length == 7) return "Mọi ngày";
    if (days.isEmpty) return "Một lần";
    // Sort and map 2->T2, 8->CN
    final sorted = List<int>.from(days)..sort();
    return sorted.map((d) => d == 8 ? "CN" : "T$d").join(", ");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ScheduleBloc>()..add(LoadSchedules(device.id)),
      child: Builder(
        builder: (context) {
          return BlocBuilder<DeviceBloc, DeviceState>(
            builder: (context, deviceState) {
              // 👇 LẤY DỮ LIỆU MỚI NHẤT TỪ BLOC (TRÁNH DỮ LIỆU CŨ TỪ NAVIGATION)
              // Tìm device trong list theo ID. Nếu không thấy (hiếm), dùng tạm widget.device
              final latestDevice = deviceState.userDevices.firstWhere(
                (d) => d.id == device.id, 
                orElse: () => device
              );

              return Scaffold(
                backgroundColor: AppColors.background,
                appBar: DetailAppBar(
                  title: "Lịch biểu: ${latestDevice.name}", // Update Title dynamically
                  showBackButton: true,
                ),
                floatingActionButton: DashboardFab(
                  onPressed: () => _openEditor(context, latestDevice), // Pass latest device
                ),
                body: BlocBuilder<ScheduleBloc, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ScheduleError) {
                      return Center(child: Text("Lỗi: ${state.message}"));
                    } else if (state is ScheduleLoaded) {
                      final schedules = state.schedules;
                      if (schedules.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_outlined,
                                  size: 80, color: Colors.grey[300]),
                              const SizedBox(height: 16),
                              const Text(
                                "Chưa có lịch hẹn nào",
                                style: TextStyle(color: Colors.grey, fontSize: 16),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: schedules.length,
                        itemBuilder: (ctx, index) {
                          final item = schedules[index];
                          return Dismissible(
                            key: Key(item.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.red,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              context.read<ScheduleBloc>().add(DeleteSchedule(item.id, latestDevice.id));
                            },
                            child: Opacity(
                              opacity: item.isEnabled ? 1.0 : 0.5,
                              child: Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: ListTile(
                                  onTap: () => _openEditor(context, latestDevice, schedule: item), // Pass latest device
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 4), 
                                  leading: Container(
                                    padding: const EdgeInsets.all(8), 
                                    decoration: BoxDecoration(
                                      color: item.action
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      item.action
                                          ? Icons.power_settings_new
                                          : Icons.power_off,
                                      color: item.action ? Colors.green : Colors.red,
                                      size: 24, 
                                    ),
                                  ),
                                  title: Row(
                                    crossAxisAlignment: CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        _formatTime(item.hour, item.minute).split(' ')[0],
                                        style: const TextStyle(
                                          fontSize: 22, 
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        _formatTime(item.hour, item.minute).split(' ')[1],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 4),
                                      Text(
                                        // 👇 USE latestDevice HERE
                                        (latestDevice.relayNames.length > item.relayIndex && latestDevice.relayNames[item.relayIndex].isNotEmpty) 
                                            ? latestDevice.relayNames[item.relayIndex] 
                                            : "Đầu ra ${item.relayIndex + 1}",
                                        style: const TextStyle(
                                          fontSize: 15, 
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            item.action ? "Bật" : "Tắt",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: item.action ? Colors.green : Colors.red,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Container(
                                            width: 1, 
                                            height: 12, 
                                            color: Colors.grey[300]
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            _formatDays(item.repeatDays),
                                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  trailing: Transform.scale(
                                    scale: 0.8, 
                                    child: Switch(
                                      value: item.isEnabled,
                                      activeColor: AppColors.primary,
                                      onChanged: (val) {
                                        final updated = item.copyWith(isEnabled: val);
                                        context.read<ScheduleBloc>().add(UpdateSchedule(updated));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              );
            }
          );
        }
      ),
    );
  }
}