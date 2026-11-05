import 'package:date_navigation/core/error/failure.dart';
import 'package:date_navigation/core/error/failure_codes.dart';
import 'package:date_navigation/core/error/result.dart';
import 'package:date_navigation/core/location/location_service.dart';
import 'package:date_navigation/features/date_navigation/application/services/location_submission_service.dart';
import 'package:date_navigation/features/date_navigation/domain/entities/room_snapshot.dart';
import 'package:date_navigation/features/date_navigation/domain/repositories/room_session_repository.dart';
import 'package:date_navigation/features/date_navigation/domain/usecases/update_location.dart';
import 'package:date_navigation/features/date_navigation/domain/value_objects/geo_coordinate.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeLocationService implements LocationService {
  _FakeLocationService({
    required this.permission,
    this.locationResult = const Ok(
      DeviceLocation(latitude: 53.9, longitude: 27.56, accuracyMeters: 5),
    ),
  });

  final LocationPermissionStatus permission;
  final Result<DeviceLocation> locationResult;

  @override
  Future<LocationPermissionStatus> ensurePermission() async => permission;

  @override
  Future<Result<DeviceLocation>> getCurrentLocation() async => locationResult;
}

class _FakeRoomSessionRepository implements RoomSessionRepository {
  _FakeRoomSessionRepository({this.updateResult = const Ok(null)});

  final Result<void> updateResult;
  GeoCoordinate? lastCoords;
  String? lastRoomId;
  String? lastUserId;

  @override
  Future<Result<void>> updateLocation({
    required String roomId,
    required String userId,
    required GeoCoordinate coords,
  }) async {
    lastRoomId = roomId;
    lastUserId = userId;
    lastCoords = coords;
    return updateResult;
  }

  @override
  Future<Result<String>> createOpenRoom({
    required String hostUid,
    required int capacity,
    RoomEventSnapshot? event,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> joinOpenRoom({
    required String roomId,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<List<RoomSnapshot>>> listOpenRooms({int limit = 20}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<String>> createRoom(String code, {String? createdBy}) {
    throw UnimplementedError();
  }

  @override
  Future<Result<String>> joinRoom({
    required String inviteCode,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> completeSession({
    required String roomId,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> leaveOpenRoom({
    required String roomId,
    required String userId,
  }) {
    throw UnimplementedError();
  }

  @override
  Stream<RoomSnapshot> watchRoom(String roomId) {
    throw UnimplementedError();
  }
}

LocationSubmissionService _buildService({
  required LocationPermissionStatus permission,
  Result<DeviceLocation> locationResult = const Ok(
    DeviceLocation(latitude: 53.9, longitude: 27.56, accuracyMeters: 5),
  ),
  Result<void> updateResult = const Ok(null),
  _FakeRoomSessionRepository? repository,
}) {
  return LocationSubmissionService(
    locationService: _FakeLocationService(
      permission: permission,
      locationResult: locationResult,
    ),
    updateLocation: UpdateLocation(
      repository ?? _FakeRoomSessionRepository(updateResult: updateResult),
    ),
  );
}

void main() {
  test('saves current location when permission is granted', () async {
    final repository = _FakeRoomSessionRepository();
    final service = _buildService(
      permission: LocationPermissionStatus.granted,
      repository: repository,
    );

    final result = await service.submitCurrentLocation(
      roomId: 'room-1',
      userId: 'user-1',
    );

    expect(result, isA<Ok<void>>());
    expect(repository.lastRoomId, 'room-1');
    expect(repository.lastUserId, 'user-1');
    expect(repository.lastCoords?.latitude, 53.9);
    expect(repository.lastCoords?.longitude, 27.56);
  });

  test('rejects when location service is disabled', () async {
    final service = _buildService(
      permission: LocationPermissionStatus.serviceDisabled,
    );

    final result = await service.submitCurrentLocation(
      roomId: 'room-1',
      userId: 'user-1',
    );

    expect(
      (result as Err<void>).failure.message,
      FailureCodes.locationServiceDisabled,
    );
  });

  test('rejects when permission is denied', () async {
    final service = _buildService(permission: LocationPermissionStatus.denied);

    final result = await service.submitCurrentLocation(
      roomId: 'room-1',
      userId: 'user-1',
    );

    expect(
      (result as Err<void>).failure.message,
      FailureCodes.locationPermissionDenied,
    );
  });

  test('rejects when permission is denied forever', () async {
    final service = _buildService(
      permission: LocationPermissionStatus.deniedForever,
    );

    final result = await service.submitCurrentLocation(
      roomId: 'room-1',
      userId: 'user-1',
    );

    expect(
      (result as Err<void>).failure.message,
      FailureCodes.locationPermissionDeniedForever,
    );
  });

  test('propagates location failure', () async {
    final service = _buildService(
      permission: LocationPermissionStatus.granted,
      locationResult: const Err(TimeoutFailure(FailureCodes.locationTimeout)),
    );

    final result = await service.submitCurrentLocation(
      roomId: 'room-1',
      userId: 'user-1',
    );

    expect((result as Err<void>).failure.message, FailureCodes.locationTimeout);
  });

  test('propagates update failure', () async {
    final service = _buildService(
      permission: LocationPermissionStatus.granted,
      updateResult: const Err(
        UnknownFailure(FailureCodes.updateLocationFailed),
      ),
    );

    final result = await service.submitCurrentLocation(
      roomId: 'room-1',
      userId: 'user-1',
    );

    expect(
      (result as Err<void>).failure.message,
      FailureCodes.updateLocationFailed,
    );
  });
}
