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
mixin _$DateNavigationState {

 String? get roomId; String? get inviteCode; bool get isCreator; bool get isLoadingRoomAction; bool get isGeocoding; bool get isCalculatingMeeting; String? get finalChoiceName; Place? get finalChoicePlace; List<Place> get foundPlaces; List<Place> get filteredPlaces; latlong.LatLng? get centerPoint; latlong.LatLng? get point1; latlong.LatLng? get point2; List<latlong.LatLng> get routePoints; String? get selectedType; double get searchRadius; Map<String, String> get votesByUser; Map<String, int> get voteCounts; String? get proposalPlaceName; String? get proposalPlaceAddress; String? get proposalPlaceType; String? get proposalByRole; ProposalStatus? get proposalStatus; int? get creatorChangedRadiusTo; int? get peerSuggestedRadius; MeetingFormat? get peerSuggestedMeetingFormat; List<String> get recentAddresses; Failure? get lastFailure; String? get failureOperation; SessionStatus get sessionStatus; DateScenario? get selectedScenario; List<MeetingFormat> get creatorMeetingFormats; List<MeetingFormat> get partnerMeetingFormats; MeetingFormat? get creatorSelectedMeetingFormat; MeetingFormat? get partnerSelectedMeetingFormat; MeetingFormat? get selectedMeetingFormat; MeetingFormat? get lastAgreedMeetingFormat; List<DateScenario> get dateScenarios; String? get meetingRevoteRequestByRole; RevoteRequestStatus? get meetingRevoteRequestStatus;
/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DateNavigationStateCopyWith<DateNavigationState> get copyWith => _$DateNavigationStateCopyWithImpl<DateNavigationState>(this as DateNavigationState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DateNavigationState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator)&&(identical(other.isLoadingRoomAction, isLoadingRoomAction) || other.isLoadingRoomAction == isLoadingRoomAction)&&(identical(other.isGeocoding, isGeocoding) || other.isGeocoding == isGeocoding)&&(identical(other.isCalculatingMeeting, isCalculatingMeeting) || other.isCalculatingMeeting == isCalculatingMeeting)&&(identical(other.finalChoiceName, finalChoiceName) || other.finalChoiceName == finalChoiceName)&&(identical(other.finalChoicePlace, finalChoicePlace) || other.finalChoicePlace == finalChoicePlace)&&const DeepCollectionEquality().equals(other.foundPlaces, foundPlaces)&&const DeepCollectionEquality().equals(other.filteredPlaces, filteredPlaces)&&(identical(other.centerPoint, centerPoint) || other.centerPoint == centerPoint)&&(identical(other.point1, point1) || other.point1 == point1)&&(identical(other.point2, point2) || other.point2 == point2)&&const DeepCollectionEquality().equals(other.routePoints, routePoints)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.searchRadius, searchRadius) || other.searchRadius == searchRadius)&&const DeepCollectionEquality().equals(other.votesByUser, votesByUser)&&const DeepCollectionEquality().equals(other.voteCounts, voteCounts)&&(identical(other.proposalPlaceName, proposalPlaceName) || other.proposalPlaceName == proposalPlaceName)&&(identical(other.proposalPlaceAddress, proposalPlaceAddress) || other.proposalPlaceAddress == proposalPlaceAddress)&&(identical(other.proposalPlaceType, proposalPlaceType) || other.proposalPlaceType == proposalPlaceType)&&(identical(other.proposalByRole, proposalByRole) || other.proposalByRole == proposalByRole)&&(identical(other.proposalStatus, proposalStatus) || other.proposalStatus == proposalStatus)&&(identical(other.creatorChangedRadiusTo, creatorChangedRadiusTo) || other.creatorChangedRadiusTo == creatorChangedRadiusTo)&&(identical(other.peerSuggestedRadius, peerSuggestedRadius) || other.peerSuggestedRadius == peerSuggestedRadius)&&(identical(other.peerSuggestedMeetingFormat, peerSuggestedMeetingFormat) || other.peerSuggestedMeetingFormat == peerSuggestedMeetingFormat)&&const DeepCollectionEquality().equals(other.recentAddresses, recentAddresses)&&(identical(other.lastFailure, lastFailure) || other.lastFailure == lastFailure)&&(identical(other.failureOperation, failureOperation) || other.failureOperation == failureOperation)&&(identical(other.sessionStatus, sessionStatus) || other.sessionStatus == sessionStatus)&&(identical(other.selectedScenario, selectedScenario) || other.selectedScenario == selectedScenario)&&const DeepCollectionEquality().equals(other.creatorMeetingFormats, creatorMeetingFormats)&&const DeepCollectionEquality().equals(other.partnerMeetingFormats, partnerMeetingFormats)&&(identical(other.creatorSelectedMeetingFormat, creatorSelectedMeetingFormat) || other.creatorSelectedMeetingFormat == creatorSelectedMeetingFormat)&&(identical(other.partnerSelectedMeetingFormat, partnerSelectedMeetingFormat) || other.partnerSelectedMeetingFormat == partnerSelectedMeetingFormat)&&(identical(other.selectedMeetingFormat, selectedMeetingFormat) || other.selectedMeetingFormat == selectedMeetingFormat)&&(identical(other.lastAgreedMeetingFormat, lastAgreedMeetingFormat) || other.lastAgreedMeetingFormat == lastAgreedMeetingFormat)&&const DeepCollectionEquality().equals(other.dateScenarios, dateScenarios)&&(identical(other.meetingRevoteRequestByRole, meetingRevoteRequestByRole) || other.meetingRevoteRequestByRole == meetingRevoteRequestByRole)&&(identical(other.meetingRevoteRequestStatus, meetingRevoteRequestStatus) || other.meetingRevoteRequestStatus == meetingRevoteRequestStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,roomId,inviteCode,isCreator,isLoadingRoomAction,isGeocoding,isCalculatingMeeting,finalChoiceName,finalChoicePlace,const DeepCollectionEquality().hash(foundPlaces),const DeepCollectionEquality().hash(filteredPlaces),centerPoint,point1,point2,const DeepCollectionEquality().hash(routePoints),selectedType,searchRadius,const DeepCollectionEquality().hash(votesByUser),const DeepCollectionEquality().hash(voteCounts),proposalPlaceName,proposalPlaceAddress,proposalPlaceType,proposalByRole,proposalStatus,creatorChangedRadiusTo,peerSuggestedRadius,peerSuggestedMeetingFormat,const DeepCollectionEquality().hash(recentAddresses),lastFailure,failureOperation,sessionStatus,selectedScenario,const DeepCollectionEquality().hash(creatorMeetingFormats),const DeepCollectionEquality().hash(partnerMeetingFormats),creatorSelectedMeetingFormat,partnerSelectedMeetingFormat,selectedMeetingFormat,lastAgreedMeetingFormat,const DeepCollectionEquality().hash(dateScenarios),meetingRevoteRequestByRole,meetingRevoteRequestStatus]);

