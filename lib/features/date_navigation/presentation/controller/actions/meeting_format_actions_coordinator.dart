import '../../../../../core/error/failure.dart';
import '../../../domain/entities/date_vibe.dart';
import '../../state/date_navigation_state.dart';

enum MeetingFormatActionType {
  noop,
  requestRevote,
  selectFormats,
  confirmFormat,
  error,
}

class MeetingFormatActionDecision {
  const MeetingFormatActionDecision._({
    required this.type,
    this.formats,
    this.format,
    this.failure,
  });

  const MeetingFormatActionDecision.noop()
    : this._(type: MeetingFormatActionType.noop);

  const MeetingFormatActionDecision.requestRevote(Set<MeetingFormat> formats)
    : this._(type: MeetingFormatActionType.requestRevote, formats: formats);

  const MeetingFormatActionDecision.selectFormats(Set<MeetingFormat> formats)
    : this._(type: MeetingFormatActionType.selectFormats, formats: formats);

  const MeetingFormatActionDecision.confirmFormat(MeetingFormat format)
    : this._(type: MeetingFormatActionType.confirmFormat, format: format);

  const MeetingFormatActionDecision.error(Failure failure)
    : this._(type: MeetingFormatActionType.error, failure: failure);

  final MeetingFormatActionType type;
  final Set<MeetingFormat>? formats;
  final MeetingFormat? format;
  final Failure? failure;
}

class MeetingFormatActionsCoordinator {
  const MeetingFormatActionsCoordinator();

  MeetingFormatActionDecision resolveSetFormatsAction({
    required DateNavigationState state,
    required Set<MeetingFormat> nextFormats,
  }) {
    final currentMyFormats = state.isCreator
        ? state.creatorMeetingFormats.toSet()
        : state.partnerMeetingFormats.toSet();
    final normalizedNext = nextFormats.toSet();
    final hasChanges =
        currentMyFormats.length != normalizedNext.length ||
        !currentMyFormats.containsAll(normalizedNext);
    if (!hasChanges) return const MeetingFormatActionDecision.noop();
    final hasAgreedFormat = state.selectedMeetingFormat != null;
    final hasPendingRevoteRequest =
        state.meetingRevoteRequestStatus?.isPending ?? false;
    if (!hasAgreedFormat) {
      return MeetingFormatActionDecision.selectFormats(normalizedNext);
    }
    if (hasPendingRevoteRequest) {
      return const MeetingFormatActionDecision.noop();
    }
    return MeetingFormatActionDecision.requestRevote(normalizedNext);
  }

  MeetingFormatActionDecision resolveConfirmFormatAction({
    required DateNavigationState state,
    required MeetingFormat format,
  }) {
    if (!state.commonMeetingFormats.contains(format)) {
      return const MeetingFormatActionDecision.error(
        UnknownFailure('Выберите формат только из общих вариантов'),
      );
    }
    final agreedFormat = state.selectedMeetingFormat;
    final changingAlreadyAgreedFormat =
        agreedFormat != null && agreedFormat != format;
    if (!changingAlreadyAgreedFormat) {
      return MeetingFormatActionDecision.confirmFormat(format);
    }
    if (state.meetingRevoteRequestStatus?.isPending ?? false) {
      return const MeetingFormatActionDecision.noop();
    }
    final myFormats =
        (state.isCreator
                ? state.creatorMeetingFormats
                : state.partnerMeetingFormats)
            .toSet();
    return MeetingFormatActionDecision.requestRevote(myFormats);
  }
}
