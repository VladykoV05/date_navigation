class AccountFavorite {
  final String id;
  final String name;
  final String? address;
  final String? type;
  final double? lat;
  final double? lon;

  const AccountFavorite({
    required this.id,
    required this.name,
    this.address,
    this.type,
    this.lat,
    this.lon,
  });
}
