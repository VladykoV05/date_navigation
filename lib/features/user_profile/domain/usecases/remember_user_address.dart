import '../../../../core/error/result.dart';
import '../repositories/user_profile_repository.dart';

class RememberUserAddress {
  const RememberUserAddress(this._repo);

  final UserProfileRepository _repo;

  Future<Result<void>> call({required String userId, required String address}) {
    return _repo.rememberAddress(userId: userId, address: address);
  }
}

class RemoveRememberedUserAddress {
  const RemoveRememberedUserAddress(this._repo);

  final UserProfileRepository _repo;

  Future<Result<void>> call({required String userId, required String address}) {
    return _repo.removeRememberedAddress(userId: userId, address: address);
  }
}
