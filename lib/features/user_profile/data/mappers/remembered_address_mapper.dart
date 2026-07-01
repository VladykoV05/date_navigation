import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/remembered_address.dart';

class RememberedAddressMapper {
  const RememberedAddressMapper._();

  static RememberedAddress fromDoc(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data();
    return RememberedAddress(
      id: doc.id,
      address: (data['address'] ?? '').toString().trim(),
      usesCount: (data['usesCount'] as num?)?.toInt() ?? 0,
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate(),
    );
  }
}
