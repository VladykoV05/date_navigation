import '../../domain/entities/room_snapshot.dart';

class OpenParticipantViewData {
  const OpenParticipantViewData({
    required this.uid,
    required this.isHost,
    required this.hasAddress,
  });

  factory OpenParticipantViewData.fromParticipant(RoomParticipant participant) {
    return OpenParticipantViewData(
      uid: participant.uid,
      isHost: participant.role == RoomParticipantRole.host,
      hasAddress: participant.point != null,
    );
  }

  final String uid;
  final bool isHost;
  final bool hasAddress;
}