@override
String toString() {
  return 'DateNavigationState(roomId: $roomId, inviteCode: $inviteCode, isCreator: $isCreator, isLoadingRoomAction: $isLoadingRoomAction, isGeocoding: $isGeocoding, isCalculatingMeeting: $isCalculatingMeeting, finalChoiceName: $finalChoiceName, finalChoicePlace: $finalChoicePlace, foundPlaces: $foundPlaces, filteredPlaces: $filteredPlaces, centerPoint: $centerPoint, point1: $point1, point2: $point2, routePoints: $routePoints, selectedType: $selectedType, searchRadius: $searchRadius, votesByUser: $votesByUser, voteCounts: $voteCounts, proposalPlaceName: $proposalPlaceName, proposalPlaceAddress: $proposalPlaceAddress, proposalPlaceType: $proposalPlaceType, proposalByRole: $proposalByRole, proposalStatus: $proposalStatus, creatorChangedRadiusTo: $creatorChangedRadiusTo, peerSuggestedRadius: $peerSuggestedRadius, peerSuggestedMeetingFormat: $peerSuggestedMeetingFormat, recentAddresses: $recentAddresses, lastFailure: $lastFailure, failureOperation: $failureOperation, sessionStatus: $sessionStatus, selectedScenario: $selectedScenario, creatorMeetingFormats: $creatorMeetingFormats, partnerMeetingFormats: $partnerMeetingFormats, creatorSelectedMeetingFormat: $creatorSelectedMeetingFormat, partnerSelectedMeetingFormat: $partnerSelectedMeetingFormat, selectedMeetingFormat: $selectedMeetingFormat, lastAgreedMeetingFormat: $lastAgreedMeetingFormat, dateScenarios: $dateScenarios, meetingRevoteRequestByRole: $meetingRevoteRequestByRole, meetingRevoteRequestStatus: $meetingRevoteRequestStatus)';
}


}

