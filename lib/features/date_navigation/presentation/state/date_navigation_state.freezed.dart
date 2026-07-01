// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'date_navigation_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RoomSessionState {

 String? get roomId; String? get inviteCode; bool get isCreator; latlong.LatLng? get point1; latlong.LatLng? get point2; SessionStatus get sessionStatus;
/// Create a copy of RoomSessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RoomSessionStateCopyWith<RoomSessionState> get copyWith => _$RoomSessionStateCopyWithImpl<RoomSessionState>(this as RoomSessionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RoomSessionState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator)&&(identical(other.point1, point1) || other.point1 == point1)&&(identical(other.point2, point2) || other.point2 == point2)&&(identical(other.sessionStatus, sessionStatus) || other.sessionStatus == sessionStatus));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,inviteCode,isCreator,point1,point2,sessionStatus);

@override
String toString() {
  return 'RoomSessionState(roomId: $roomId, inviteCode: $inviteCode, isCreator: $isCreator, point1: $point1, point2: $point2, sessionStatus: $sessionStatus)';
}


}

/// @nodoc
abstract mixin class $RoomSessionStateCopyWith<$Res>  {
  factory $RoomSessionStateCopyWith(RoomSessionState value, $Res Function(RoomSessionState) _then) = _$RoomSessionStateCopyWithImpl;
@useResult
$Res call({
 String? roomId, String? inviteCode, bool isCreator, latlong.LatLng? point1, latlong.LatLng? point2, SessionStatus sessionStatus
});




}
/// @nodoc
class _$RoomSessionStateCopyWithImpl<$Res>
    implements $RoomSessionStateCopyWith<$Res> {
  _$RoomSessionStateCopyWithImpl(this._self, this._then);

  final RoomSessionState _self;
  final $Res Function(RoomSessionState) _then;

/// Create a copy of RoomSessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = freezed,Object? inviteCode = freezed,Object? isCreator = null,Object? point1 = freezed,Object? point2 = freezed,Object? sessionStatus = null,}) {
  return _then(_self.copyWith(
roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,point1: freezed == point1 ? _self.point1 : point1 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,point2: freezed == point2 ? _self.point2 : point2 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,sessionStatus: null == sessionStatus ? _self.sessionStatus : sessionStatus // ignore: cast_nullable_to_non_nullable
as SessionStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [RoomSessionState].
extension RoomSessionStatePatterns on RoomSessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RoomSessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RoomSessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RoomSessionState value)  $default,){
final _that = this;
switch (_that) {
case _RoomSessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RoomSessionState value)?  $default,){
final _that = this;
switch (_that) {
case _RoomSessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? roomId,  String? inviteCode,  bool isCreator,  latlong.LatLng? point1,  latlong.LatLng? point2,  SessionStatus sessionStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RoomSessionState() when $default != null:
return $default(_that.roomId,_that.inviteCode,_that.isCreator,_that.point1,_that.point2,_that.sessionStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? roomId,  String? inviteCode,  bool isCreator,  latlong.LatLng? point1,  latlong.LatLng? point2,  SessionStatus sessionStatus)  $default,) {final _that = this;
switch (_that) {
case _RoomSessionState():
return $default(_that.roomId,_that.inviteCode,_that.isCreator,_that.point1,_that.point2,_that.sessionStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? roomId,  String? inviteCode,  bool isCreator,  latlong.LatLng? point1,  latlong.LatLng? point2,  SessionStatus sessionStatus)?  $default,) {final _that = this;
switch (_that) {
case _RoomSessionState() when $default != null:
return $default(_that.roomId,_that.inviteCode,_that.isCreator,_that.point1,_that.point2,_that.sessionStatus);case _:
  return null;

}
}

}

/// @nodoc


class _RoomSessionState extends RoomSessionState {
  const _RoomSessionState({this.roomId, this.inviteCode, this.isCreator = false, this.point1, this.point2, this.sessionStatus = SessionStatus.active}): super._();
  

@override final  String? roomId;
@override final  String? inviteCode;
@override@JsonKey() final  bool isCreator;
@override final  latlong.LatLng? point1;
@override final  latlong.LatLng? point2;
@override@JsonKey() final  SessionStatus sessionStatus;

/// Create a copy of RoomSessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RoomSessionStateCopyWith<_RoomSessionState> get copyWith => __$RoomSessionStateCopyWithImpl<_RoomSessionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RoomSessionState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator)&&(identical(other.point1, point1) || other.point1 == point1)&&(identical(other.point2, point2) || other.point2 == point2)&&(identical(other.sessionStatus, sessionStatus) || other.sessionStatus == sessionStatus));
}


@override
int get hashCode => Object.hash(runtimeType,roomId,inviteCode,isCreator,point1,point2,sessionStatus);

@override
String toString() {
  return 'RoomSessionState(roomId: $roomId, inviteCode: $inviteCode, isCreator: $isCreator, point1: $point1, point2: $point2, sessionStatus: $sessionStatus)';
}


}

/// @nodoc
abstract mixin class _$RoomSessionStateCopyWith<$Res> implements $RoomSessionStateCopyWith<$Res> {
  factory _$RoomSessionStateCopyWith(_RoomSessionState value, $Res Function(_RoomSessionState) _then) = __$RoomSessionStateCopyWithImpl;
@override @useResult
$Res call({
 String? roomId, String? inviteCode, bool isCreator, latlong.LatLng? point1, latlong.LatLng? point2, SessionStatus sessionStatus
});




}
/// @nodoc
class __$RoomSessionStateCopyWithImpl<$Res>
    implements _$RoomSessionStateCopyWith<$Res> {
  __$RoomSessionStateCopyWithImpl(this._self, this._then);

  final _RoomSessionState _self;
  final $Res Function(_RoomSessionState) _then;

/// Create a copy of RoomSessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = freezed,Object? inviteCode = freezed,Object? isCreator = null,Object? point1 = freezed,Object? point2 = freezed,Object? sessionStatus = null,}) {
  return _then(_RoomSessionState(
roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,point1: freezed == point1 ? _self.point1 : point1 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,point2: freezed == point2 ? _self.point2 : point2 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,sessionStatus: null == sessionStatus ? _self.sessionStatus : sessionStatus // ignore: cast_nullable_to_non_nullable
as SessionStatus,
  ));
}


}

