import 'package:cloud_firestore/cloud_firestore.dart';

import '../repositories/user_address_memory_repository.dart';

class WatchFrequentAddresses {
  const WatchFrequentAddresses(this._repo);

  final UserAddressMemoryRepository _repo;

  Stream<QuerySnapshot<Map<String, dynamic>>> call({
    required String userId,
    int limit = 6,
  }) {
    return _repo.watchFrequentAddresses(userId: userId, limit: limit);
  }
}
