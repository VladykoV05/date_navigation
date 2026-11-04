import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_codes.dart';
import '../../../../core/error/result.dart';
import '../../../../core/location/location_service.dart';
import '../../domain/usecases/update_location.dart';
import '../../domain/value_objects/geo_coordinate.dart';

class LocationSubmissionService {
  const LocationSubmissionService({
    required LocationService locationService,
    required UpdateLocation updateLocation,
  }) : _locationService = locationService,
       _updateLocation = updateLocation;

  final LocationService _locationService;
  final UpdateLocation _updateLocation;

  Future<Result<void>> submitCurrentLocation({
    required String roomId,
    required String userId,
  }) async {
    final permission = await _locationService.ensurePermission();
    switch (permission) {
      case LocationPermissionStatus.serviceDisabled:
        return const Err(UnknownFailure(FailureCodes.locationServiceDisabled));
      case LocationPermissionStatus.denied:
        return const Err(UnknownFailure(FailureCodes.locationPermissionDenied));
      case LocationPermissionStatus.deniedForever:
        return const Err(
          UnknownFailure(FailureCodes.locationPermissionDeniedForever),
        );
      case LocationPermissionStatus.granted:
        break;
    }

    final locationResult = await _locationService.getCurrentLocation();
    switch (locationResult) {
      case Err(:final failure):
        return Err(failure);
      case Ok(value: final location):
        final updateResult = await _updateLocation(
          roomId: roomId,
          userId: userId,
          coords: GeoCoordinate(
            latitude: location.latitude,
            longitude: location.longitude,
          ),
        );
        if (updateResult case Err(:final failure)) {
          return Err(failure);
        }
        return const Ok(null);
    }
  }
}
