import '../../../../core/error/result.dart';
import '../repositories/geocoding_repository.dart';

class GeocodeAddress {
  final GeocodingRepository _repo;
  const GeocodeAddress(this._repo);

  Future<Result<({double lat, double lon})?>> call(String address) {
    return _repo.geocodeAddress(address);
  }
}
