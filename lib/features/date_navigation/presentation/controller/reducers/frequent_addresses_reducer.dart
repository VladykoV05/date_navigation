import 'package:cloud_firestore/cloud_firestore.dart';

class FrequentAddressesReducer {
  const FrequentAddressesReducer();

  static const int _minUsesCount = 2;

  List<String> reduce(Iterable<Map<String, dynamic>> documents) {
    final scoredAddresses = documents
        .map((data) {
          final address = (data['address'] ?? '').toString().trim();
          final usesCount = (data['usesCount'] as num?)?.toInt() ?? 0;
          final updatedAt = data['updatedAt'];
          final updatedAtMs = updatedAt is Timestamp
              ? updatedAt.millisecondsSinceEpoch
              : 0;
          return (
            address: address,
            usesCount: usesCount,
            updatedAtMs: updatedAtMs,
          );
        })
        .where((item) => item.address.isNotEmpty && item.usesCount >= _minUsesCount)
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
