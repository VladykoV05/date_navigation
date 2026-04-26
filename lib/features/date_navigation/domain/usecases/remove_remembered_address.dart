import '../../../../core/error/result.dart';
import '../repositories/user_address_memory_repository.dart';

class RemoveRememberedAddress {
  const RemoveRememberedAddress(this._repo);

  final UserAddressMemoryRepository _repo;

  Future<Result<void>> call({required String userId, required String address}) {
    return _repo.removeRememberedAddress(userId: userId, address: address);
  }
}
