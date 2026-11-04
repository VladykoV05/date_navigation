import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../error/failure.dart';
import '../error/failure_codes.dart';
import '../error/result.dart';
import 'location_service.dart';

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<LocationPermissionStatus> ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return LocationPermissionStatus.serviceDisabled;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    return switch (permission) {
      LocationPermission.always ||
      LocationPermission.whileInUse => LocationPermissionStatus.granted,
      LocationPermission.deniedForever =>
        LocationPermissionStatus.deniedForever,
      LocationPermission.denied ||
      LocationPermission.unableToDetermine => LocationPermissionStatus.denied,
    };
  }

  @override
  Future<Result<DeviceLocation>> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return Ok(
        DeviceLocation(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracyMeters: position.accuracy,
        ),
      );
    } on TimeoutException {
      return const Err(TimeoutFailure(FailureCodes.locationTimeout));
    } on LocationServiceDisabledException {
      return const Err(UnknownFailure(FailureCodes.locationServiceDisabled));
    } on PermissionDeniedException {
      return const Err(UnknownFailure(FailureCodes.locationPermissionDenied));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.locationUnavailable));
    }
  }
}
