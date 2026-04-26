import '../datasources/remote/geocoding_remote_data_source.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/geocoding_repository.dart';

class GeocodingRepositoryImpl implements GeocodingRepository {
  final GeocodingRemoteDataSource _remote;
  GeocodingRepositoryImpl(this._remote);

  @override
  Future<Result<({double lat, double lon})?>> geocodeAddress(
    String address,
  ) async {
    return _remote.geocodeAddress(address);
  }
}