/// @nodoc
abstract mixin class $DateNavigationStateCopyWith<$Res>  {
  factory $DateNavigationStateCopyWith(DateNavigationState value, $Res Function(DateNavigationState) _then) = _$DateNavigationStateCopyWithImpl;
@useResult
$Res call({
 String? roomId, String? inviteCode, bool isCreator, bool isLoadingRoomAction, bool isGeocoding, bool isCalculatingMeeting, String? finalChoiceName, Place? finalChoicePlace, List<Place> foundPlaces, List<Place> filteredPlaces, latlong.LatLng? centerPoint, latlong.LatLng? point1, latlong.LatLng? point2, List<latlong.LatLng> routePoints, String? selectedType, double searchRadius, Map<String, String> votesByUser, Map<String, int> voteCounts, String? proposalPlaceName, String? proposalPlaceAddress, String? proposalPlaceType, String? proposalByRole, ProposalStatus? proposalStatus, int? creatorChangedRadiusTo, int? peerSuggestedRadius, MeetingFormat? peerSuggestedMeetingFormat, List<String> recentAddresses, Failure? lastFailure, String? failureOperation, SessionStatus sessionStatus, DateScenario? selectedScenario, List<MeetingFormat> creatorMeetingFormats, List<MeetingFormat> partnerMeetingFormats, MeetingFormat? creatorSelectedMeetingFormat, MeetingFormat? partnerSelectedMeetingFormat, MeetingFormat? selectedMeetingFormat, MeetingFormat? lastAgreedMeetingFormat, List<DateScenario> dateScenarios, String? meetingRevoteRequestByRole, RevoteRequestStatus? meetingRevoteRequestStatus
});




}
/// @nodoc
class _$DateNavigationStateCopyWithImpl<$Res>
    implements $DateNavigationStateCopyWith<$Res> {
  _$DateNavigationStateCopyWithImpl(this._self, this._then);

  final DateNavigationState _self;
  final $Res Function(DateNavigationState) _then;

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? roomId = freezed,Object? inviteCode = freezed,Object? isCreator = null,Object? isLoadingRoomAction = null,Object? isGeocoding = null,Object? isCalculatingMeeting = null,Object? finalChoiceName = freezed,Object? finalChoicePlace = freezed,Object? foundPlaces = null,Object? filteredPlaces = null,Object? centerPoint = freezed,Object? point1 = freezed,Object? point2 = freezed,Object? routePoints = null,Object? selectedType = freezed,Object? searchRadius = null,Object? votesByUser = null,Object? voteCounts = null,Object? proposalPlaceName = freezed,Object? proposalPlaceAddress = freezed,Object? proposalPlaceType = freezed,Object? proposalByRole = freezed,Object? proposalStatus = freezed,Object? creatorChangedRadiusTo = freezed,Object? peerSuggestedRadius = freezed,Object? peerSuggestedMeetingFormat = freezed,Object? recentAddresses = null,Object? lastFailure = freezed,Object? failureOperation = freezed,Object? sessionStatus = null,Object? selectedScenario = freezed,Object? creatorMeetingFormats = null,Object? partnerMeetingFormats = null,Object? creatorSelectedMeetingFormat = freezed,Object? partnerSelectedMeetingFormat = freezed,Object? selectedMeetingFormat = freezed,Object? lastAgreedMeetingFormat = freezed,Object? dateScenarios = null,Object? meetingRevoteRequestByRole = freezed,Object? meetingRevoteRequestStatus = freezed,}) {
  return _then(_self.copyWith(
roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,isLoadingRoomAction: null == isLoadingRoomAction ? _self.isLoadingRoomAction : isLoadingRoomAction // ignore: cast_nullable_to_non_nullable
as bool,isGeocoding: null == isGeocoding ? _self.isGeocoding : isGeocoding // ignore: cast_nullable_to_non_nullable
as bool,isCalculatingMeeting: null == isCalculatingMeeting ? _self.isCalculatingMeeting : isCalculatingMeeting // ignore: cast_nullable_to_non_nullable
as bool,finalChoiceName: freezed == finalChoiceName ? _self.finalChoiceName : finalChoiceName // ignore: cast_nullable_to_non_nullable
as String?,finalChoicePlace: freezed == finalChoicePlace ? _self.finalChoicePlace : finalChoicePlace // ignore: cast_nullable_to_non_nullable
as Place?,foundPlaces: null == foundPlaces ? _self.foundPlaces : foundPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,filteredPlaces: null == filteredPlaces ? _self.filteredPlaces : filteredPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,centerPoint: freezed == centerPoint ? _self.centerPoint : centerPoint // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,point1: freezed == point1 ? _self.point1 : point1 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,point2: freezed == point2 ? _self.point2 : point2 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,routePoints: null == routePoints ? _self.routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<latlong.LatLng>,selectedType: freezed == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String?,searchRadius: null == searchRadius ? _self.searchRadius : searchRadius // ignore: cast_nullable_to_non_nullable
as double,votesByUser: null == votesByUser ? _self.votesByUser : votesByUser // ignore: cast_nullable_to_non_nullable
as Map<String, String>,voteCounts: null == voteCounts ? _self.voteCounts : voteCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,proposalPlaceName: freezed == proposalPlaceName ? _self.proposalPlaceName : proposalPlaceName // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceAddress: freezed == proposalPlaceAddress ? _self.proposalPlaceAddress : proposalPlaceAddress // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceType: freezed == proposalPlaceType ? _self.proposalPlaceType : proposalPlaceType // ignore: cast_nullable_to_non_nullable
as String?,proposalByRole: freezed == proposalByRole ? _self.proposalByRole : proposalByRole // ignore: cast_nullable_to_non_nullable
as String?,proposalStatus: freezed == proposalStatus ? _self.proposalStatus : proposalStatus // ignore: cast_nullable_to_non_nullable
as ProposalStatus?,creatorChangedRadiusTo: freezed == creatorChangedRadiusTo ? _self.creatorChangedRadiusTo : creatorChangedRadiusTo // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedRadius: freezed == peerSuggestedRadius ? _self.peerSuggestedRadius : peerSuggestedRadius // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedMeetingFormat: freezed == peerSuggestedMeetingFormat ? _self.peerSuggestedMeetingFormat : peerSuggestedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,recentAddresses: null == recentAddresses ? _self.recentAddresses : recentAddresses // ignore: cast_nullable_to_non_nullable
as List<String>,lastFailure: freezed == lastFailure ? _self.lastFailure : lastFailure // ignore: cast_nullable_to_non_nullable
as Failure?,failureOperation: freezed == failureOperation ? _self.failureOperation : failureOperation // ignore: cast_nullable_to_non_nullable
as String?,sessionStatus: null == sessionStatus ? _self.sessionStatus : sessionStatus // ignore: cast_nullable_to_non_nullable
as SessionStatus,selectedScenario: freezed == selectedScenario ? _self.selectedScenario : selectedScenario // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? roomId,  String? inviteCode,  bool isCreator,  bool isLoadingRoomAction,  bool isGeocoding,  bool isCalculatingMeeting,  String? finalChoiceName,  Place? finalChoicePlace,  List<Place> foundPlaces,  List<Place> filteredPlaces,  latlong.LatLng? centerPoint,  latlong.LatLng? point1,  latlong.LatLng? point2,  List<latlong.LatLng> routePoints,  String? selectedType,  double searchRadius,  Map<String, String> votesByUser,  Map<String, int> voteCounts,  String? proposalPlaceName,  String? proposalPlaceAddress,  String? proposalPlaceType,  String? proposalByRole,  ProposalStatus? proposalStatus,  int? creatorChangedRadiusTo,  int? peerSuggestedRadius,  MeetingFormat? peerSuggestedMeetingFormat,  List<String> recentAddresses,  Failure? lastFailure,  String? failureOperation,  SessionStatus sessionStatus,  DateScenario? selectedScenario,  List<MeetingFormat> creatorMeetingFormats,  List<MeetingFormat> partnerMeetingFormats,  MeetingFormat? creatorSelectedMeetingFormat,  MeetingFormat? partnerSelectedMeetingFormat,  MeetingFormat? selectedMeetingFormat,  MeetingFormat? lastAgreedMeetingFormat,  List<DateScenario> dateScenarios,  String? meetingRevoteRequestByRole,  RevoteRequestStatus? meetingRevoteRequestStatus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DateNavigationState() when $default != null:
return $default(_that.roomId,_that.inviteCode,_that.isCreator,_that.isLoadingRoomAction,_that.isGeocoding,_that.isCalculatingMeeting,_that.finalChoiceName,_that.finalChoicePlace,_that.foundPlaces,_that.filteredPlaces,_that.centerPoint,_that.point1,_that.point2,_that.routePoints,_that.selectedType,_that.searchRadius,_that.votesByUser,_that.voteCounts,_that.proposalPlaceName,_that.proposalPlaceAddress,_that.proposalPlaceType,_that.proposalByRole,_that.proposalStatus,_that.creatorChangedRadiusTo,_that.peerSuggestedRadius,_that.peerSuggestedMeetingFormat,_that.recentAddresses,_that.lastFailure,_that.failureOperation,_that.sessionStatus,_that.selectedScenario,_that.creatorMeetingFormats,_that.partnerMeetingFormats,_that.creatorSelectedMeetingFormat,_that.partnerSelectedMeetingFormat,_that.selectedMeetingFormat,_that.lastAgreedMeetingFormat,_that.dateScenarios,_that.meetingRevoteRequestByRole,_that.meetingRevoteRequestStatus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? roomId,  String? inviteCode,  bool isCreator,  bool isLoadingRoomAction,  bool isGeocoding,  bool isCalculatingMeeting,  String? finalChoiceName,  Place? finalChoicePlace,  List<Place> foundPlaces,  List<Place> filteredPlaces,  latlong.LatLng? centerPoint,  latlong.LatLng? point1,  latlong.LatLng? point2,  List<latlong.LatLng> routePoints,  String? selectedType,  double searchRadius,  Map<String, String> votesByUser,  Map<String, int> voteCounts,  String? proposalPlaceName,  String? proposalPlaceAddress,  String? proposalPlaceType,  String? proposalByRole,  ProposalStatus? proposalStatus,  int? creatorChangedRadiusTo,  int? peerSuggestedRadius,  MeetingFormat? peerSuggestedMeetingFormat,  List<String> recentAddresses,  Failure? lastFailure,  String? failureOperation,  SessionStatus sessionStatus,  DateScenario? selectedScenario,  List<MeetingFormat> creatorMeetingFormats,  List<MeetingFormat> partnerMeetingFormats,  MeetingFormat? creatorSelectedMeetingFormat,  MeetingFormat? partnerSelectedMeetingFormat,  MeetingFormat? selectedMeetingFormat,  MeetingFormat? lastAgreedMeetingFormat,  List<DateScenario> dateScenarios,  String? meetingRevoteRequestByRole,  RevoteRequestStatus? meetingRevoteRequestStatus)  $default,) {final _that = this;
switch (_that) {
case _DateNavigationState():
return $default(_that.roomId,_that.inviteCode,_that.isCreator,_that.isLoadingRoomAction,_that.isGeocoding,_that.isCalculatingMeeting,_that.finalChoiceName,_that.finalChoicePlace,_that.foundPlaces,_that.filteredPlaces,_that.centerPoint,_that.point1,_that.point2,_that.routePoints,_that.selectedType,_that.searchRadius,_that.votesByUser,_that.voteCounts,_that.proposalPlaceName,_that.proposalPlaceAddress,_that.proposalPlaceType,_that.proposalByRole,_that.proposalStatus,_that.creatorChangedRadiusTo,_that.peerSuggestedRadius,_that.peerSuggestedMeetingFormat,_that.recentAddresses,_that.lastFailure,_that.failureOperation,_that.sessionStatus,_that.selectedScenario,_that.creatorMeetingFormats,_that.partnerMeetingFormats,_that.creatorSelectedMeetingFormat,_that.partnerSelectedMeetingFormat,_that.selectedMeetingFormat,_that.lastAgreedMeetingFormat,_that.dateScenarios,_that.meetingRevoteRequestByRole,_that.meetingRevoteRequestStatus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? roomId,  String? inviteCode,  bool isCreator,  bool isLoadingRoomAction,  bool isGeocoding,  bool isCalculatingMeeting,  String? finalChoiceName,  Place? finalChoicePlace,  List<Place> foundPlaces,  List<Place> filteredPlaces,  latlong.LatLng? centerPoint,  latlong.LatLng? point1,  latlong.LatLng? point2,  List<latlong.LatLng> routePoints,  String? selectedType,  double searchRadius,  Map<String, String> votesByUser,  Map<String, int> voteCounts,  String? proposalPlaceName,  String? proposalPlaceAddress,  String? proposalPlaceType,  String? proposalByRole,  ProposalStatus? proposalStatus,  int? creatorChangedRadiusTo,  int? peerSuggestedRadius,  MeetingFormat? peerSuggestedMeetingFormat,  List<String> recentAddresses,  Failure? lastFailure,  String? failureOperation,  SessionStatus sessionStatus,  DateScenario? selectedScenario,  List<MeetingFormat> creatorMeetingFormats,  List<MeetingFormat> partnerMeetingFormats,  MeetingFormat? creatorSelectedMeetingFormat,  MeetingFormat? partnerSelectedMeetingFormat,  MeetingFormat? selectedMeetingFormat,  MeetingFormat? lastAgreedMeetingFormat,  List<DateScenario> dateScenarios,  String? meetingRevoteRequestByRole,  RevoteRequestStatus? meetingRevoteRequestStatus)?  $default,) {final _that = this;
switch (_that) {
case _DateNavigationState() when $default != null:
return $default(_that.roomId,_that.inviteCode,_that.isCreator,_that.isLoadingRoomAction,_that.isGeocoding,_that.isCalculatingMeeting,_that.finalChoiceName,_that.finalChoicePlace,_that.foundPlaces,_that.filteredPlaces,_that.centerPoint,_that.point1,_that.point2,_that.routePoints,_that.selectedType,_that.searchRadius,_that.votesByUser,_that.voteCounts,_that.proposalPlaceName,_that.proposalPlaceAddress,_that.proposalPlaceType,_that.proposalByRole,_that.proposalStatus,_that.creatorChangedRadiusTo,_that.peerSuggestedRadius,_that.peerSuggestedMeetingFormat,_that.recentAddresses,_that.lastFailure,_that.failureOperation,_that.sessionStatus,_that.selectedScenario,_that.creatorMeetingFormats,_that.partnerMeetingFormats,_that.creatorSelectedMeetingFormat,_that.partnerSelectedMeetingFormat,_that.selectedMeetingFormat,_that.lastAgreedMeetingFormat,_that.dateScenarios,_that.meetingRevoteRequestByRole,_that.meetingRevoteRequestStatus);case _:
  return null;

}
}

}

/// @nodoc


class _DateNavigationState extends DateNavigationState {
  const _DateNavigationState({this.roomId, this.inviteCode, this.isCreator = false, this.isLoadingRoomAction = false, this.isGeocoding = false, this.isCalculatingMeeting = false, this.finalChoiceName, this.finalChoicePlace, final  List<Place> foundPlaces = const [], final  List<Place> filteredPlaces = const [], this.centerPoint, this.point1, this.point2, final  List<latlong.LatLng> routePoints = const [], this.selectedType, this.searchRadius = 500.0, final  Map<String, String> votesByUser = const {}, final  Map<String, int> voteCounts = const {}, this.proposalPlaceName, this.proposalPlaceAddress, this.proposalPlaceType, this.proposalByRole, this.proposalStatus, this.creatorChangedRadiusTo, this.peerSuggestedRadius, this.peerSuggestedMeetingFormat, final  List<String> recentAddresses = const [], this.lastFailure, this.failureOperation, this.sessionStatus = SessionStatus.active, this.selectedScenario, final  List<MeetingFormat> creatorMeetingFormats = const [], final  List<MeetingFormat> partnerMeetingFormats = const [], this.creatorSelectedMeetingFormat, this.partnerSelectedMeetingFormat, this.selectedMeetingFormat, this.lastAgreedMeetingFormat, final  List<DateScenario> dateScenarios = const [], this.meetingRevoteRequestByRole, this.meetingRevoteRequestStatus}): _foundPlaces = foundPlaces,_filteredPlaces = filteredPlaces,_routePoints = routePoints,_votesByUser = votesByUser,_voteCounts = voteCounts,_recentAddresses = recentAddresses,_creatorMeetingFormats = creatorMeetingFormats,_partnerMeetingFormats = partnerMeetingFormats,_dateScenarios = dateScenarios,super._();
  

@override final  String? roomId;
@override final  String? inviteCode;
@override@JsonKey() final  bool isCreator;
@override@JsonKey() final  bool isLoadingRoomAction;
@override@JsonKey() final  bool isGeocoding;
@override@JsonKey() final  bool isCalculatingMeeting;
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
@override final  latlong.LatLng? point1;
@override final  latlong.LatLng? point2;
 final  List<latlong.LatLng> _routePoints;
@override@JsonKey() List<latlong.LatLng> get routePoints {
  if (_routePoints is EqualUnmodifiableListView) return _routePoints;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routePoints);
}

@override final  String? selectedType;
@override@JsonKey() final  double searchRadius;
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
@override final  int? creatorChangedRadiusTo;
@override final  int? peerSuggestedRadius;
@override final  MeetingFormat? peerSuggestedMeetingFormat;
 final  List<String> _recentAddresses;
@override@JsonKey() List<String> get recentAddresses {
  if (_recentAddresses is EqualUnmodifiableListView) return _recentAddresses;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recentAddresses);
}

@override final  Failure? lastFailure;
@override final  String? failureOperation;
@override@JsonKey() final  SessionStatus sessionStatus;
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

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DateNavigationStateCopyWith<_DateNavigationState> get copyWith => __$DateNavigationStateCopyWithImpl<_DateNavigationState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DateNavigationState&&(identical(other.roomId, roomId) || other.roomId == roomId)&&(identical(other.inviteCode, inviteCode) || other.inviteCode == inviteCode)&&(identical(other.isCreator, isCreator) || other.isCreator == isCreator)&&(identical(other.isLoadingRoomAction, isLoadingRoomAction) || other.isLoadingRoomAction == isLoadingRoomAction)&&(identical(other.isGeocoding, isGeocoding) || other.isGeocoding == isGeocoding)&&(identical(other.isCalculatingMeeting, isCalculatingMeeting) || other.isCalculatingMeeting == isCalculatingMeeting)&&(identical(other.finalChoiceName, finalChoiceName) || other.finalChoiceName == finalChoiceName)&&(identical(other.finalChoicePlace, finalChoicePlace) || other.finalChoicePlace == finalChoicePlace)&&const DeepCollectionEquality().equals(other._foundPlaces, _foundPlaces)&&const DeepCollectionEquality().equals(other._filteredPlaces, _filteredPlaces)&&(identical(other.centerPoint, centerPoint) || other.centerPoint == centerPoint)&&(identical(other.point1, point1) || other.point1 == point1)&&(identical(other.point2, point2) || other.point2 == point2)&&const DeepCollectionEquality().equals(other._routePoints, _routePoints)&&(identical(other.selectedType, selectedType) || other.selectedType == selectedType)&&(identical(other.searchRadius, searchRadius) || other.searchRadius == searchRadius)&&const DeepCollectionEquality().equals(other._votesByUser, _votesByUser)&&const DeepCollectionEquality().equals(other._voteCounts, _voteCounts)&&(identical(other.proposalPlaceName, proposalPlaceName) || other.proposalPlaceName == proposalPlaceName)&&(identical(other.proposalPlaceAddress, proposalPlaceAddress) || other.proposalPlaceAddress == proposalPlaceAddress)&&(identical(other.proposalPlaceType, proposalPlaceType) || other.proposalPlaceType == proposalPlaceType)&&(identical(other.proposalByRole, proposalByRole) || other.proposalByRole == proposalByRole)&&(identical(other.proposalStatus, proposalStatus) || other.proposalStatus == proposalStatus)&&(identical(other.creatorChangedRadiusTo, creatorChangedRadiusTo) || other.creatorChangedRadiusTo == creatorChangedRadiusTo)&&(identical(other.peerSuggestedRadius, peerSuggestedRadius) || other.peerSuggestedRadius == peerSuggestedRadius)&&(identical(other.peerSuggestedMeetingFormat, peerSuggestedMeetingFormat) || other.peerSuggestedMeetingFormat == peerSuggestedMeetingFormat)&&const DeepCollectionEquality().equals(other._recentAddresses, _recentAddresses)&&(identical(other.lastFailure, lastFailure) || other.lastFailure == lastFailure)&&(identical(other.failureOperation, failureOperation) || other.failureOperation == failureOperation)&&(identical(other.sessionStatus, sessionStatus) || other.sessionStatus == sessionStatus)&&(identical(other.selectedScenario, selectedScenario) || other.selectedScenario == selectedScenario)&&const DeepCollectionEquality().equals(other._creatorMeetingFormats, _creatorMeetingFormats)&&const DeepCollectionEquality().equals(other._partnerMeetingFormats, _partnerMeetingFormats)&&(identical(other.creatorSelectedMeetingFormat, creatorSelectedMeetingFormat) || other.creatorSelectedMeetingFormat == creatorSelectedMeetingFormat)&&(identical(other.partnerSelectedMeetingFormat, partnerSelectedMeetingFormat) || other.partnerSelectedMeetingFormat == partnerSelectedMeetingFormat)&&(identical(other.selectedMeetingFormat, selectedMeetingFormat) || other.selectedMeetingFormat == selectedMeetingFormat)&&(identical(other.lastAgreedMeetingFormat, lastAgreedMeetingFormat) || other.lastAgreedMeetingFormat == lastAgreedMeetingFormat)&&const DeepCollectionEquality().equals(other._dateScenarios, _dateScenarios)&&(identical(other.meetingRevoteRequestByRole, meetingRevoteRequestByRole) || other.meetingRevoteRequestByRole == meetingRevoteRequestByRole)&&(identical(other.meetingRevoteRequestStatus, meetingRevoteRequestStatus) || other.meetingRevoteRequestStatus == meetingRevoteRequestStatus));
}


