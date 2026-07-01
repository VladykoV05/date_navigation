import 'package:freezed_annotation/freezed_annotation.dart';

part 'meeting_history_item.freezed.dart';

@freezed
abstract class MeetingHistoryItem with _$MeetingHistoryItem {
  const factory MeetingHistoryItem({
    required String id,
    required String placeName,
    String? placeAddress,
    String? placeType,
    double? lat,
    double? lon,
    DateTime? createdAt,
    String? roomId,
    String? counterpartyUid,
  }) = _MeetingHistoryItem;
}
