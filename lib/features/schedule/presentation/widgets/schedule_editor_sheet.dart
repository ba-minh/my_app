import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../../core_ui/theme/app_colors.dart';
import '../../domain/entities/schedule_entity.dart';
import '../../../../domain/entities/device_entity.dart';

class ScheduleEditorSheet extends StatefulWidget {
  final DeviceEntity device; // Changed from deviceId
  final ScheduleEntity? schedule;
  final Function(ScheduleEntity) onSave;

  const ScheduleEditorSheet({
    super.key,
    required this.device,
    this.schedule,
    required this.onSave,
  });

  @override
  State<ScheduleEditorSheet> createState() => _ScheduleEditorSheetState();
}

class _ScheduleEditorSheetState extends State<ScheduleEditorSheet> {
  late TimeOfDay _selectedTime;
  late Set<int> _selectedDays;
  late bool _action;
  late int _selectedRelayIndex; // Track selected relay
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.schedule != null) {
      _selectedTime = TimeOfDay(
        hour: widget.schedule!.hour,
        minute: widget.schedule!.minute,
      );
      _selectedDays = Set.from(widget.schedule!.repeatDays);
      _action = widget.schedule!.action;
      _selectedRelayIndex = widget.schedule!.relayIndex;
      _nameController.text = widget.schedule!.name;
    } else {
      _selectedTime = const TimeOfDay(hour: 7, minute: 0);
      _selectedDays = {};
      _action = true;
      _selectedRelayIndex = 0; // Default to first relay
      _nameController.text = "";
    }
  }

  void _toggleDay(int day) {
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Generate list of available relays from device entity
    // Assuming device.relays is a list of current statuses, so length gives count.
    final int relayCount = widget.device.relays.length;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle Bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          
          Text(
            widget.schedule == null ? "Thêm Lịch Mới" : "Chỉnh Sửa Lịch",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),

          // Name Input
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: "Tên kịch bản (Ví dụ: Bật máy bơm)",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Relay Selector
          // Only show if device has more than 1 relay, accessing by index
          if (relayCount > 0) ...[
            const Text("Chọn đầu ra (Relay):", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: relayCount,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final isSelected = _selectedRelayIndex == index;
                  // Use custom name or default
                  final customName = (widget.device.relayNames.length > index && widget.device.relayNames[index].isNotEmpty)
                      ? widget.device.relayNames[index]
                      : "Đầu ra ${index + 1}";

                  return ChoiceChip(
                    label: Text(customName),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedRelayIndex = index;
                          // Auto update name if empty
                          if (_nameController.text.isEmpty) {
                            _nameController.text = _action
                              ? "Bật $customName"
                              : "Tắt $customName";
                          }
                        });
                      }
                    },
                    selectedColor: AppColors.primary.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.primary : Colors.black,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Time Picker
          SizedBox(
            height: 150,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.time,
              initialDateTime: DateTime(2023, 1, 1, _selectedTime.hour, _selectedTime.minute),
              onDateTimeChanged: (DateTime newTime) {
                setState(() {
                  _selectedTime = TimeOfDay.fromDateTime(newTime);
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // Day Selector
          const Text("Lặp lại:", style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final dayValue = index + 2; 
              final label = dayValue == 8 ? "CN" : "T$dayValue";
              final isSelected = _selectedDays.contains(dayValue);

              return GestureDetector(
                onTap: () => _toggleDay(dayValue),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Action Selector
          Row(
            children: [
              const Text("Hành động:", style: TextStyle(fontWeight: FontWeight.w600)),
              const Spacer(),
              SegmentedButton<bool>(
                segments: const [
                  ButtonSegment(
                    value: true,
                    label: Text("BẬT"),
                    icon: Icon(Icons.power_settings_new),
                  ),
                  ButtonSegment(
                    value: false,
                    label: Text("TẮT"),
                    icon: Icon(Icons.power_off),
                  ),
                ],
                selected: {_action},
                onSelectionChanged: (Set<bool> newSelection) {
                  setState(() {
                    _action = newSelection.first;
                  });
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return _action ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2);
                    }
                    return Colors.transparent;
                  }),
                  foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.selected)) {
                      return _action ? Colors.green : Colors.red;
                    }
                    return Colors.black;
                  }),
                ),
              ),
            ],
          ),
          const Spacer(),

          // Save Button
          ElevatedButton(
            onPressed: () {
              final newSchedule = ScheduleEntity(
                id: widget.schedule?.id ?? const Uuid().v4(),
                name: _nameController.text.isEmpty
                    ? (_action ? "Bật đầu ra ${_selectedRelayIndex + 1}" : "Tắt đầu ra ${_selectedRelayIndex + 1}")
                    : _nameController.text,
                deviceId: widget.device.id,
                relayIndex: _selectedRelayIndex,
                hour: _selectedTime.hour,
                minute: _selectedTime.minute,
                repeatDays: _selectedDays.toList(),
                action: _action,
                isEnabled: true,
              );
              widget.onSave(newSchedule);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("LƯU LẠI", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
