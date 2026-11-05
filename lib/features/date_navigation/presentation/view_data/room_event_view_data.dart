import '../../domain/entities/room_snapshot.dart';

class RoomEventViewData {
  const RoomEventViewData({
    required this.title,
    this.venueName,
    this.address,
    this.category,
    this.startsAt,
    this.lat,
    this.lon,
    this.sourceUrl,
  });

  factory RoomEventViewData.fromSnapshot(RoomEventSnapshot event) {
    return RoomEventViewData(
      title: event.title,
      venueName: event.venueName,
      address: event.address,
      category: event.category,
      startsAt: event.startsAt,
      lat: event.lat,
      lon: event.lon,
      sourceUrl: event.sourceUrl,
    );
  }

  final String title;
  final String? venueName;
  final String? address;
  final String? category;
  final DateTime? startsAt;
  final double? lat;
  final double? lon;
  final String? sourceUrl;
}
