import '../../../../core/error/failure.dart';
import '../../../../core/error/failure_codes.dart';
import '../../domain/entities/date_vibe.dart';

class MeetingGuardPolicy {
  const MeetingGuardPolicy();

  Failure? ensureSessionActive({required bool isSessionClosed}) {
    if (!isSessionClosed) return null;
    return const UnknownFailure(FailureCodes.sessionAlreadyEnded);
  }

  Failure? ensureMeetingFormatMatched({
    required MeetingFormat? selectedMeetingFormat,
  }) {
    if (selectedMeetingFormat != null) return null;
    return const UnknownFailure(FailureCodes.pickFormatBeforePlace);
  }
}
