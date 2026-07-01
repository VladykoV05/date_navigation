import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_favorite.freezed.dart';

@freezed
abstract class UserFavorite with _$UserFavorite {
  const factory UserFavorite({
    required String id,
    required String name,
    String? address,
    String? type,
    double? lat,
    double? lon,
  }) = _UserFavorite;
}
