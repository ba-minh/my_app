import '../../domain/repositories/device_repository.dart';
import '../../domain/entities/device_entity.dart';

class UpdateDeviceUseCase {
  final DeviceRepository repository;

  UpdateDeviceUseCase(this.repository);

  Future<void> call(DeviceEntity device) {
    return repository.updateDevice(device);
  }
}