/// @nodoc
mixin _$MeetingPlanningState {

 String? get finalChoiceName; Place? get finalChoicePlace; List<Place> get foundPlaces; List<Place> get filteredPlaces; latlong.LatLng? get centerPoint; List<latlong.LatLng> get routePoints; String? get selectedType; double get searchRadius; int? get creatorChangedRadiusTo; int? get peerSuggestedRadius; MeetingFormat? get peerSuggestedMeetingFormat; DateScenario? get selectedScenario; List<MeetingFormat> get creatorMeetingFormats; List<MeetingFormat> get partnerMeetingFormats; MeetingFormat? get creatorSelectedMeetingFormat; MeetingFormat? get partnerSelectedMeetingFormat; MeetingFormat? get selectedMeetingFormat; MeetingFormat? get lastAgreedMeetingFormat; List<DateScenario> get dateScenarios; String? get meetingRevoteRequestByRole; RevoteRequestStatus? get meetingRevoteRequestStatus;
/// Create a copy of MeetingPlanningState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MeetingPlanningStateCopyWith<MeetingPlanningState> get copyWith => _$MeetingPlanningStateCopyWithImpl<MeetingPlanningState>(this as MeetingPlanningState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MeetingPlanningState&&(identical(other.finalChoiceName, finalChoiceName) || other.finalChoiceName == finalChoiceName)&&(identical(other.finalChoicePlace, finalChoicePlace) || other.finalChoicePlace == finalChoicePlace)&&const DeepCollectionEquality().equals(other.foundPlaces, foundPlaces)&&const DeepCollectionEquality().equals(other.filteredPlaces, filteredPlaces)&&(identical(other.centerPoint, centerPoint) || other.centerPoint == centerPoint)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.searchRadius, searchRadius) || other.searchRadius == searchRadius)&&(identical(other.creatorChangedRadiusTo, creatorChangedRadiusTo) || other.creatorChangedRadiusTo == creatorChangedRadiusTo)&&(identical(other.peerSuggestedRadius, peerSuggestedRadius) || other.peerSuggestedRadius == peerSuggestedRadius)&&(identical(other.peerSuggestedMeetingFormat, peerSuggestedMeetingFormat) || other.peerSuggestedMeetingFormat == peerSuggestedMeetingFormat)&&(identical(other.selectedScenario, selectedScenario) || other.selectedScenario == selectedScenario)&&const DeepCollectionEquality().equals(other.creatorMeetingFormats, creatorMeetingFormats)&&const DeepCollectionEquality().equals(other.partnerMeetingFormats, partnerMeetingFormats)&&(identical(other.creatorSelectedMeetingFormat, creatorSelectedMeetingFormat) || other.creatorSelectedMeetingFormat == creatorSelectedMeetingFormat)&&(identical(other.partnerSelectedMeetingFormat, partnerSelectedMeetingFormat) || other.partnerSelectedMeetingFormat == partnerSelectedMeetingFormat)&&(identical(other.selectedMeetingFormat, selectedMeetingFormat) || other.selectedMeetingFormat == selectedMeetingFormat)&&(identical(other.lastAgreedMeetingFormat, lastAgreedMeetingFormat) || other.lastAgreedMeetingFormat == lastAgreedMeetingFormat)&&const DeepCollectionEquality().equals(other.dateScenarios, dateScenarios)&&(identical(other.meetingRevoteRequestByRole, meetingRevoteRequestByRole) || other.meetingRevoteRequestByRole == meetingRevoteRequestByRole)&&(identical(other.meetingRevoteRequestStatus, meetingRevoteRequestStatus) || other.meetingRevoteRequestStatus == meetingRevoteRequestStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,finalChoiceName,finalChoicePlace,const DeepCollectionEquality().hash(foundPlaces),const DeepCollectionEquality().hash(filteredPlaces),centerPoint,const DeepCollectionEquality().hash(routePoints),selectedType,searchRadius,creatorChangedRadiusTo,peerSuggestedRadius,peerSuggestedMeetingFormat,selectedScenario,const DeepCollectionEquality().hash(creatorMeetingFormats),const DeepCollectionEquality().hash(partnerMeetingFormats),creatorSelectedMeetingFormat,partnerSelectedMeetingFormat,selectedMeetingFormat,lastAgreedMeetingFormat,const DeepCollectionEquality().hash(dateScenarios),meetingRevoteRequestByRole,meetingRevoteRequestStatus]);

@override
String toString() {
  return 'MeetingPlanningState(finalChoiceName: $finalChoiceName, finalChoicePlace: $finalChoicePlace, foundPlaces: $foundPlaces, filteredPlaces: $filteredPlaces, centerPoint: $centerPoint, routePoints: $routePoints, selectedType: $selectedType, searchRadius: $searchRadius, creatorChangedRadiusTo: $creatorChangedRadiusTo, peerSuggestedRadius: $peerSuggestedRadius, peerSuggestedMeetingFormat: $peerSuggestedMeetingFormat, selectedScenario: $selectedScenario, creatorMeetingFormats: $creatorMeetingFormats, partnerMeetingFormats: $partnerMeetingFormats, creatorSelectedMeetingFormat: $creatorSelectedMeetingFormat, partnerSelectedMeetingFormat: $partnerSelectedMeetingFormat, selectedMeetingFormat: $selectedMeetingFormat, lastAgreedMeetingFormat: $lastAgreedMeetingFormat, dateScenarios: $dateScenarios, meetingRevoteRequestByRole: $meetingRevoteRequestByRole, meetingRevoteRequestStatus: $meetingRevoteRequestStatus)';
}


}

