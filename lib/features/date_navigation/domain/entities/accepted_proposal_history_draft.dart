class AcceptedProposalHistoryDraft {
  const AcceptedProposalHistoryDraft({
    required this.roomId,
    required this.placeName,
    required this.participantIds,
    this.placeAddress,
    this.placeType,
    this.lat,
    this.lon,
  });

  final String roomId;
  final String placeName;
  final List<String> participantIds;
  final String? placeAddress;
  final String? placeType;
  final double? lat;
  final double? lon;
}
