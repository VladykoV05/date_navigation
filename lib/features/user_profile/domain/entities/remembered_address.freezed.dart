// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remembered_address.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RememberedAddress {

 String get id; String get address; int get usesCount; DateTime? get updatedAt;
/// Create a copy of RememberedAddress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RememberedAddressCopyWith<RememberedAddress> get copyWith => _$RememberedAddressCopyWithImpl<RememberedAddress>(this as RememberedAddress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RememberedAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.usesCount, usesCount) || other.usesCount == usesCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,address,usesCount,updatedAt);

@override
String toString() {
  return 'RememberedAddress(id: $id, address: $address, usesCount: $usesCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $RememberedAddressCopyWith<$Res>  {
  factory $RememberedAddressCopyWith(RememberedAddress value, $Res Function(RememberedAddress) _then) = _$RememberedAddressCopyWithImpl;
@useResult
$Res call({
 String id, String address, int usesCount, DateTime? updatedAt
});




}
/// @nodoc
class _$RememberedAddressCopyWithImpl<$Res>
    implements $RememberedAddressCopyWith<$Res> {
  _$RememberedAddressCopyWithImpl(this._self, this._then);

  final RememberedAddress _self;
  final $Res Function(RememberedAddress) _then;

/// Create a copy of RememberedAddress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? address = null,Object? usesCount = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,usesCount: null == usesCount ? _self.usesCount : usesCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [RememberedAddress].
extension RememberedAddressPatterns on RememberedAddress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RememberedAddress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RememberedAddress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RememberedAddress value)  $default,){
final _that = this;
switch (_that) {
case _RememberedAddress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RememberedAddress value)?  $default,){
final _that = this;
switch (_that) {
case _RememberedAddress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String address,  int usesCount,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RememberedAddress() when $default != null:
return $default(_that.id,_that.address,_that.usesCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String address,  int usesCount,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _RememberedAddress():
return $default(_that.id,_that.address,_that.usesCount,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String address,  int usesCount,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _RememberedAddress() when $default != null:
return $default(_that.id,_that.address,_that.usesCount,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _RememberedAddress implements RememberedAddress {
  const _RememberedAddress({required this.id, required this.address, this.usesCount = 0, this.updatedAt});
  

@override final  String id;
@override final  String address;
@override@JsonKey() final  int usesCount;
@override final  DateTime? updatedAt;

/// Create a copy of RememberedAddress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RememberedAddressCopyWith<_RememberedAddress> get copyWith => __$RememberedAddressCopyWithImpl<_RememberedAddress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RememberedAddress&&(identical(other.id, id) || other.id == id)&&(identical(other.address, address) || other.address == address)&&(identical(other.usesCount, usesCount) || other.usesCount == usesCount)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,address,usesCount,updatedAt);

@override
String toString() {
  return 'RememberedAddress(id: $id, address: $address, usesCount: $usesCount, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$RememberedAddressCopyWith<$Res> implements $RememberedAddressCopyWith<$Res> {
  factory _$RememberedAddressCopyWith(_RememberedAddress value, $Res Function(_RememberedAddress) _then) = __$RememberedAddressCopyWithImpl;
@override @useResult
$Res call({
 String id, String address, int usesCount, DateTime? updatedAt
});




}
/// @nodoc
class __$RememberedAddressCopyWithImpl<$Res>
    implements _$RememberedAddressCopyWith<$Res> {
  __$RememberedAddressCopyWithImpl(this._self, this._then);

  final _RememberedAddress _self;
  final $Res Function(_RememberedAddress) _then;

/// Create a copy of RememberedAddress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? address = null,Object? usesCount = null,Object? updatedAt = freezed,}) {
  return _then(_RememberedAddress(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,address: null == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String,usesCount: null == usesCount ? _self.usesCount : usesCount // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