/// @nodoc
abstract mixin class $MeetingPlanningStateCopyWith<$Res>  {
  factory $MeetingPlanningStateCopyWith(MeetingPlanningState value, $Res Function(MeetingPlanningState) _then) = _$MeetingPlanningStateCopyWithImpl;
@useResult
$Res call({
 String? finalChoiceName, Place? finalChoicePlace, List<Place> foundPlaces, List<Place> filteredPlaces, latlong.LatLng? centerPoint, List<latlong.LatLng> routePoints, String? selectedType, double searchRadius, int? creatorChangedRadiusTo, int? peerSuggestedRadius, MeetingFormat? peerSuggestedMeetingFormat, DateScenario? selectedScenario, List<MeetingFormat> creatorMeetingFormats, List<MeetingFormat> partnerMeetingFormats, MeetingFormat? creatorSelectedMeetingFormat, MeetingFormat? partnerSelectedMeetingFormat, MeetingFormat? selectedMeetingFormat, MeetingFormat? lastAgreedMeetingFormat, List<DateScenario> dateScenarios, String? meetingRevoteRequestByRole, RevoteRequestStatus? meetingRevoteRequestStatus
});




}
/// @nodoc
class _$MeetingPlanningStateCopyWithImpl<$Res>
    implements $MeetingPlanningStateCopyWith<$Res> {
  _$MeetingPlanningStateCopyWithImpl(this._self, this._then);

  final MeetingPlanningState _self;
  final $Res Function(MeetingPlanningState) _then;

/// Create a copy of MeetingPlanningState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finalChoiceName = freezed,Object? finalChoicePlace = freezed,Object? foundPlaces = null,Object? filteredPlaces = null,Object? centerPoint = freezed,Object? routePoints = null,Object? selectedType = freezed,Object? searchRadius = null,Object? creatorChangedRadiusTo = freezed,Object? peerSuggestedRadius = freezed,Object? peerSuggestedMeetingFormat = freezed,Object? selectedScenario = freezed,Object? creatorMeetingFormats = null,Object? partnerMeetingFormats = null,Object? creatorSelectedMeetingFormat = freezed,Object? partnerSelectedMeetingFormat = freezed,Object? selectedMeetingFormat = freezed,Object? lastAgreedMeetingFormat = freezed,Object? dateScenarios = null,Object? meetingRevoteRequestByRole = freezed,Object? meetingRevoteRequestStatus = freezed,}) {
  return _then(_self.copyWith(
finalChoiceName: freezed == finalChoiceName ? _self.finalChoiceName : finalChoiceName // ignore: cast_nullable_to_non_nullable
as String?,finalChoicePlace: freezed == finalChoicePlace ? _self.finalChoicePlace : finalChoicePlace // ignore: cast_nullable_to_non_nullable
as Place?,foundPlaces: null == foundPlaces ? _self.foundPlaces : foundPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,filteredPlaces: null == filteredPlaces ? _self.filteredPlaces : filteredPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,centerPoint: freezed == centerPoint ? _self.centerPoint : centerPoint // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<latlong.LatLng>,selectedType: freezed == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String?,searchRadius: null == searchRadius ? _self.searchRadius : searchRadius // ignore: cast_nullable_to_non_nullable
as double,creatorChangedRadiusTo: freezed == creatorChangedRadiusTo ? _self.creatorChangedRadiusTo : creatorChangedRadiusTo // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedRadius: freezed == peerSuggestedRadius ? _self.peerSuggestedRadius : peerSuggestedRadius // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedMeetingFormat: freezed == peerSuggestedMeetingFormat ? _self.peerSuggestedMeetingFormat : peerSuggestedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,selectedScenario: freezed == selectedScenario ? _self.selectedScenario : selectedScenario // ignore: cast_nullable_to_non_nullable
as DateScenario?,creatorMeetingFormats: null == creatorMeetingFormats ? _self.creatorMeetingFormats : creatorMeetingFormats // ignore: cast_nullable_to_non_nullable
as List<MeetingFormat>,partnerMeetingFormats: null == partnerMeetingFormats ? _self.partnerMeetingFormats : partnerMeetingFormats // ignore: cast_nullable_to_non_nullable
as List<MeetingFormat>,creatorSelectedMeetingFormat: freezed == creatorSelectedMeetingFormat ? _self.creatorSelectedMeetingFormat : creatorSelectedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,partnerSelectedMeetingFormat: freezed == partnerSelectedMeetingFormat ? _self.partnerSelectedMeetingFormat : partnerSelectedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,selectedMeetingFormat: freezed == selectedMeetingFormat ? _self.selectedMeetingFormat : selectedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,lastAgreedMeetingFormat: freezed == lastAgreedMeetingFormat ? _self.lastAgreedMeetingFormat : lastAgreedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,dateScenarios: null == dateScenarios ? _self.dateScenarios : dateScenarios // ignore: cast_nullable_to_non_nullable
as List<DateScenario>,meetingRevoteRequestByRole: freezed == meetingRevoteRequestByRole ? _self.meetingRevoteRequestByRole : meetingRevoteRequestByRole // ignore: cast_nullable_to_non_nullable
as String?,meetingRevoteRequestStatus: freezed == meetingRevoteRequestStatus ? _self.meetingRevoteRequestStatus : meetingRevoteRequestStatus // ignore: cast_nullable_to_non_nullable
as RevoteRequestStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [MeetingPlanningState].
extension MeetingPlanningStatePatterns on MeetingPlanningState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MeetingPlanningState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MeetingPlanningState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MeetingPlanningState value)  $default,){
final _that = this;
switch (_that) {
case _MeetingPlanningState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MeetingPlanningState value)?  $default,){
final _that = this;
switch (_that) {
case _MeetingPlanningState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? finalChoiceName,  Place? finalChoicePlace,  List<Place> foundPlaces,  List<Place> filteredPlaces,  latlong.LatLng? centerPoint,  List<latlong.LatLng> routePoints,  String? selectedType,  double searchRadius,  int? creatorChangedRadiusTo,  int? peerSuggestedRadius,  MeetingFormat? peerSuggestedMeetingFormat,  DateScenario? selectedScenario,  List<MeetingFormat> creatorMeetingFormats,  List<MeetingFormat> partnerMeetingFormats,  MeetingFormat? creatorSelectedMeetingFormat,  MeetingFormat? partnerSelectedMeetingFormat,  MeetingFormat? selectedMeetingFormat,  MeetingFormat? lastAgreedMeetingFormat,  List<DateScenario> dateScenarios,  String? meetingRevoteRequestByRole,  RevoteRequestStatus? meetingRevoteRequestStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MeetingPlanningState() when $default != null:
return $default(_that.finalChoiceName,_that.finalChoicePlace,_that.foundPlaces,_that.filteredPlaces,_that.centerPoint,_that.routePoints,_that.selectedType,_that.searchRadius,_that.creatorChangedRadiusTo,_that.peerSuggestedRadius,_that.peerSuggestedMeetingFormat,_that.selectedScenario,_that.creatorMeetingFormats,_that.partnerMeetingFormats,_that.creatorSelectedMeetingFormat,_that.partnerSelectedMeetingFormat,_that.selectedMeetingFormat,_that.lastAgreedMeetingFormat,_that.dateScenarios,_that.meetingRevoteRequestByRole,_that.meetingRevoteRequestStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? finalChoiceName,  Place? finalChoicePlace,  List<Place> foundPlaces,  List<Place> filteredPlaces,  latlong.LatLng? centerPoint,  List<latlong.LatLng> routePoints,  String? selectedType,  double searchRadius,  int? creatorChangedRadiusTo,  int? peerSuggestedRadius,  MeetingFormat? peerSuggestedMeetingFormat,  DateScenario? selectedScenario,  List<MeetingFormat> creatorMeetingFormats,  List<MeetingFormat> partnerMeetingFormats,  MeetingFormat? creatorSelectedMeetingFormat,  MeetingFormat? partnerSelectedMeetingFormat,  MeetingFormat? selectedMeetingFormat,  MeetingFormat? lastAgreedMeetingFormat,  List<DateScenario> dateScenarios,  String? meetingRevoteRequestByRole,  RevoteRequestStatus? meetingRevoteRequestStatus)  $default,) {final _that = this;
switch (_that) {
case _MeetingPlanningState():
return $default(_that.finalChoiceName,_that.finalChoicePlace,_that.foundPlaces,_that.filteredPlaces,_that.centerPoint,_that.routePoints,_that.selectedType,_that.searchRadius,_that.creatorChangedRadiusTo,_that.peerSuggestedRadius,_that.peerSuggestedMeetingFormat,_that.selectedScenario,_that.creatorMeetingFormats,_that.partnerMeetingFormats,_that.creatorSelectedMeetingFormat,_that.partnerSelectedMeetingFormat,_that.selectedMeetingFormat,_that.lastAgreedMeetingFormat,_that.dateScenarios,_that.meetingRevoteRequestByRole,_that.meetingRevoteRequestStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? finalChoiceName,  Place? finalChoicePlace,  List<Place> foundPlaces,  List<Place> filteredPlaces,  latlong.LatLng? centerPoint,  List<latlong.LatLng> routePoints,  String? selectedType,  double searchRadius,  int? creatorChangedRadiusTo,  int? peerSuggestedRadius,  MeetingFormat? peerSuggestedMeetingFormat,  DateScenario? selectedScenario,  List<MeetingFormat> creatorMeetingFormats,  List<MeetingFormat> partnerMeetingFormats,  MeetingFormat? creatorSelectedMeetingFormat,  MeetingFormat? partnerSelectedMeetingFormat,  MeetingFormat? selectedMeetingFormat,  MeetingFormat? lastAgreedMeetingFormat,  List<DateScenario> dateScenarios,  String? meetingRevoteRequestByRole,  RevoteRequestStatus? meetingRevoteRequestStatus)?  $default,) {final _that = this;
switch (_that) {
case _MeetingPlanningState() when $default != null:
return $default(_that.finalChoiceName,_that.finalChoicePlace,_that.foundPlaces,_that.filteredPlaces,_that.centerPoint,_that.routePoints,_that.selectedType,_that.searchRadius,_that.creatorChangedRadiusTo,_that.peerSuggestedRadius,_that.peerSuggestedMeetingFormat,_that.selectedScenario,_that.creatorMeetingFormats,_that.partnerMeetingFormats,_that.creatorSelectedMeetingFormat,_that.partnerSelectedMeetingFormat,_that.selectedMeetingFormat,_that.lastAgreedMeetingFormat,_that.dateScenarios,_that.meetingRevoteRequestByRole,_that.meetingRevoteRequestStatus);case _:
  return null;

}
}

}

/// @nodoc


class _MeetingPlanningState extends MeetingPlanningState {
  const _MeetingPlanningState({this.finalChoiceName, this.finalChoicePlace, final  List<Place> foundPlaces = const [], final  List<Place> filteredPlaces = const [], this.centerPoint, final  List<latlong.LatLng> routePoints = const [], this.selectedType, this.searchRadius = 500.0, this.creatorChangedRadiusTo, this.peerSuggestedRadius, this.peerSuggestedMeetingFormat, this.selectedScenario, final  List<MeetingFormat> creatorMeetingFormats = const [], final  List<MeetingFormat> partnerMeetingFormats = const [], this.creatorSelectedMeetingFormat, this.partnerSelectedMeetingFormat, this.selectedMeetingFormat, this.lastAgreedMeetingFormat, final  List<DateScenario> dateScenarios = const [], this.meetingRevoteRequestByRole, this.meetingRevoteRequestStatus}): _foundPlaces = foundPlaces,_filteredPlaces = filteredPlaces,_routePoints = routePoints,_creatorMeetingFormats = creatorMeetingFormats,_partnerMeetingFormats = partnerMeetingFormats,_dateScenarios = dateScenarios,super._();
  

@override final  String? finalChoiceName;
@override final  Place? finalChoicePlace;
 final  List<Place> _foundPlaces;
@override@JsonKey() List<Place> get foundPlaces {
  if (_foundPlaces is EqualUnmodifiableListView) return _foundPlaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_foundPlaces);
}

 final  List<Place> _filteredPlaces;
@override@JsonKey() List<Place> get filteredPlaces {
  if (_filteredPlaces is EqualUnmodifiableListView) return _filteredPlaces;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredPlaces);
}

@override final  latlong.LatLng? centerPoint;
 final  List<latlong.LatLng> _routePoints;
@override@JsonKey() List<latlong.LatLng> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override final  String? selectedType;
@override@JsonKey() final  double searchRadius;
@override final  int? creatorChangedRadiusTo;
@override final  int? peerSuggestedRadius;
@override final  MeetingFormat? peerSuggestedMeetingFormat;
@override final  DateScenario? selectedScenario;
 final  List<MeetingFormat> _creatorMeetingFormats;
@override@JsonKey() List<MeetingFormat> get creatorMeetingFormats {
  if (_creatorMeetingFormats is EqualUnmodifiableListView) return _creatorMeetingFormats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_creatorMeetingFormats);
}

 final  List<MeetingFormat> _partnerMeetingFormats;
