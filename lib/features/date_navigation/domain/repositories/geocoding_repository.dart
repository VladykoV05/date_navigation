import '../../../../core/error/result.dart';

abstract interface class GeocodingRepository {
  Future<Result<({double lat, double lon})?>> geocodeAddress(String address);
}
