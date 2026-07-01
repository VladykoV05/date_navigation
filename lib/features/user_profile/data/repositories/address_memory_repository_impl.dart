import '../../domain/entities/remembered_address.dart';
import '../../../../core/error/result.dart';
import '../../domain/repositories/address_memory_repository.dart';
import '../datasources/remote/user_address_memory_remote_data_source.dart';
import 'user_profile_firestore_guard.dart';

class AddressMemoryRepositoryImpl implements AddressMemoryRepository {
  const AddressMemoryRepositoryImpl(this._remote);

  final UserAddressMemoryRemoteDataSource _remote;

  @override
  Stream<List<RememberedAddress>> watchFrequentAddresses({
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
    return runUserProfileVoid(
      () => _remote.rememberAddress(userId: userId, address: address),
      fallback: 'Не удалось сохранить адрес',
    );
  }

  @override
  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    return runUserProfileVoid(
      () => _remote.removeRememberedAddress(userId: userId, address: address),
      fallback: 'Не удалось удалить адрес',
    );
  }
}