@override@JsonKey() List<MeetingFormat> get partnerMeetingFormats {
  if (_partnerMeetingFormats is EqualUnmodifiableListView) return _partnerMeetingFormats;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_partnerMeetingFormats);
}

@override final  MeetingFormat? creatorSelectedMeetingFormat;
@override final  MeetingFormat? partnerSelectedMeetingFormat;
@override final  MeetingFormat? selectedMeetingFormat;
@override final  MeetingFormat? lastAgreedMeetingFormat;
 final  List<DateScenario> _dateScenarios;
@override@JsonKey() List<DateScenario> get dateScenarios {
  if (_dateScenarios is EqualUnmodifiableListView) return _dateScenarios;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dateScenarios);
}

@override final  String? meetingRevoteRequestByRole;
@override final  RevoteRequestStatus? meetingRevoteRequestStatus;

/// Create a copy of MeetingPlanningState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MeetingPlanningStateCopyWith<_MeetingPlanningState> get copyWith => __$MeetingPlanningStateCopyWithImpl<_MeetingPlanningState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MeetingPlanningState&&(identical(other.finalChoiceName, finalChoiceName) || other.finalChoiceName == finalChoiceName)&&(identical(other.finalChoicePlace, finalChoicePlace) || other.finalChoicePlace == finalChoicePlace)&&const DeepCollectionEquality().equals(other._foundPlaces, _foundPlaces)&&const DeepCollectionEquality().equals(other._filteredPlaces, _filteredPlaces)&&(identical(other.centerPoint, centerPoint) || other.centerPoint == centerPoint)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.searchRadius, searchRadius) || other.searchRadius == searchRadius)&&(identical(other.creatorChangedRadiusTo, creatorChangedRadiusTo) || other.creatorChangedRadiusTo == creatorChangedRadiusTo)&&(identical(other.peerSuggestedRadius, peerSuggestedRadius) || other.peerSuggestedRadius == peerSuggestedRadius)&&(identical(other.peerSuggestedMeetingFormat, peerSuggestedMeetingFormat) || other.peerSuggestedMeetingFormat == peerSuggestedMeetingFormat)&&(identical(other.selectedScenario, selectedScenario) || other.selectedScenario == selectedScenario)&&const DeepCollectionEquality().equals(other._creatorMeetingFormats, _creatorMeetingFormats)&&const DeepCollectionEquality().equals(other._partnerMeetingFormats, _partnerMeetingFormats)&&(identical(other.creatorSelectedMeetingFormat, creatorSelectedMeetingFormat) || other.creatorSelectedMeetingFormat == creatorSelectedMeetingFormat)&&(identical(other.partnerSelectedMeetingFormat, partnerSelectedMeetingFormat) || other.partnerSelectedMeetingFormat == partnerSelectedMeetingFormat)&&(identical(other.selectedMeetingFormat, selectedMeetingFormat) || other.selectedMeetingFormat == selectedMeetingFormat)&&(identical(other.lastAgreedMeetingFormat, lastAgreedMeetingFormat) || other.lastAgreedMeetingFormat == lastAgreedMeetingFormat)&&const DeepCollectionEquality().equals(other._dateScenarios, _dateScenarios)&&(identical(other.meetingRevoteRequestByRole, meetingRevoteRequestByRole) || other.meetingRevoteRequestByRole == meetingRevoteRequestByRole)&&(identical(other.meetingRevoteRequestStatus, meetingRevoteRequestStatus) || other.meetingRevoteRequestStatus == meetingRevoteRequestStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,finalChoiceName,finalChoicePlace,const DeepCollectionEquality().hash(_foundPlaces),const DeepCollectionEquality().hash(_filteredPlaces),centerPoint,const DeepCollectionEquality().hash(_routePoints),selectedType,searchRadius,creatorChangedRadiusTo,peerSuggestedRadius,peerSuggestedMeetingFormat,selectedScenario,const DeepCollectionEquality().hash(_creatorMeetingFormats),const DeepCollectionEquality().hash(_partnerMeetingFormats),creatorSelectedMeetingFormat,partnerSelectedMeetingFormat,selectedMeetingFormat,lastAgreedMeetingFormat,const DeepCollectionEquality().hash(_dateScenarios),meetingRevoteRequestByRole,meetingRevoteRequestStatus]);

@override
String toString() {
  return 'MeetingPlanningState(finalChoiceName: $finalChoiceName, finalChoicePlace: $finalChoicePlace, foundPlaces: $foundPlaces, filteredPlaces: $filteredPlaces, centerPoint: $centerPoint, routePoints: $routePoints, selectedType: $selectedType, searchRadius: $searchRadius, creatorChangedRadiusTo: $creatorChangedRadiusTo, peerSuggestedRadius: $peerSuggestedRadius, peerSuggestedMeetingFormat: $peerSuggestedMeetingFormat, selectedScenario: $selectedScenario, creatorMeetingFormats: $creatorMeetingFormats, partnerMeetingFormats: $partnerMeetingFormats, creatorSelectedMeetingFormat: $creatorSelectedMeetingFormat, partnerSelectedMeetingFormat: $partnerSelectedMeetingFormat, selectedMeetingFormat: $selectedMeetingFormat, lastAgreedMeetingFormat: $lastAgreedMeetingFormat, dateScenarios: $dateScenarios, meetingRevoteRequestByRole: $meetingRevoteRequestByRole, meetingRevoteRequestStatus: $meetingRevoteRequestStatus)';
}


}

/// @nodoc
abstract mixin class _$MeetingPlanningStateCopyWith<$Res> implements $MeetingPlanningStateCopyWith<$Res> {
  factory _$MeetingPlanningStateCopyWith(_MeetingPlanningState value, $Res Function(_MeetingPlanningState) _then) = __$MeetingPlanningStateCopyWithImpl;
@override @useResult
$Res call({
 String? finalChoiceName, Place? finalChoicePlace, List<Place> foundPlaces, List<Place> filteredPlaces, latlong.LatLng? centerPoint, List<latlong.LatLng> routePoints, String? selectedType, double searchRadius, int? creatorChangedRadiusTo, int? peerSuggestedRadius, MeetingFormat? peerSuggestedMeetingFormat, DateScenario? selectedScenario, List<MeetingFormat> creatorMeetingFormats, List<MeetingFormat> partnerMeetingFormats, MeetingFormat? creatorSelectedMeetingFormat, MeetingFormat? partnerSelectedMeetingFormat, MeetingFormat? selectedMeetingFormat, MeetingFormat? lastAgreedMeetingFormat, List<DateScenario> dateScenarios, String? meetingRevoteRequestByRole, RevoteRequestStatus? meetingRevoteRequestStatus
});




}
/// @nodoc
class __$MeetingPlanningStateCopyWithImpl<$Res>
    implements _$MeetingPlanningStateCopyWith<$Res> {
  __$MeetingPlanningStateCopyWithImpl(this._self, this._then);

  final _MeetingPlanningState _self;
  final $Res Function(_MeetingPlanningState) _then;

/// Create a copy of MeetingPlanningState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finalChoiceName = freezed,Object? finalChoicePlace = freezed,Object? foundPlaces = null,Object? filteredPlaces = null,Object? centerPoint = freezed,Object? routePoints = null,Object? selectedType = freezed,Object? searchRadius = null,Object? creatorChangedRadiusTo = freezed,Object? peerSuggestedRadius = freezed,Object? peerSuggestedMeetingFormat = freezed,Object? selectedScenario = freezed,Object? creatorMeetingFormats = null,Object? partnerMeetingFormats = null,Object? creatorSelectedMeetingFormat = freezed,Object? partnerSelectedMeetingFormat = freezed,Object? selectedMeetingFormat = freezed,Object? lastAgreedMeetingFormat = freezed,Object? dateScenarios = null,Object? meetingRevoteRequestByRole = freezed,Object? meetingRevoteRequestStatus = freezed,}) {
  return _then(_MeetingPlanningState(
finalChoiceName: freezed == finalChoiceName ? _self.finalChoiceName : finalChoiceName // ignore: cast_nullable_to_non_nullable
as String?,finalChoicePlace: freezed == finalChoicePlace ? _self.finalChoicePlace : finalChoicePlace // ignore: cast_nullable_to_non_nullable
as Place?,foundPlaces: null == foundPlaces ? _self._foundPlaces : foundPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,filteredPlaces: null == filteredPlaces ? _self._filteredPlaces : filteredPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,centerPoint: freezed == centerPoint ? _self.centerPoint : centerPoint // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<latlong.LatLng>,selectedType: freezed == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String?,searchRadius: null == searchRadius ? _self.searchRadius : searchRadius // ignore: cast_nullable_to_non_nullable
as double,creatorChangedRadiusTo: freezed == creatorChangedRadiusTo ? _self.creatorChangedRadiusTo : creatorChangedRadiusTo // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedRadius: freezed == peerSuggestedRadius ? _self.peerSuggestedRadius : peerSuggestedRadius // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedMeetingFormat: freezed == peerSuggestedMeetingFormat ? _self.peerSuggestedMeetingFormat : peerSuggestedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,selectedScenario: freezed == selectedScenario ? _self.selectedScenario : selectedScenario // ignore: cast_nullable_to_non_nullable
as DateScenario?,creatorMeetingFormats: null == creatorMeetingFormats ? _self._creatorMeetingFormats : creatorMeetingFormats // ignore: cast_nullable_to_non_nullable
as List<MeetingFormat>,partnerMeetingFormats: null == partnerMeetingFormats ? _self._partnerMeetingFormats : partnerMeetingFormats // ignore: cast_nullable_to_non_nullable
as List<MeetingFormat>,creatorSelectedMeetingFormat: freezed == creatorSelectedMeetingFormat ? _self.creatorSelectedMeetingFormat : creatorSelectedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,partnerSelectedMeetingFormat: freezed == partnerSelectedMeetingFormat ? _self.partnerSelectedMeetingFormat : partnerSelectedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,selectedMeetingFormat: freezed == selectedMeetingFormat ? _self.selectedMeetingFormat : selectedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,lastAgreedMeetingFormat: freezed == lastAgreedMeetingFormat ? _self.lastAgreedMeetingFormat : lastAgreedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,dateScenarios: null == dateScenarios ? _self._dateScenarios : dateScenarios // ignore: cast_nullable_to_non_nullable
as List<DateScenario>,meetingRevoteRequestByRole: freezed == meetingRevoteRequestByRole ? _self.meetingRevoteRequestByRole : meetingRevoteRequestByRole // ignore: cast_nullable_to_non_nullable
as String?,meetingRevoteRequestStatus: freezed == meetingRevoteRequestStatus ? _self.meetingRevoteRequestStatus : meetingRevoteRequestStatus // ignore: cast_nullable_to_non_nullable
as RevoteRequestStatus?,
  ));
}


}

