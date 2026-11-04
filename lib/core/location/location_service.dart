import '../error/result.dart';

enum LocationPermissionStatus {
  granted,
  denied,
  deniedForever,
  serviceDisabled,
}

class DeviceLocation {
  const DeviceLocation({
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
  });

  final double latitude;
  final double longitude;
  final double accuracyMeters;
}

abstract class LocationService {
  Future<LocationPermissionStatus> ensurePermission();
  Future<Result<DeviceLocation>> getCurrentLocation();
}
