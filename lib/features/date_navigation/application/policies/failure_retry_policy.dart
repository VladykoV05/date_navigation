import '../../../../core/error/failure.dart';

/// Decides whether a failure banner can offer Retry, and which action to run.
enum FailureRetryAction {
  none,
  recalculateMeeting,
  retryGeocode,
  resubscribeRoom,
}

class FailureRetryPolicy {
  const FailureRetryPolicy();

  FailureRetryAction actionFor({
    required Failure failure,
    required String? failureOperation,
    required bool hasBothPoints,
  }) {
    if (!failure.isRetryable) return FailureRetryAction.none;

    return switch (failureOperation) {
      'meeting' when hasBothPoints => FailureRetryAction.recalculateMeeting,
      'geocode' => FailureRetryAction.retryGeocode,
      'room_stream' => FailureRetryAction.resubscribeRoom,
      _ => FailureRetryAction.none,
    };
  }

  bool canRetry({
    required Failure failure,
    required String? failureOperation,
    required bool hasBothPoints,
  }) =>
      actionFor(
        failure: failure,
        failureOperation: failureOperation,
        hasBothPoints: hasBothPoints,
      ) !=
      FailureRetryAction.none;
}
