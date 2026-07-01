import 'dart:async';

import '../../../user_profile/domain/entities/remembered_address.dart';
import '../../../user_profile/domain/usecases/watch_remembered_addresses.dart';
import 'reducers/frequent_addresses_reducer.dart';

class FrequentAddressesSubscriptionCoordinator {
  FrequentAddressesSubscriptionCoordinator({
    required WatchRememberedAddresses watchFrequentAddresses,
    FrequentAddressesReducer reducer = const FrequentAddressesReducer(),
  }) : _watchFrequentAddresses = watchFrequentAddresses,
       _reducer = reducer;

  final WatchRememberedAddresses _watchFrequentAddresses;
  final FrequentAddressesReducer _reducer;
  StreamSubscription<List<RememberedAddress>>? _subscription;

  void bind({
    required String? userId,
    int limit = 50,
    required void Function(List<String> addresses) onData,
  }) {
    _subscription?.cancel();
    if (userId == null || userId.isEmpty) {
      onData(const []);
      return;
    }
    _subscription = _watchFrequentAddresses(userId: userId, limit: limit)
        .listen(
          (items) => onData(_reducer.reduce(items)),
          onError: (Object _, StackTrace _) => onData(const []),
        );
  }

  Future<void> dispose() async {
    await _subscription?.cancel();
    _subscription = null;
  }
}
