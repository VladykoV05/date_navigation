import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/datasources/remote/geocoding_remote_data_source.dart';
import '../data/datasources/remote/osrm_remote_data_source.dart';
import '../data/datasources/remote/places_remote_data_source.dart';
import '../data/datasources/remote/room_remote_data_source.dart';
import 'infra_providers.dart';

part 'data_providers.g.dart';

@Riverpod(keepAlive: true)
RoomRemoteDataSource roomRemoteDataSource(Ref ref) {
  return RoomRemoteDataSource(ref.watch(firestoreProvider));
}

@Riverpod(keepAlive: true)
GeocodingRemoteDataSource geocodingRemoteDataSource(Ref ref) {
  return GeocodingRemoteDataSource(client: ref.watch(httpClientProvider));
}

@Riverpod(keepAlive: true)
OsrmRemoteDataSource osrmRemoteDataSource(Ref ref) {
  return OsrmRemoteDataSource(client: ref.watch(httpClientProvider));
}

@Riverpod(keepAlive: true)
PlacesRemoteDataSource placesRemoteDataSource(Ref ref) {
  return PlacesRemoteDataSource(client: ref.watch(httpClientProvider));
}
