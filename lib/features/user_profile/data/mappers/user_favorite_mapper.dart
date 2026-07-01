import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/user_favorite.dart';

class UserFavoriteMapper {
  const UserFavoriteMapper._();

  static UserFavorite fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return UserFavorite(
      id: doc.id,
      name: (data['placeName'] ?? '').toString(),
      address: data['placeAddress']?.toString(),
      type: data['placeType']?.toString(),
      lat: (data['lat'] as num?)?.toDouble(),
      lon: (data['lon'] as num?)?.toDouble(),
    );
  }
}