/// @nodoc
mixin _$VotingState {

 Map<String, String> get votesByUser; Map<String, int> get voteCounts; String? get proposalPlaceName; String? get proposalPlaceAddress; String? get proposalPlaceType; String? get proposalByRole; ProposalStatus? get proposalStatus;
/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VotingStateCopyWith<VotingState> get copyWith => _$VotingStateCopyWithImpl<VotingState>(this as VotingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VotingState&&const DeepCollectionEquality().equals(other.votesByUser, votesByUser)&&const DeepCollectionEquality().equals(other.voteCounts, voteCounts)&&(identical(other.proposalPlaceName, proposalPlaceName) || other.proposalPlaceName == proposalPlaceName)&&(identical(other.proposalPlaceAddress, proposalPlaceAddress) || other.proposalPlaceAddress == proposalPlaceAddress)&&(identical(other.proposalPlaceType, proposalPlaceType) || other.proposalPlaceType == proposalPlaceType)&&(identical(other.proposalByRole, proposalByRole) || other.proposalByRole == proposalByRole)&&(identical(other.proposalStatus, proposalStatus) || other.proposalStatus == proposalStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(votesByUser),const DeepCollectionEquality().hash(voteCounts),proposalPlaceName,proposalPlaceAddress,proposalPlaceType,proposalByRole,proposalStatus);

@override
String toString() {
  return 'VotingState(votesByUser: $votesByUser, voteCounts: $voteCounts, proposalPlaceName: $proposalPlaceName, proposalPlaceAddress: $proposalPlaceAddress, proposalPlaceType: $proposalPlaceType, proposalByRole: $proposalByRole, proposalStatus: $proposalStatus)';
}


}

/// @nodoc
abstract mixin class $VotingStateCopyWith<$Res>  {
  factory $VotingStateCopyWith(VotingState value, $Res Function(VotingState) _then) = _$VotingStateCopyWithImpl;
@useResult
$Res call({
 Map<String, String> votesByUser, Map<String, int> voteCounts, String? proposalPlaceName, String? proposalPlaceAddress, String? proposalPlaceType, String? proposalByRole, ProposalStatus? proposalStatus
});




}
/// @nodoc
class _$VotingStateCopyWithImpl<$Res>
    implements $VotingStateCopyWith<$Res> {
  _$VotingStateCopyWithImpl(this._self, this._then);

  final VotingState _self;
  final $Res Function(VotingState) _then;

/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? votesByUser = null,Object? voteCounts = null,Object? proposalPlaceName = freezed,Object? proposalPlaceAddress = freezed,Object? proposalPlaceType = freezed,Object? proposalByRole = freezed,Object? proposalStatus = freezed,}) {
  return _then(_self.copyWith(
votesByUser: null == votesByUser ? _self.votesByUser : votesByUser // ignore: cast_nullable_to_non_nullable
as Map<String, String>,voteCounts: null == voteCounts ? _self.voteCounts : voteCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,proposalPlaceName: freezed == proposalPlaceName ? _self.proposalPlaceName : proposalPlaceName // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceAddress: freezed == proposalPlaceAddress ? _self.proposalPlaceAddress : proposalPlaceAddress // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceType: freezed == proposalPlaceType ? _self.proposalPlaceType : proposalPlaceType // ignore: cast_nullable_to_non_nullable
as String?,proposalByRole: freezed == proposalByRole ? _self.proposalByRole : proposalByRole // ignore: cast_nullable_to_non_nullable
as String?,proposalStatus: freezed == proposalStatus ? _self.proposalStatus : proposalStatus // ignore: cast_nullable_to_non_nullable
as ProposalStatus?,
  ));
}

}


/// Adds pattern-matching-related methods to [VotingState].
extension VotingStatePatterns on VotingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VotingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VotingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VotingState value)  $default,){
final _that = this;
switch (_that) {
case _VotingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VotingState value)?  $default,){
final _that = this;
switch (_that) {
case _VotingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Map<String, String> votesByUser,  Map<String, int> voteCounts,  String? proposalPlaceName,  String? proposalPlaceAddress,  String? proposalPlaceType,  String? proposalByRole,  ProposalStatus? proposalStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VotingState() when $default != null:
return $default(_that.votesByUser,_that.voteCounts,_that.proposalPlaceName,_that.proposalPlaceAddress,_that.proposalPlaceType,_that.proposalByRole,_that.proposalStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Map<String, String> votesByUser,  Map<String, int> voteCounts,  String? proposalPlaceName,  String? proposalPlaceAddress,  String? proposalPlaceType,  String? proposalByRole,  ProposalStatus? proposalStatus)  $default,) {final _that = this;
switch (_that) {
case _VotingState():
return $default(_that.votesByUser,_that.voteCounts,_that.proposalPlaceName,_that.proposalPlaceAddress,_that.proposalPlaceType,_that.proposalByRole,_that.proposalStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Map<String, String> votesByUser,  Map<String, int> voteCounts,  String? proposalPlaceName,  String? proposalPlaceAddress,  String? proposalPlaceType,  String? proposalByRole,  ProposalStatus? proposalStatus)?  $default,) {final _that = this;
switch (_that) {
case _VotingState() when $default != null:
return $default(_that.votesByUser,_that.voteCounts,_that.proposalPlaceName,_that.proposalPlaceAddress,_that.proposalPlaceType,_that.proposalByRole,_that.proposalStatus);case _:
  return null;

}
}

}

/// @nodoc


class _VotingState implements VotingState {
  const _VotingState({final  Map<String, String> votesByUser = const {}, final  Map<String, int> voteCounts = const {}, this.proposalPlaceName, this.proposalPlaceAddress, this.proposalPlaceType, this.proposalByRole, this.proposalStatus}): _votesByUser = votesByUser,_voteCounts = voteCounts;
  

 final  Map<String, String> _votesByUser;
@override@JsonKey() Map<String, String> get votesByUser {
  if (_votesByUser is EqualUnmodifiableMapView) return _votesByUser;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_votesByUser);
}

 final  Map<String, int> _voteCounts;
@override@JsonKey() Map<String, int> get voteCounts {
  if (_voteCounts is EqualUnmodifiableMapView) return _voteCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_voteCounts);
}

