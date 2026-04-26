import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/remote/geocoding_remote_data_source.dart';
import '../data/datasources/remote/osrm_remote_data_source.dart';
import '../data/datasources/remote/places_remote_data_source.dart';
import '../data/datasources/remote/room_remote_data_source.dart';
import 'infra_providers.dart';

final roomRemoteDataSourceProvider = Provider<RoomRemoteDataSource>((ref) {
  return RoomRemoteDataSource(ref.watch(firestoreProvider));
});

final geocodingRemoteDataSourceProvider = Provider<GeocodingRemoteDataSource>((
  ref,
) {
  return GeocodingRemoteDataSource(client: ref.watch(httpClientProvider));
});

final osrmRemoteDataSourceProvider = Provider<OsrmRemoteDataSource>((ref) {
  return OsrmRemoteDataSource(client: ref.watch(httpClientProvider));
});

final placesRemoteDataSourceProvider = Provider<PlacesRemoteDataSource>((ref) {
  return PlacesRemoteDataSource(client: ref.watch(httpClientProvider));
});
