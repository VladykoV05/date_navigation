import '../../../user_profile/user_profile.dart';

class FrequentAddressesReducer {
  const FrequentAddressesReducer();

  static const int _minUsesCount = 2;

  List<String> reduce(Iterable<RememberedAddress> items) {
    final scoredAddresses =
        items
            .map((item) {
              final address = item.address.trim();
              final updatedAtMs = item.updatedAt?.millisecondsSinceEpoch ?? 0;
              return (
                address: address,
                usesCount: item.usesCount,
                updatedAtMs: updatedAtMs,
              );
            })
            .where(
              (item) =>
                  item.address.isNotEmpty && item.usesCount >= _minUsesCount,
            )
            .toList(growable: false)
          ..sort((a, b) {
            final usesCompare = b.usesCount.compareTo(a.usesCount);
            if (usesCompare != 0) return usesCompare;
            return b.updatedAtMs.compareTo(a.updatedAtMs);
          });

    final addresses = <String>[];
    for (final item in scoredAddresses) {
      if (addresses.contains(item.address)) continue;
      addresses.add(item.address);
    }
    return addresses;
  }
}
