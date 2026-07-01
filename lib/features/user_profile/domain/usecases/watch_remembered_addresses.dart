import '../entities/remembered_address.dart';
import '../repositories/address_memory_repository.dart';

class WatchRememberedAddresses {
  const WatchRememberedAddresses(this._repo);

  final AddressMemoryRepository _repo;

  Stream<List<RememberedAddress>> call({
    required String userId,
    int limit = 6,
  }) {
    return _repo.watchFrequentAddresses(userId: userId, limit: limit);
  }
}