@override
int get hashCode => Object.hashAll([runtimeType,roomId,inviteCode,isCreator,isLoadingRoomAction,isGeocoding,isCalculatingMeeting,finalChoiceName,finalChoicePlace,const DeepCollectionEquality().hash(_foundPlaces),const DeepCollectionEquality().hash(_filteredPlaces),centerPoint,point1,point2,const DeepCollectionEquality().hash(_routePoints),selectedType,searchRadius,const DeepCollectionEquality().hash(_votesByUser),const DeepCollectionEquality().hash(_voteCounts),proposalPlaceName,proposalPlaceAddress,proposalPlaceType,proposalByRole,proposalStatus,creatorChangedRadiusTo,peerSuggestedRadius,peerSuggestedMeetingFormat,const DeepCollectionEquality().hash(_recentAddresses),lastFailure,failureOperation,sessionStatus,selectedScenario,const DeepCollectionEquality().hash(_creatorMeetingFormats),const DeepCollectionEquality().hash(_partnerMeetingFormats),creatorSelectedMeetingFormat,partnerSelectedMeetingFormat,selectedMeetingFormat,lastAgreedMeetingFormat,const DeepCollectionEquality().hash(_dateScenarios),meetingRevoteRequestByRole,meetingRevoteRequestStatus]);

