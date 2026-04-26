class AccountHistoryItem {
  final String id;
  final String placeName;
  final String? placeAddress;
  final String? placeType;
  final double? lat;
  final double? lon;
  final DateTime? createdAt;
  final String? roomId;
  final String? counterpartyUid;

  const AccountHistoryItem({
    required this.id,
    required this.placeName,
    this.placeAddress,
    this.placeType,
    this.lat,
    this.lon,
    this.createdAt,
    this.roomId,
    this.counterpartyUid,
  });
}