@override final  String? proposalPlaceName;
@override final  String? proposalPlaceAddress;
@override final  String? proposalPlaceType;
@override final  String? proposalByRole;
@override final  ProposalStatus? proposalStatus;

/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VotingStateCopyWith<_VotingState> get copyWith => __$VotingStateCopyWithImpl<_VotingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VotingState&&const DeepCollectionEquality().equals(other._votesByUser, _votesByUser)&&const DeepCollectionEquality().equals(other._voteCounts, _voteCounts)&&(identical(other.proposalPlaceName, proposalPlaceName) || other.proposalPlaceName == proposalPlaceName)&&(identical(other.proposalPlaceAddress, proposalPlaceAddress) || other.proposalPlaceAddress == proposalPlaceAddress)&&(identical(other.proposalPlaceType, proposalPlaceType) || other.proposalPlaceType == proposalPlaceType)&&(identical(other.proposalByRole, proposalByRole) || other.proposalByRole == proposalByRole)&&(identical(other.proposalStatus, proposalStatus) || other.proposalStatus == proposalStatus));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_votesByUser),const DeepCollectionEquality().hash(_voteCounts),proposalPlaceName,proposalPlaceAddress,proposalPlaceType,proposalByRole,proposalStatus);

@override
String toString() {
  return 'VotingState(votesByUser: $votesByUser, voteCounts: $voteCounts, proposalPlaceName: $proposalPlaceName, proposalPlaceAddress: $proposalPlaceAddress, proposalPlaceType: $proposalPlaceType, proposalByRole: $proposalByRole, proposalStatus: $proposalStatus)';
}


}

/// @nodoc
abstract mixin class _$VotingStateCopyWith<$Res> implements $VotingStateCopyWith<$Res> {
  factory _$VotingStateCopyWith(_VotingState value, $Res Function(_VotingState) _then) = __$VotingStateCopyWithImpl;
@override @useResult
$Res call({
 Map<String, String> votesByUser, Map<String, int> voteCounts, String? proposalPlaceName, String? proposalPlaceAddress, String? proposalPlaceType, String? proposalByRole, ProposalStatus? proposalStatus
});




}
/// @nodoc
class __$VotingStateCopyWithImpl<$Res>
    implements _$VotingStateCopyWith<$Res> {
  __$VotingStateCopyWithImpl(this._self, this._then);

  final _VotingState _self;
  final $Res Function(_VotingState) _then;

/// Create a copy of VotingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? votesByUser = null,Object? voteCounts = null,Object? proposalPlaceName = freezed,Object? proposalPlaceAddress = freezed,Object? proposalPlaceType = freezed,Object? proposalByRole = freezed,Object? proposalStatus = freezed,}) {
  return _then(_VotingState(
votesByUser: null == votesByUser ? _self._votesByUser : votesByUser // ignore: cast_nullable_to_non_nullable
as Map<String, String>,voteCounts: null == voteCounts ? _self._voteCounts : voteCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,proposalPlaceName: freezed == proposalPlaceName ? _self.proposalPlaceName : proposalPlaceName // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceAddress: freezed == proposalPlaceAddress ? _self.proposalPlaceAddress : proposalPlaceAddress // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceType: freezed == proposalPlaceType ? _self.proposalPlaceType : proposalPlaceType // ignore: cast_nullable_to_non_nullable
as String?,proposalByRole: freezed == proposalByRole ? _self.proposalByRole : proposalByRole // ignore: cast_nullable_to_non_nullable
as String?,proposalStatus: freezed == proposalStatus ? _self.proposalStatus : proposalStatus // ignore: cast_nullable_to_non_nullable
as ProposalStatus?,
  ));
}


}

/// @nodoc
mixin _$AddressMemoryState {

 List<String> get recentAddresses;
/// Create a copy of AddressMemoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddressMemoryStateCopyWith<AddressMemoryState> get copyWith => _$AddressMemoryStateCopyWithImpl<AddressMemoryState>(this as AddressMemoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddressMemoryState&&const DeepCollectionEquality().equals(other.recentAddresses, recentAddresses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(recentAddresses));

@override
String toString() {
  return 'AddressMemoryState(recentAddresses: $recentAddresses)';
}


}

/// @nodoc
abstract mixin class $AddressMemoryStateCopyWith<$Res>  {
  factory $AddressMemoryStateCopyWith(AddressMemoryState value, $Res Function(AddressMemoryState) _then) = _$AddressMemoryStateCopyWithImpl;
@useResult
$Res call({
 List<String> recentAddresses
});




}
/// @nodoc
class _$AddressMemoryStateCopyWithImpl<$Res>
    implements $AddressMemoryStateCopyWith<$Res> {
  _$AddressMemoryStateCopyWithImpl(this._self, this._then);

  final AddressMemoryState _self;
  final $Res Function(AddressMemoryState) _then;

/// Create a copy of AddressMemoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? recentAddresses = null,}) {
  return _then(_self.copyWith(
recentAddresses: null == recentAddresses ? _self.recentAddresses : recentAddresses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AddressMemoryState].
extension AddressMemoryStatePatterns on AddressMemoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddressMemoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddressMemoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddressMemoryState value)  $default,){
final _that = this;
switch (_that) {
case _AddressMemoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddressMemoryState value)?  $default,){
final _that = this;
switch (_that) {
case _AddressMemoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<String> recentAddresses)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddressMemoryState() when $default != null:
return $default(_that.recentAddresses);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<String> recentAddresses)  $default,) {final _that = this;
switch (_that) {
case _AddressMemoryState():
return $default(_that.recentAddresses);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<String> recentAddresses)?  $default,) {final _that = this;
switch (_that) {
case _AddressMemoryState() when $default != null:
return $default(_that.recentAddresses);case _:
  return null;

}
}

}

/// @nodoc


class _AddressMemoryState implements AddressMemoryState {
  const _AddressMemoryState({final  List<String> recentAddresses = const []}): _recentAddresses = recentAddresses;
  

 final  List<String> _recentAddresses;
@override@JsonKey() List<String> get recentAddresses {
  if (_recentAddresses is EqualUnmodifiableListView) return _recentAddresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentAddresses);
}


/// Create a copy of AddressMemoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddressMemoryStateCopyWith<_AddressMemoryState> get copyWith => __$AddressMemoryStateCopyWithImpl<_AddressMemoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddressMemoryState&&const DeepCollectionEquality().equals(other._recentAddresses, _recentAddresses));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_recentAddresses));

@override
String toString() {
  return 'AddressMemoryState(recentAddresses: $recentAddresses)';
}


}

