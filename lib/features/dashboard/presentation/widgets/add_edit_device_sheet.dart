import 'package:flutter/material.dart';
import '../../../../core_ui/theme/app_colors.dart';

class AddEditDeviceSheet extends StatefulWidget {
  final Map<String, dynamic>? data; // Dữ liệu cũ (nếu sửa)
  final int? index; // Index (nếu sửa)
  final Function(Map<String, dynamic> newData) onConfirm; // Callback trả dữ liệu về

  const AddEditDeviceSheet({
    super.key,
    this.data,
    this.index,
    required this.onConfirm,
  });

  @override
  State<AddEditDeviceSheet> createState() => _AddEditDeviceSheetState();
}

class _AddEditDeviceSheetState extends State<AddEditDeviceSheet> {
  late TextEditingController _nameController;
  late String _selectedType;
  late String _selectedUnit;
  late IconData _selectedIcon;

  // Danh sách Icon mẫu
  final List<IconData> _deviceIcons = [
    Icons.lightbulb, Icons.water_drop, Icons.wind_power,
    Icons.tv, Icons.speaker, Icons.router, Icons.security, Icons.bolt,
  ];

  @override
  void initState() {
    super.initState();
    final isEditing = widget.index != null;
    _nameController = TextEditingController(
      text: isEditing ? (widget.data?['name'] ?? widget.data?['title']) : ''
    );
    _selectedType = isEditing 
        ? (widget.data!.containsKey('name') ? 'device' : 'sensor') 
        : 'device';
    _selectedUnit = widget.data?['unit'] ?? '°C';
    _selectedIcon = widget.data?['icon'] ?? _deviceIcons[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.index != null;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20, right: 20, top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? "Cài đặt thiết bị" : "Thêm thiết bị mới",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
          ),
          const SizedBox(height: 20),

          // 1. CHỌN LOẠI (Chỉ hiện khi Thêm mới)
          if (!isEditing) ...[
            const Text("Loại thiết bị:", style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildChip("Đầu ra / Relay", 'device'),
                const SizedBox(width: 10),
                _buildChip("Cảm biến", 'sensor'),
              ],
            ),
            const SizedBox(height: 20),
          ],

          // 2. NHẬP TÊN
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: "Tên hiển thị (Không bắt buộc)",
              hintText: _selectedType == 'device' ? "VD: Máy bơm 1..." : "VD: Cảm biến ánh sáng...",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          const SizedBox(height: 20),

          // 3. TÙY CHỌN RIÊNG
          if (_selectedType == 'device') 
            _buildIconSelector()
          else 
            _buildUnitSelector(),

          const SizedBox(height: 30),

          // 4. NÚT XÁC NHẬN
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Đóng gói dữ liệu trả về
                final Map<String, dynamic> result = {};
                String name = _nameController.text.trim();

                if (_selectedType == 'device') {
                  result['type'] = 'device';
                  result['data'] = {
                    'name': name.isEmpty ? "Đầu ra Mới" : name,
                    'isOn': isEditing ? widget.data!['isOn'] : false,
                    'icon': _selectedIcon,
                  };
                } else {
                  result['type'] = 'sensor';
                  result['data'] = {
                    'title': name.isEmpty ? "Cảm biến Mới" : name,
                    'value': isEditing ? widget.data!['value'] : '0',
                    'unit': _selectedUnit,
                  };
                }
                
                // Gọi callback để trả dữ liệu về màn hình cha
                widget.onConfirm(result);
                Navigator.pop(context);
              },
              child: Text(
                isEditing ? "Lưu thay đổi" : "Thêm ngay",
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Widget con: Chip chọn loại
  Widget _buildChip(String label, String value) {
    final isSelected = _selectedType == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(color: isSelected ? AppColors.primary : Colors.black),
      onSelected: (selected) => setState(() => _selectedType = value),
    );
  }

  // Widget con: Chọn Unit
  Widget _buildUnitSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Đơn vị đo:", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Row(
          children: [
            _buildUnitChip("Nhiệt độ (°C)", '°C'),
            const SizedBox(width: 10),
            _buildUnitChip("Độ ẩm (%)", '%'),
          ],
        ),
      ],
    );
  }

  Widget _buildUnitChip(String label, String value) {
    final isSelected = _selectedUnit == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (val) => setState(() => _selectedUnit = value),
      selectedColor: AppColors.primary.withOpacity(0.2),
      labelStyle: TextStyle(color: isSelected ? AppColors.primary : Colors.black),
    );
  }

  // Widget con: Chọn Icon
  Widget _buildIconSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Chọn biểu tượng:", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 15, runSpacing: 10,
          children: _deviceIcons.map((icon) {
            final isSelected = _selectedIcon == icon;
            return InkWell(
              onTap: () => setState(() => _selectedIcon = icon),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.grey[100],
                  shape: BoxShape.circle,
                  border: isSelected ? Border.all(color: AppColors.primary, width: 2) : null,
                ),
                child: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey, size: 24),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}