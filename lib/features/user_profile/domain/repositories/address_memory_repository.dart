import '../../../../core/error/result.dart';
import '../entities/remembered_address.dart';

abstract interface class AddressMemoryRepository {
  Stream<List<RememberedAddress>> watchFrequentAddresses({
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
