import 'dart:async';

import 'package:latlong2/latlong.dart' as latlong;

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../../core/services/analytics_service.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../user_profile/domain/usecases/remember_user_address.dart';
import '../../domain/usecases/geocode_address.dart';
import '../../domain/usecases/update_location.dart';

class AddressSubmissionCoordinator {
  const AddressSubmissionCoordinator({
    required GeocodeAddress geocodeAddress,
    required UpdateLocation updateLocation,
    required RememberUserAddress rememberAddress,
    required AnalyticsService analytics,
  }) : _geocodeAddress = geocodeAddress,
       _updateLocation = updateLocation,
       _rememberAddress = rememberAddress,
       _analytics = analytics;

  final GeocodeAddress _geocodeAddress;
  final UpdateLocation _updateLocation;
  final RememberUserAddress _rememberAddress;
  final AnalyticsService _analytics;

  Future<Result<void>> submitAddress({
    required String roomId,
    required String userId,
    required String address,
  }) async {
    final geocodeResult = await _geocodeAddress(address);
    switch (geocodeResult) {
      case Err(:final failure):
        unawaited(
          _analytics.operationFailed(
            operation: 'geocode_address',
            failureType: failure.runtimeType.toString(),
          ),
        );
        return Err(failure);
      case Ok(value: final coords):
        if (coords == null) {
          return const Err(UnknownFailure('Адрес не найден'));
        }
        final updateResult = await _updateLocation(
          roomId: roomId,
          userId: userId,
          coords: latlong.LatLng(coords.lat, coords.lon),
        );
        switch (updateResult) {
          case Err(:final failure):
            unawaited(
              _analytics.operationFailed(
                operation: 'update_location',
                failureType: failure.runtimeType.toString(),
              ),
            );
            return Err(failure);
          case Ok():
            final rememberResult = await _rememberAddress(
              userId: userId,
              address: address,
            );
            if (rememberResult case Err(:final failure)) {
              AppLogger.w('Remember address failed: ${failure.message}');
            }
            unawaited(_analytics.addressSubmitted());
            return const Ok(null);
        }
    }
  }
}
