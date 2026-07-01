import '../entities/remembered_address.dart';
import '../repositories/user_profile_repository.dart';

class WatchRememberedAddresses {
  const WatchRememberedAddresses(this._repo);

  final UserProfileRepository _repo;

  Stream<List<RememberedAddress>> call({
    required String userId,
    int limit = 6,
  }) {
    return _repo.watchFrequentAddresses(userId: userId, limit: limit);
  }
}
