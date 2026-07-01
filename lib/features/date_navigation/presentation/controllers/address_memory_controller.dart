import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';
import '../../../user_profile/user_profile.dart';

typedef AddressUserIdRequirement = String? Function(String operation);
typedef AddressFailureWriter = void Function(Failure failure, String operation);

class AddressMemoryController {
  const AddressMemoryController({
    required RemoveRememberedUserAddress removeRememberedAddress,
    required AddressUserIdRequirement requireUserId,
    required AddressFailureWriter setFailure,
    required void Function() clearFailure,
  }) : _removeRememberedAddress = removeRememberedAddress,
       _requireUserId = requireUserId,
       _setFailure = setFailure,
       _clearFailure = clearFailure;

  final RemoveRememberedUserAddress _removeRememberedAddress;
  final AddressUserIdRequirement _requireUserId;
  final AddressFailureWriter _setFailure;
  final void Function() _clearFailure;

  Future<void> removeRememberedAddress(String address) async {
    final uid = _requireUserId('address-memory');
    if (uid == null) return;
    final normalized = address.trim();
    if (normalized.isEmpty) return;
    final result = await _removeRememberedAddress(
      userId: uid,
      address: normalized,
    );
    if (result case Err(:final failure)) {
      _setFailure(failure, 'address-memory');
    } else {
      _clearFailure();
    }
  }

  Future<void> removeRememberedAddresses(Iterable<String> addresses) async {
    for (final address in addresses) {
      await removeRememberedAddress(address);
    }
  }
}