/// @nodoc
abstract mixin class _$AddressMemoryStateCopyWith<$Res> implements $AddressMemoryStateCopyWith<$Res> {
  factory _$AddressMemoryStateCopyWith(_AddressMemoryState value, $Res Function(_AddressMemoryState) _then) = __$AddressMemoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<String> recentAddresses
});




}
/// @nodoc
class __$AddressMemoryStateCopyWithImpl<$Res>
    implements _$AddressMemoryStateCopyWith<$Res> {
  __$AddressMemoryStateCopyWithImpl(this._self, this._then);

  final _AddressMemoryState _self;
  final $Res Function(_AddressMemoryState) _then;

/// Create a copy of AddressMemoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? recentAddresses = null,}) {
  return _then(_AddressMemoryState(
recentAddresses: null == recentAddresses ? _self._recentAddresses : recentAddresses // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

/// @nodoc
mixin _$DateNavigationUiState {

 bool get isLoadingRoomAction; bool get isGeocoding; bool get isCalculatingMeeting; Failure? get lastFailure; String? get failureOperation;
/// Create a copy of DateNavigationUiState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateNavigationUiStateCopyWith<DateNavigationUiState> get copyWith => _$DateNavigationUiStateCopyWithImpl<DateNavigationUiState>(this as DateNavigationUiState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateNavigationUiState&&(identical(other.isLoadingRoomAction, isLoadingRoomAction) || other.isLoadingRoomAction == isLoadingRoomAction)&&(identical(other.isGeocoding, isGeocoding) || other.isGeocoding == isGeocoding)&&(identical(other.isCalculatingMeeting, isCalculatingMeeting) || other.isCalculatingMeeting == isCalculatingMeeting)&&(identical(other.lastFailure, lastFailure) || other.lastFailure == lastFailure)&&(identical(other.failureOperation, failureOperation) || other.failureOperation == failureOperation));
}


@override
int get hashCode => Object.hash(runtimeType,isLoadingRoomAction,isGeocoding,isCalculatingMeeting,lastFailure,failureOperation);

@override
String toString() {
  return 'DateNavigationUiState(isLoadingRoomAction: $isLoadingRoomAction, isGeocoding: $isGeocoding, isCalculatingMeeting: $isCalculatingMeeting, lastFailure: $lastFailure, failureOperation: $failureOperation)';
}


}

/// @nodoc
abstract mixin class $DateNavigationUiStateCopyWith<$Res>  {
  factory $DateNavigationUiStateCopyWith(DateNavigationUiState value, $Res Function(DateNavigationUiState) _then) = _$DateNavigationUiStateCopyWithImpl;
@useResult
$Res call({
 bool isLoadingRoomAction, bool isGeocoding, bool isCalculatingMeeting, Failure? lastFailure, String? failureOperation
});




}
/// @nodoc
class _$DateNavigationUiStateCopyWithImpl<$Res>
    implements $DateNavigationUiStateCopyWith<$Res> {
  _$DateNavigationUiStateCopyWithImpl(this._self, this._then);

  final DateNavigationUiState _self;
  final $Res Function(DateNavigationUiState) _then;

/// Create a copy of DateNavigationUiState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoadingRoomAction = null,Object? isGeocoding = null,Object? isCalculatingMeeting = null,Object? lastFailure = freezed,Object? failureOperation = freezed,}) {
  return _then(_self.copyWith(
isLoadingRoomAction: null == isLoadingRoomAction ? _self.isLoadingRoomAction : isLoadingRoomAction // ignore: cast_nullable_to_non_nullable
as bool,isGeocoding: null == isGeocoding ? _self.isGeocoding : isGeocoding // ignore: cast_nullable_to_non_nullable
as bool,isCalculatingMeeting: null == isCalculatingMeeting ? _self.isCalculatingMeeting : isCalculatingMeeting // ignore: cast_nullable_to_non_nullable
as bool,lastFailure: freezed == lastFailure ? _self.lastFailure : lastFailure // ignore: cast_nullable_to_non_nullable
as Failure?,failureOperation: freezed == failureOperation ? _self.failureOperation : failureOperation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DateNavigationUiState].
extension DateNavigationUiStatePatterns on DateNavigationUiState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateNavigationUiState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateNavigationUiState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateNavigationUiState value)  $default,){
final _that = this;
switch (_that) {
case _DateNavigationUiState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateNavigationUiState value)?  $default,){
final _that = this;
switch (_that) {
case _DateNavigationUiState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoadingRoomAction,  bool isGeocoding,  bool isCalculatingMeeting,  Failure? lastFailure,  String? failureOperation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateNavigationUiState() when $default != null:
return $default(_that.isLoadingRoomAction,_that.isGeocoding,_that.isCalculatingMeeting,_that.lastFailure,_that.failureOperation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoadingRoomAction,  bool isGeocoding,  bool isCalculatingMeeting,  Failure? lastFailure,  String? failureOperation)  $default,) {final _that = this;
switch (_that) {
case _DateNavigationUiState():
return $default(_that.isLoadingRoomAction,_that.isGeocoding,_that.isCalculatingMeeting,_that.lastFailure,_that.failureOperation);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoadingRoomAction,  bool isGeocoding,  bool isCalculatingMeeting,  Failure? lastFailure,  String? failureOperation)?  $default,) {final _that = this;
switch (_that) {
case _DateNavigationUiState() when $default != null:
return $default(_that.isLoadingRoomAction,_that.isGeocoding,_that.isCalculatingMeeting,_that.lastFailure,_that.failureOperation);case _:
  return null;

}
}

}

/// @nodoc


class _DateNavigationUiState extends DateNavigationUiState {
  const _DateNavigationUiState({this.isLoadingRoomAction = false, this.isGeocoding = false, this.isCalculatingMeeting = false, this.lastFailure, this.failureOperation}): super._();
  

@override@JsonKey() final  bool isLoadingRoomAction;
@override@JsonKey() final  bool isGeocoding;
@override@JsonKey() final  bool isCalculatingMeeting;
@override final  Failure? lastFailure;
@override final  String? failureOperation;

/// Create a copy of DateNavigationUiState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateNavigationUiStateCopyWith<_DateNavigationUiState> get copyWith => __$DateNavigationUiStateCopyWithImpl<_DateNavigationUiState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateNavigationUiState&&(identical(other.isLoadingRoomAction, isLoadingRoomAction) || other.isLoadingRoomAction == isLoadingRoomAction)&&(identical(other.isGeocoding, isGeocoding) || other.isGeocoding == isGeocoding)&&(identical(other.isCalculatingMeeting, isCalculatingMeeting) || other.isCalculatingMeeting == isCalculatingMeeting)&&(identical(other.lastFailure, lastFailure) || other.lastFailure == lastFailure)&&(identical(other.failureOperation, failureOperation) || other.failureOperation == failureOperation));
}


@override
int get hashCode => Object.hash(runtimeType,isLoadingRoomAction,isGeocoding,isCalculatingMeeting,lastFailure,failureOperation);

@override
String toString() {
  return 'DateNavigationUiState(isLoadingRoomAction: $isLoadingRoomAction, isGeocoding: $isGeocoding, isCalculatingMeeting: $isCalculatingMeeting, lastFailure: $lastFailure, failureOperation: $failureOperation)';
}


}

/// @nodoc
abstract mixin class _$DateNavigationUiStateCopyWith<$Res> implements $DateNavigationUiStateCopyWith<$Res> {
  factory _$DateNavigationUiStateCopyWith(_DateNavigationUiState value, $Res Function(_DateNavigationUiState) _then) = __$DateNavigationUiStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoadingRoomAction, bool isGeocoding, bool isCalculatingMeeting, Failure? lastFailure, String? failureOperation
});




}
/// @nodoc
class __$DateNavigationUiStateCopyWithImpl<$Res>
    implements _$DateNavigationUiStateCopyWith<$Res> {
  __$DateNavigationUiStateCopyWithImpl(this._self, this._then);

  final _DateNavigationUiState _self;
  final $Res Function(_DateNavigationUiState) _then;

/// Create a copy of DateNavigationUiState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoadingRoomAction = null,Object? isGeocoding = null,Object? isCalculatingMeeting = null,Object? lastFailure = freezed,Object? failureOperation = freezed,}) {
  return _then(_DateNavigationUiState(
isLoadingRoomAction: null == isLoadingRoomAction ? _self.isLoadingRoomAction : isLoadingRoomAction // ignore: cast_nullable_to_non_nullable
as bool,isGeocoding: null == isGeocoding ? _self.isGeocoding : isGeocoding // ignore: cast_nullable_to_non_nullable
as bool,isCalculatingMeeting: null == isCalculatingMeeting ? _self.isCalculatingMeeting : isCalculatingMeeting // ignore: cast_nullable_to_non_nullable
as bool,lastFailure: freezed == lastFailure ? _self.lastFailure : lastFailure // ignore: cast_nullable_to_non_nullable
as Failure?,failureOperation: freezed == failureOperation ? _self.failureOperation : failureOperation // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$DateNavigationState {

 RoomSessionState get room; MeetingPlanningState get meeting; VotingState get voting; AddressMemoryState get addressMemory; DateNavigationUiState get ui;
/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateNavigationStateCopyWith<DateNavigationState> get copyWith => _$DateNavigationStateCopyWithImpl<DateNavigationState>(this as DateNavigationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateNavigationState&&(identical(other.room, room) || other.room == room)&&(identical(other.meeting, meeting) || other.meeting == meeting)&&(identical(other.voting, voting) || other.voting == voting)&&(identical(other.addressMemory, addressMemory) || other.addressMemory == addressMemory)&&(identical(other.ui, ui) || other.ui == ui));
}


@override
int get hashCode => Object.hash(runtimeType,room,meeting,voting,addressMemory,ui);

@override
String toString() {
  return 'DateNavigationState(room: $room, meeting: $meeting, voting: $voting, addressMemory: $addressMemory, ui: $ui)';
}


}

/// @nodoc
abstract mixin class $DateNavigationStateCopyWith<$Res>  {
  factory $DateNavigationStateCopyWith(DateNavigationState value, $Res Function(DateNavigationState) _then) = _$DateNavigationStateCopyWithImpl;
@useResult
$Res call({
 RoomSessionState room, MeetingPlanningState meeting, VotingState voting, AddressMemoryState addressMemory, DateNavigationUiState ui
});


$RoomSessionStateCopyWith<$Res> get room;$MeetingPlanningStateCopyWith<$Res> get meeting;$VotingStateCopyWith<$Res> get voting;$AddressMemoryStateCopyWith<$Res> get addressMemory;$DateNavigationUiStateCopyWith<$Res> get ui;

}
/// @nodoc
class _$DateNavigationStateCopyWithImpl<$Res>
    implements $DateNavigationStateCopyWith<$Res> {
  _$DateNavigationStateCopyWithImpl(this._self, this._then);

  final DateNavigationState _self;
  final $Res Function(DateNavigationState) _then;

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? room = null,Object? meeting = null,Object? voting = null,Object? addressMemory = null,Object? ui = null,}) {
  return _then(_self.copyWith(
room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RoomSessionState,meeting: null == meeting ? _self.meeting : meeting // ignore: cast_nullable_to_non_nullable
as MeetingPlanningState,voting: null == voting ? _self.voting : voting // ignore: cast_nullable_to_non_nullable
as VotingState,addressMemory: null == addressMemory ? _self.addressMemory : addressMemory // ignore: cast_nullable_to_non_nullable
as AddressMemoryState,ui: null == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as DateNavigationUiState,
  ));
}
/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSessionStateCopyWith<$Res> get room {
  
  return $RoomSessionStateCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingPlanningStateCopyWith<$Res> get meeting {
  
  return $MeetingPlanningStateCopyWith<$Res>(_self.meeting, (value) {
    return _then(_self.copyWith(meeting: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VotingStateCopyWith<$Res> get voting {
  
  return $VotingStateCopyWith<$Res>(_self.voting, (value) {
    return _then(_self.copyWith(voting: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressMemoryStateCopyWith<$Res> get addressMemory {
  
  return $AddressMemoryStateCopyWith<$Res>(_self.addressMemory, (value) {
    return _then(_self.copyWith(addressMemory: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateNavigationUiStateCopyWith<$Res> get ui {
  
  return $DateNavigationUiStateCopyWith<$Res>(_self.ui, (value) {
    return _then(_self.copyWith(ui: value));
  });
}
}


/// Adds pattern-matching-related methods to [DateNavigationState].
extension DateNavigationStatePatterns on DateNavigationState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DateNavigationState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DateNavigationState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DateNavigationState value)  $default,){
final _that = this;
switch (_that) {
case _DateNavigationState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DateNavigationState value)?  $default,){
final _that = this;
switch (_that) {
case _DateNavigationState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RoomSessionState room,  MeetingPlanningState meeting,  VotingState voting,  AddressMemoryState addressMemory,  DateNavigationUiState ui)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateNavigationState() when $default != null:
return $default(_that.room,_that.meeting,_that.voting,_that.addressMemory,_that.ui);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RoomSessionState room,  MeetingPlanningState meeting,  VotingState voting,  AddressMemoryState addressMemory,  DateNavigationUiState ui)  $default,) {final _that = this;
switch (_that) {
case _DateNavigationState():
return $default(_that.room,_that.meeting,_that.voting,_that.addressMemory,_that.ui);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RoomSessionState room,  MeetingPlanningState meeting,  VotingState voting,  AddressMemoryState addressMemory,  DateNavigationUiState ui)?  $default,) {final _that = this;
switch (_that) {
case _DateNavigationState() when $default != null:
return $default(_that.room,_that.meeting,_that.voting,_that.addressMemory,_that.ui);case _:
  return null;

}
}

}

/// @nodoc


class _DateNavigationState extends DateNavigationState {
  const _DateNavigationState({this.room = const RoomSessionState(), this.meeting = const MeetingPlanningState(), this.voting = const VotingState(), this.addressMemory = const AddressMemoryState(), this.ui = const DateNavigationUiState()}): super._();
  

@override@JsonKey() final  RoomSessionState room;
@override@JsonKey() final  MeetingPlanningState meeting;
@override@JsonKey() final  VotingState voting;
@override@JsonKey() final  AddressMemoryState addressMemory;
@override@JsonKey() final  DateNavigationUiState ui;

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateNavigationStateCopyWith<_DateNavigationState> get copyWith => __$DateNavigationStateCopyWithImpl<_DateNavigationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateNavigationState&&(identical(other.room, room) || other.room == room)&&(identical(other.meeting, meeting) || other.meeting == meeting)&&(identical(other.voting, voting) || other.voting == voting)&&(identical(other.addressMemory, addressMemory) || other.addressMemory == addressMemory)&&(identical(other.ui, ui) || other.ui == ui));
}


@override
int get hashCode => Object.hash(runtimeType,room,meeting,voting,addressMemory,ui);

@override
String toString() {
  return 'DateNavigationState(room: $room, meeting: $meeting, voting: $voting, addressMemory: $addressMemory, ui: $ui)';
}


}

/// @nodoc
abstract mixin class _$DateNavigationStateCopyWith<$Res> implements $DateNavigationStateCopyWith<$Res> {
  factory _$DateNavigationStateCopyWith(_DateNavigationState value, $Res Function(_DateNavigationState) _then) = __$DateNavigationStateCopyWithImpl;
@override @useResult
$Res call({
 RoomSessionState room, MeetingPlanningState meeting, VotingState voting, AddressMemoryState addressMemory, DateNavigationUiState ui
});


@override $RoomSessionStateCopyWith<$Res> get room;@override $MeetingPlanningStateCopyWith<$Res> get meeting;@override $VotingStateCopyWith<$Res> get voting;@override $AddressMemoryStateCopyWith<$Res> get addressMemory;@override $DateNavigationUiStateCopyWith<$Res> get ui;

}
/// @nodoc
class __$DateNavigationStateCopyWithImpl<$Res>
    implements _$DateNavigationStateCopyWith<$Res> {
  __$DateNavigationStateCopyWithImpl(this._self, this._then);

  final _DateNavigationState _self;
  final $Res Function(_DateNavigationState) _then;

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? room = null,Object? meeting = null,Object? voting = null,Object? addressMemory = null,Object? ui = null,}) {
  return _then(_DateNavigationState(
room: null == room ? _self.room : room // ignore: cast_nullable_to_non_nullable
as RoomSessionState,meeting: null == meeting ? _self.meeting : meeting // ignore: cast_nullable_to_non_nullable
as MeetingPlanningState,voting: null == voting ? _self.voting : voting // ignore: cast_nullable_to_non_nullable
as VotingState,addressMemory: null == addressMemory ? _self.addressMemory : addressMemory // ignore: cast_nullable_to_non_nullable
as AddressMemoryState,ui: null == ui ? _self.ui : ui // ignore: cast_nullable_to_non_nullable
as DateNavigationUiState,
  ));
}

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RoomSessionStateCopyWith<$Res> get room {
  
  return $RoomSessionStateCopyWith<$Res>(_self.room, (value) {
    return _then(_self.copyWith(room: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MeetingPlanningStateCopyWith<$Res> get meeting {
  
  return $MeetingPlanningStateCopyWith<$Res>(_self.meeting, (value) {
    return _then(_self.copyWith(meeting: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VotingStateCopyWith<$Res> get voting {
  
  return $VotingStateCopyWith<$Res>(_self.voting, (value) {
    return _then(_self.copyWith(voting: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AddressMemoryStateCopyWith<$Res> get addressMemory {
  
  return $AddressMemoryStateCopyWith<$Res>(_self.addressMemory, (value) {
    return _then(_self.copyWith(addressMemory: value));
  });
}/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DateNavigationUiStateCopyWith<$Res> get ui {
  
  return $DateNavigationUiStateCopyWith<$Res>(_self.ui, (value) {
    return _then(_self.copyWith(ui: value));
  });
}
}

// dart format on
