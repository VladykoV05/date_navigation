import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../domain/entities/remembered_address.dart';
import '../../mappers/remembered_address_mapper.dart';

class UserAddressMemoryRemoteDataSource {
  const UserAddressMemoryRemoteDataSource(this._firestore);

  static const _usersCollection = 'users';
  static const _addressMemoryCollection = 'address_memory';

  final FirebaseFirestore _firestore;

  Stream<List<RememberedAddress>> watchFrequentAddresses({
    required String userId,
    int limit = 6,
  }) {
    return _userCollection(userId)
        .orderBy('updatedAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(RememberedAddressMapper.fromDoc)
              .where((item) => item.address.isNotEmpty)
              .toList(growable: false),
        );
  }

  Future<void> rememberAddress({
    required String userId,
    required String address,
  }) async {
    final normalizedAddress = address.trim();
    if (normalizedAddress.isEmpty) return;

    final userRef = _firestore.collection(_usersCollection).doc(userId);
    final addressRef = _userCollection(
      userId,
    ).doc(addressDocId(normalizedAddress));
    await userRef.set({
      'lastActivityAt': FieldValue.serverTimestamp(),
      'lastActivityType': 'address_remember',
    }, SetOptions(merge: true));
    await addressRef.set({
      'address': normalizedAddress,
      'usesCount': FieldValue.increment(1),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> removeRememberedAddress({
    required String userId,
    required String address,
  }) {
    final normalizedAddress = address.trim();
    if (normalizedAddress.isEmpty) return Future<void>.value();
    return _userCollection(
      userId,
    ).doc(addressDocId(normalizedAddress)).delete();
  }

  CollectionReference<Map<String, dynamic>> _userCollection(String userId) {
    return _firestore
        .collection(_usersCollection)
        .doc(userId)
        .collection(_addressMemoryCollection);
  }

  static String addressDocId(String address) {
    final normalized = address.toLowerCase();
    final sanitized = normalized.replaceAll(
      RegExp(r'[^a-z0-9а-яё]+', caseSensitive: false),
      '_',
    );
    return sanitized.isEmpty ? 'address_entry' : sanitized;
  }
}
