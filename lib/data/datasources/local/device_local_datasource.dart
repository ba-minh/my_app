import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/device_model.dart';

const String CACHED_DEVICES_KEY = 'CACHED_DEVICES_LIST';

abstract class DeviceLocalDataSource {
  Future<void> cacheDevices(List<DeviceModel> devices);
  Future<List<DeviceModel>> getLastDevices();
}

class DeviceLocalDataSourceImpl implements DeviceLocalDataSource {
  final SharedPreferences sharedPreferences;

  DeviceLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> cacheDevices(List<DeviceModel> devices) async {
    // Chuyển List Object -> Json String để lưu
    final List<Map<String, dynamic>> jsonList = 
        devices.map((device) => device.toJson()).toList();
    final String jsonString = json.encode(jsonList);
    
    await sharedPreferences.setString(CACHED_DEVICES_KEY, jsonString);
  }

  @override
  Future<List<DeviceModel>> getLastDevices() async {
    final jsonString = sharedPreferences.getString(CACHED_DEVICES_KEY);
    
    if (jsonString != null) {
      // Chuyển Json String -> List Object
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => DeviceModel.fromJson(json)).toList();
    } else {
      return []; // Trả về rỗng nếu chưa có dữ liệu cũ
    }
  }
}