@override
String toString() {
  return 'DateNavigationState(roomId: $roomId, inviteCode: $inviteCode, isCreator: $isCreator, isLoadingRoomAction: $isLoadingRoomAction, isGeocoding: $isGeocoding, isCalculatingMeeting: $isCalculatingMeeting, finalChoiceName: $finalChoiceName, finalChoicePlace: $finalChoicePlace, foundPlaces: $foundPlaces, filteredPlaces: $filteredPlaces, centerPoint: $centerPoint, point1: $point1, point2: $point2, routePoints: $routePoints, selectedType: $selectedType, searchRadius: $searchRadius, votesByUser: $votesByUser, voteCounts: $voteCounts, proposalPlaceName: $proposalPlaceName, proposalPlaceAddress: $proposalPlaceAddress, proposalPlaceType: $proposalPlaceType, proposalByRole: $proposalByRole, proposalStatus: $proposalStatus, creatorChangedRadiusTo: $creatorChangedRadiusTo, peerSuggestedRadius: $peerSuggestedRadius, peerSuggestedMeetingFormat: $peerSuggestedMeetingFormat, recentAddresses: $recentAddresses, lastFailure: $lastFailure, failureOperation: $failureOperation, sessionStatus: $sessionStatus, selectedScenario: $selectedScenario, creatorMeetingFormats: $creatorMeetingFormats, partnerMeetingFormats: $partnerMeetingFormats, creatorSelectedMeetingFormat: $creatorSelectedMeetingFormat, partnerSelectedMeetingFormat: $partnerSelectedMeetingFormat, selectedMeetingFormat: $selectedMeetingFormat, lastAgreedMeetingFormat: $lastAgreedMeetingFormat, dateScenarios: $dateScenarios, meetingRevoteRequestByRole: $meetingRevoteRequestByRole, meetingRevoteRequestStatus: $meetingRevoteRequestStatus)';
}


}

