import '../../../../core/error/result.dart';
import '../repositories/address_memory_repository.dart';

class RememberUserAddress {
  const RememberUserAddress(this._repo);

  final AddressMemoryRepository _repo;

  Future<Result<void>> call({required String userId, required String address}) {
    return _repo.rememberAddress(userId: userId, address: address);
  }
}

class RemoveRememberedUserAddress {
  const RemoveRememberedUserAddress(this._repo);

  final AddressMemoryRepository _repo;

  Future<Result<void>> call({required String userId, required String address}) {
    return _repo.removeRememberedAddress(userId: userId, address: address);
  }
}
