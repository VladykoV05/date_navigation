import 'package:freezed_annotation/freezed_annotation.dart';

part 'remembered_address.freezed.dart';

@freezed
abstract class RememberedAddress with _$RememberedAddress {
  const factory RememberedAddress({
    required String id,
    required String address,
    @Default(0) int usesCount,
    DateTime? updatedAt,
  }) = _RememberedAddress;
}