/// @nodoc
abstract mixin class _$DateNavigationStateCopyWith<$Res> implements $DateNavigationStateCopyWith<$Res> {
  factory _$DateNavigationStateCopyWith(_DateNavigationState value, $Res Function(_DateNavigationState) _then) = __$DateNavigationStateCopyWithImpl;
@override @useResult
$Res call({
 String? roomId, String? inviteCode, bool isCreator, bool isLoadingRoomAction, bool isGeocoding, bool isCalculatingMeeting, String? finalChoiceName, Place? finalChoicePlace, List<Place> foundPlaces, List<Place> filteredPlaces, latlong.LatLng? centerPoint, latlong.LatLng? point1, latlong.LatLng? point2, List<latlong.LatLng> routePoints, String? selectedType, double searchRadius, Map<String, String> votesByUser, Map<String, int> voteCounts, String? proposalPlaceName, String? proposalPlaceAddress, String? proposalPlaceType, String? proposalByRole, ProposalStatus? proposalStatus, int? creatorChangedRadiusTo, int? peerSuggestedRadius, MeetingFormat? peerSuggestedMeetingFormat, List<String> recentAddresses, Failure? lastFailure, String? failureOperation, SessionStatus sessionStatus, DateScenario? selectedScenario, List<MeetingFormat> creatorMeetingFormats, List<MeetingFormat> partnerMeetingFormats, MeetingFormat? creatorSelectedMeetingFormat, MeetingFormat? partnerSelectedMeetingFormat, MeetingFormat? selectedMeetingFormat, MeetingFormat? lastAgreedMeetingFormat, List<DateScenario> dateScenarios, String? meetingRevoteRequestByRole, RevoteRequestStatus? meetingRevoteRequestStatus
});




}
/// @nodoc
class __$DateNavigationStateCopyWithImpl<$Res>
    implements _$DateNavigationStateCopyWith<$Res> {
  __$DateNavigationStateCopyWithImpl(this._self, this._then);

  final _DateNavigationState _self;
  final $Res Function(_DateNavigationState) _then;

/// Create a copy of DateNavigationState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? roomId = freezed,Object? inviteCode = freezed,Object? isCreator = null,Object? isLoadingRoomAction = null,Object? isGeocoding = null,Object? isCalculatingMeeting = null,Object? finalChoiceName = freezed,Object? finalChoicePlace = freezed,Object? foundPlaces = null,Object? filteredPlaces = null,Object? centerPoint = freezed,Object? point1 = freezed,Object? point2 = freezed,Object? routePoints = null,Object? selectedType = freezed,Object? searchRadius = null,Object? votesByUser = null,Object? voteCounts = null,Object? proposalPlaceName = freezed,Object? proposalPlaceAddress = freezed,Object? proposalPlaceType = freezed,Object? proposalByRole = freezed,Object? proposalStatus = freezed,Object? creatorChangedRadiusTo = freezed,Object? peerSuggestedRadius = freezed,Object? peerSuggestedMeetingFormat = freezed,Object? recentAddresses = null,Object? lastFailure = freezed,Object? failureOperation = freezed,Object? sessionStatus = null,Object? selectedScenario = freezed,Object? creatorMeetingFormats = null,Object? partnerMeetingFormats = null,Object? creatorSelectedMeetingFormat = freezed,Object? partnerSelectedMeetingFormat = freezed,Object? selectedMeetingFormat = freezed,Object? lastAgreedMeetingFormat = freezed,Object? dateScenarios = null,Object? meetingRevoteRequestByRole = freezed,Object? meetingRevoteRequestStatus = freezed,}) {
  return _then(_DateNavigationState(
roomId: freezed == roomId ? _self.roomId : roomId // ignore: cast_nullable_to_non_nullable
as String?,inviteCode: freezed == inviteCode ? _self.inviteCode : inviteCode // ignore: cast_nullable_to_non_nullable
as String?,isCreator: null == isCreator ? _self.isCreator : isCreator // ignore: cast_nullable_to_non_nullable
as bool,isLoadingRoomAction: null == isLoadingRoomAction ? _self.isLoadingRoomAction : isLoadingRoomAction // ignore: cast_nullable_to_non_nullable
as bool,isGeocoding: null == isGeocoding ? _self.isGeocoding : isGeocoding // ignore: cast_nullable_to_non_nullable
as bool,isCalculatingMeeting: null == isCalculatingMeeting ? _self.isCalculatingMeeting : isCalculatingMeeting // ignore: cast_nullable_to_non_nullable
as bool,finalChoiceName: freezed == finalChoiceName ? _self.finalChoiceName : finalChoiceName // ignore: cast_nullable_to_non_nullable
as String?,finalChoicePlace: freezed == finalChoicePlace ? _self.finalChoicePlace : finalChoicePlace // ignore: cast_nullable_to_non_nullable
as Place?,foundPlaces: null == foundPlaces ? _self._foundPlaces : foundPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,filteredPlaces: null == filteredPlaces ? _self._filteredPlaces : filteredPlaces // ignore: cast_nullable_to_non_nullable
as List<Place>,centerPoint: freezed == centerPoint ? _self.centerPoint : centerPoint // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,point1: freezed == point1 ? _self.point1 : point1 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,point2: freezed == point2 ? _self.point2 : point2 // ignore: cast_nullable_to_non_nullable
as latlong.LatLng?,routePoints: null == routePoints ? _self._routePoints : routePoints // ignore: cast_nullable_to_non_nullable
as List<latlong.LatLng>,selectedType: freezed == selectedType ? _self.selectedType : selectedType // ignore: cast_nullable_to_non_nullable
as String?,searchRadius: null == searchRadius ? _self.searchRadius : searchRadius // ignore: cast_nullable_to_non_nullable
as double,votesByUser: null == votesByUser ? _self._votesByUser : votesByUser // ignore: cast_nullable_to_non_nullable
as Map<String, String>,voteCounts: null == voteCounts ? _self._voteCounts : voteCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,proposalPlaceName: freezed == proposalPlaceName ? _self.proposalPlaceName : proposalPlaceName // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceAddress: freezed == proposalPlaceAddress ? _self.proposalPlaceAddress : proposalPlaceAddress // ignore: cast_nullable_to_non_nullable
as String?,proposalPlaceType: freezed == proposalPlaceType ? _self.proposalPlaceType : proposalPlaceType // ignore: cast_nullable_to_non_nullable
as String?,proposalByRole: freezed == proposalByRole ? _self.proposalByRole : proposalByRole // ignore: cast_nullable_to_non_nullable
as String?,proposalStatus: freezed == proposalStatus ? _self.proposalStatus : proposalStatus // ignore: cast_nullable_to_non_nullable
as ProposalStatus?,creatorChangedRadiusTo: freezed == creatorChangedRadiusTo ? _self.creatorChangedRadiusTo : creatorChangedRadiusTo // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedRadius: freezed == peerSuggestedRadius ? _self.peerSuggestedRadius : peerSuggestedRadius // ignore: cast_nullable_to_non_nullable
as int?,peerSuggestedMeetingFormat: freezed == peerSuggestedMeetingFormat ? _self.peerSuggestedMeetingFormat : peerSuggestedMeetingFormat // ignore: cast_nullable_to_non_nullable
as MeetingFormat?,recentAddresses: null == recentAddresses ? _self._recentAddresses : recentAddresses // ignore: cast_nullable_to_non_nullable
as List<String>,lastFailure: freezed == lastFailure ? _self.lastFailure : lastFailure // ignore: cast_nullable_to_non_nullable
as Failure?,failureOperation: freezed == failureOperation ? _self.failureOperation : failureOperation // ignore: cast_nullable_to_non_nullable
as String?,sessionStatus: null == sessionStatus ? _self.sessionStatus : sessionStatus // ignore: cast_nullable_to_non_nullable
as SessionStatus,selectedScenario: freezed == selectedScenario ? _self.selectedScenario : selectedScenario // ignore: cast_nullable_to_non_nullable
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

// dart format on
