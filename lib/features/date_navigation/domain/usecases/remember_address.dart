import '../../../../core/error/result.dart';
import '../repositories/user_address_memory_repository.dart';

class RememberAddress {
  const RememberAddress(this._repo);

  final UserAddressMemoryRepository _repo;

  Future<Result<void>> call({
    required String userId,
    required String address,
  }) {
    return _repo.rememberAddress(userId: userId, address: address);
  }
}
