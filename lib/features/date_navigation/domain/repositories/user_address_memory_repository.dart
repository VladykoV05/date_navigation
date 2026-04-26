import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/result.dart';

abstract interface class UserAddressMemoryRepository {
  Stream<QuerySnapshot<Map<String, dynamic>>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  });

  Future<Result<void>> rememberAddress({
    required String userId,
    required String address,
  });

  Future<Result<void>> removeRememberedAddress({
    required String userId,
    required String address,
  });
}
