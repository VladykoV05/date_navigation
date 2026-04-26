import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/result.dart';
import '../../domain/repositories/user_address_memory_repository.dart';
import '../datasources/remote/room_remote_data_source.dart';

class UserAddressMemoryRepositoryImpl implements UserAddressMemoryRepository {
  UserAddressMemoryRepositoryImpl(this._remote);

  final RoomRemoteDataSource _remote;

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  }) {
    return _remote.watchFrequentAddresses(userId: userId, limit: limit);
  }

  @override
  Future<Result<void>> rememberAddress({
    required String userId,
    required String address,
  }) {
    return _remote.rememberAddress(userId: userId, address: address);
  }

  @override
  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    return _remote.removeRememberedAddress(userId: userId, address: address);
  }
}
