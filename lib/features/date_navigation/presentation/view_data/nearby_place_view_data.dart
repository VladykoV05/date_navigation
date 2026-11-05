class NearbyPlaceViewData {
  const NearbyPlaceViewData({
    required this.name,
    required this.lat,
    required this.lon,
    this.address,
  });

  final String name;
  final double lat;
  final double lon;
  final String? address;
}
