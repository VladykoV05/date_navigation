import '../../domain/entities/room_snapshot.dart';

class RoomEventViewData {
  const RoomEventViewData({
    required this.title,
    this.venueName,
    this.address,
    this.category,
    this.startsAt,
  });

  factory RoomEventViewData.fromSnapshot(RoomEventSnapshot event) {
    return RoomEventViewData(
      title: event.title,
      venueName: event.venueName,
      address: event.address,
      category: event.category,
      startsAt: event.startsAt,
    );
  }

  final String title;
  final String? venueName;
  final String? address;
  final String? category;
  final DateTime? startsAt;
}
