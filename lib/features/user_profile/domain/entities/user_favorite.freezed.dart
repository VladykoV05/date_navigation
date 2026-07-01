// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_favorite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$UserFavorite {

 String get id; String get name; String? get address; String? get type; double? get lat; double? get lon;
/// Create a copy of UserFavorite
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserFavoriteCopyWith<UserFavorite> get copyWith => _$UserFavoriteCopyWithImpl<UserFavorite>(this as UserFavorite, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserFavorite&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.type, type) || other.type == type)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,type,lat,lon);

@override
String toString() {
  return 'UserFavorite(id: $id, name: $name, address: $address, type: $type, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class $UserFavoriteCopyWith<$Res>  {
  factory $UserFavoriteCopyWith(UserFavorite value, $Res Function(UserFavorite) _then) = _$UserFavoriteCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, String? type, double? lat, double? lon
});




}
/// @nodoc
class _$UserFavoriteCopyWithImpl<$Res>
    implements $UserFavoriteCopyWith<$Res> {
  _$UserFavoriteCopyWithImpl(this._self, this._then);

  final UserFavorite _self;
  final $Res Function(UserFavorite) _then;

/// Create a copy of UserFavorite
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? type = freezed,Object? lat = freezed,Object? lon = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserFavorite].
extension UserFavoritePatterns on UserFavorite {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserFavorite value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserFavorite() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserFavorite value)  $default,){
final _that = this;
switch (_that) {
case _UserFavorite():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserFavorite value)?  $default,){
final _that = this;
switch (_that) {
case _UserFavorite() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String? type,  double? lat,  double? lon)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserFavorite() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.type,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String? type,  double? lat,  double? lon)  $default,) {final _that = this;
switch (_that) {
case _UserFavorite():
return $default(_that.id,_that.name,_that.address,_that.type,_that.lat,_that.lon);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  String? type,  double? lat,  double? lon)?  $default,) {final _that = this;
switch (_that) {
case _UserFavorite() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.type,_that.lat,_that.lon);case _:
  return null;

}
}

}

/// @nodoc


class _UserFavorite implements UserFavorite {
  const _UserFavorite({required this.id, required this.name, this.address, this.type, this.lat, this.lon});
  

@override final  String id;
@override final  String name;
@override final  String? address;
@override final  String? type;
@override final  double? lat;
@override final  double? lon;

/// Create a copy of UserFavorite
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserFavoriteCopyWith<_UserFavorite> get copyWith => __$UserFavoriteCopyWithImpl<_UserFavorite>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserFavorite&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.type, type) || other.type == type)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,address,type,lat,lon);

@override
String toString() {
  return 'UserFavorite(id: $id, name: $name, address: $address, type: $type, lat: $lat, lon: $lon)';
}


}

/// @nodoc
abstract mixin class _$UserFavoriteCopyWith<$Res> implements $UserFavoriteCopyWith<$Res> {
  factory _$UserFavoriteCopyWith(_UserFavorite value, $Res Function(_UserFavorite) _then) = __$UserFavoriteCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, String? type, double? lat, double? lon
});




}
/// @nodoc
class __$UserFavoriteCopyWithImpl<$Res>
    implements _$UserFavoriteCopyWith<$Res> {
  __$UserFavoriteCopyWithImpl(this._self, this._then);

  final _UserFavorite _self;
  final $Res Function(_UserFavorite) _then;

/// Create a copy of UserFavorite
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? type = freezed,Object? lat = freezed,Object? lon = freezed,}) {
  return _then(_UserFavorite(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
