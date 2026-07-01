// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meeting_history_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MeetingHistoryItem {

 String get id; String get placeName; String? get placeAddress; String? get placeType; double? get lat; double? get lon; DateTime? get createdAt; String? get roomId; String? get counterpartyUid;
/// Create a copy of MeetingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingHistoryItemCopyWith<MeetingHistoryItem> get copyWith => _$MeetingHistoryItemCopyWithImpl<MeetingHistoryItem>(this as MeetingHistoryItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeAddress, placeAddress) || other.placeAddress == placeAddress)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.counterpartyUid, counterpartyUid) || other.counterpartyUid == counterpartyUid));
}


@override
int get hashCode => Object.hash(runtimeType,id,placeName,placeAddress,placeType,lat,lon,createdAt,roomId,counterpartyUid);

@override
String toString() {
  return 'MeetingHistoryItem(id: $id, placeName: $placeName, placeAddress: $placeAddress, placeType: $placeType, lat: $lat, lon: $lon, createdAt: $createdAt, roomId: $roomId, counterpartyUid: $counterpartyUid)';
}


}

/// @nodoc
abstract mixin class $MeetingHistoryItemCopyWith<$Res>  {
  factory $MeetingHistoryItemCopyWith(MeetingHistoryItem value, $Res Function(MeetingHistoryItem) _then) = _$MeetingHistoryItemCopyWithImpl;
@useResult
$Res call({
 String id, String placeName, String? placeAddress, String? placeType, double? lat, double? lon, DateTime? createdAt, String? roomId, String? counterpartyUid
});




}
/// @nodoc
class _$MeetingHistoryItemCopyWithImpl<$Res>
    implements $MeetingHistoryItemCopyWith<$Res> {
  _$MeetingHistoryItemCopyWithImpl(this._self, this._then);

  final MeetingHistoryItem _self;
  final $Res Function(MeetingHistoryItem) _then;

/// Create a copy of MeetingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? placeName = null,Object? placeAddress = freezed,Object? placeType = freezed,Object? lat = freezed,Object? lon = freezed,Object? createdAt = freezed,Object? roomId = freezed,Object? counterpartyUid = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,placeAddress: freezed == placeAddress ? _self.placeAddress : placeAddress // ignore: cast_nullable_to_non_nullable
as String?,placeType: freezed == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,counterpartyUid: freezed == counterpartyUid ? _self.counterpartyUid : counterpartyUid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingHistoryItem].
extension MeetingHistoryItemPatterns on MeetingHistoryItem {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingHistoryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingHistoryItem() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingHistoryItem value)  $default,){
final _that = this;
switch (_that) {
case _MeetingHistoryItem():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingHistoryItem value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingHistoryItem() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String placeName,  String? placeAddress,  String? placeType,  double? lat,  double? lon,  DateTime? createdAt,  String? roomId,  String? counterpartyUid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingHistoryItem() when $default != null:
return $default(_that.id,_that.placeName,_that.placeAddress,_that.placeType,_that.lat,_that.lon,_that.createdAt,_that.roomId,_that.counterpartyUid);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String placeName,  String? placeAddress,  String? placeType,  double? lat,  double? lon,  DateTime? createdAt,  String? roomId,  String? counterpartyUid)  $default,) {final _that = this;
switch (_that) {
case _MeetingHistoryItem():
return $default(_that.id,_that.placeName,_that.placeAddress,_that.placeType,_that.lat,_that.lon,_that.createdAt,_that.roomId,_that.counterpartyUid);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String placeName,  String? placeAddress,  String? placeType,  double? lat,  double? lon,  DateTime? createdAt,  String? roomId,  String? counterpartyUid)?  $default,) {final _that = this;
switch (_that) {
case _MeetingHistoryItem() when $default != null:
return $default(_that.id,_that.placeName,_that.placeAddress,_that.placeType,_that.lat,_that.lon,_that.createdAt,_that.roomId,_that.counterpartyUid);case _:
  return null;

}
}

}

/// @nodoc


class _MeetingHistoryItem implements MeetingHistoryItem {
  const _MeetingHistoryItem({required this.id, required this.placeName, this.placeAddress, this.placeType, this.lat, this.lon, this.createdAt, this.roomId, this.counterpartyUid});
  

@override final  String id;
@override final  String placeName;
@override final  String? placeAddress;
@override final  String? placeType;
@override final  double? lat;
@override final  double? lon;
@override final  DateTime? createdAt;
@override final  String? roomId;
@override final  String? counterpartyUid;

/// Create a copy of MeetingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingHistoryItemCopyWith<_MeetingHistoryItem> get copyWith => __$MeetingHistoryItemCopyWithImpl<_MeetingHistoryItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingHistoryItem&&(identical(other.id, id) || other.id == id)&&(identical(other.placeName, placeName) || other.placeName == placeName)&&(identical(other.placeAddress, placeAddress) || other.placeAddress == placeAddress)&&(identical(other.placeType, placeType) || other.placeType == placeType)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.counterpartyUid, counterpartyUid) || other.counterpartyUid == counterpartyUid));
}


@override
int get hashCode => Object.hash(runtimeType,id,placeName,placeAddress,placeType,lat,lon,createdAt,roomId,counterpartyUid);

@override
String toString() {
  return 'MeetingHistoryItem(id: $id, placeName: $placeName, placeAddress: $placeAddress, placeType: $placeType, lat: $lat, lon: $lon, createdAt: $createdAt, roomId: $roomId, counterpartyUid: $counterpartyUid)';
}


}

/// @nodoc
abstract mixin class _$MeetingHistoryItemCopyWith<$Res> implements $MeetingHistoryItemCopyWith<$Res> {
  factory _$MeetingHistoryItemCopyWith(_MeetingHistoryItem value, $Res Function(_MeetingHistoryItem) _then) = __$MeetingHistoryItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String placeName, String? placeAddress, String? placeType, double? lat, double? lon, DateTime? createdAt, String? roomId, String? counterpartyUid
});




}
/// @nodoc
class __$MeetingHistoryItemCopyWithImpl<$Res>
    implements _$MeetingHistoryItemCopyWith<$Res> {
  __$MeetingHistoryItemCopyWithImpl(this._self, this._then);

  final _MeetingHistoryItem _self;
  final $Res Function(_MeetingHistoryItem) _then;

/// Create a copy of MeetingHistoryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? placeName = null,Object? placeAddress = freezed,Object? placeType = freezed,Object? lat = freezed,Object? lon = freezed,Object? createdAt = freezed,Object? roomId = freezed,Object? counterpartyUid = freezed,}) {
  return _then(_MeetingHistoryItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,placeName: null == placeName ? _self.placeName : placeName // ignore: cast_nullable_to_non_nullable
as String,placeAddress: freezed == placeAddress ? _self.placeAddress : placeAddress // ignore: cast_nullable_to_non_nullable
as String?,placeType: freezed == placeType ? _self.placeType : placeType // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,counterpartyUid: freezed == counterpartyUid ? _self.counterpartyUid : counterpartyUid // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
