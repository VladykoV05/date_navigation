import 'package:flutter/widgets.dart';

import '../../../../../core/l10n/l10n_extensions.dart';
import '../../view_data/place_view_data.dart';

class MeetingFormatStatusCopy {
  const MeetingFormatStatusCopy._();

  static String statusText({
    required BuildContext context,
    required bool isCreator,
    required List<MeetingFormatView> myFormats,
    required List<MeetingFormatView> partnerFormats,
    required List<MeetingFormatView> commonMeetingFormats,
    required MeetingFormatView? selectedMeetingFormat,
    required MeetingFormatView? mySelectedMeetingFormat,
    required MeetingFormatView? lastAgreedMeetingFormat,
    required String? meetingRevoteRequestByRole,
    required RevoteRequestStatusView? meetingRevoteRequestStatus,
  }) {
    final l10n = context.l10n;
    if (meetingRevoteRequestStatus?.isPending ?? false) {
      final requestedByMe =
          (isCreator && meetingRevoteRequestByRole == 'creator') ||
          (!isCreator && meetingRevoteRequestByRole == 'partner');
      return requestedByMe
          ? l10n.formatStatusRevoteRequestedByMe
          : l10n.formatStatusRevoteRequestedByPartner;
    }
    if (myFormats.isEmpty || partnerFormats.isEmpty) {
      return l10n.formatStatusSelectBoth;
    }
    if (selectedMeetingFormat != null) {
      return l10n.formatStatusAgreed(
        selectedMeetingFormat.localizedLabel(l10n),
      );
    }
    if (mySelectedMeetingFormat != null) {
      return l10n.formatStatusConfirmedByMe(
        mySelectedMeetingFormat.localizedLabel(l10n),
      );
    }
    if (commonMeetingFormats.isEmpty) return l10n.formatStatusNoCommon;
    if (lastAgreedMeetingFormat != null) {
      return l10n.formatStatusRevotingNow(
        lastAgreedMeetingFormat.localizedLabel(l10n),
      );
    }
    return l10n.formatStatusReadyToConfirm;
  }

  static String confirmationLine({
    required BuildContext context,
    required MeetingFormatView? mySelectedMeetingFormat,
    required MeetingFormatView? partnerSelectedMeetingFormat,
  }) {
    final l10n = context.l10n;
    final myText =
        mySelectedMeetingFormat?.localizedLabel(l10n) ??
        l10n.formatConfirmationMissing;
    final partnerText =
        partnerSelectedMeetingFormat?.localizedLabel(l10n) ??
        l10n.formatConfirmationMissing;
    return l10n.formatConfirmationLine(myText, partnerText);
  }
}
