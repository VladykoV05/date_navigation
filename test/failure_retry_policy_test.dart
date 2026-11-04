import 'package:date_navigation/core/error/failure.dart';
import 'package:date_navigation/core/error/failure_codes.dart';
import 'package:date_navigation/features/date_navigation/application/policies/failure_retry_policy.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const policy = FailureRetryPolicy();

  test('meeting network failure retries when both points exist', () {
    final action = policy.actionFor(
      failure: const NetworkFailure(FailureCodes.routingFailed),
      failureOperation: 'meeting',
      hasBothPoints: true,
    );
    expect(action, FailureRetryAction.recalculateMeeting);
  });

  test('meeting failure without points is not retryable', () {
    final action = policy.actionFor(
      failure: const NetworkFailure(FailureCodes.routingFailed),
      failureOperation: 'meeting',
      hasBothPoints: false,
    );
    expect(action, FailureRetryAction.none);
  });

  test('geocode rate limit is retryable', () {
    final action = policy.actionFor(
      failure: const RateLimitFailure(FailureCodes.geocodingRateLimit),
      failureOperation: 'geocode',
      hasBothPoints: false,
    );
    expect(action, FailureRetryAction.retryGeocode);
  });

  test('room stream failure resubscribes', () {
    final action = policy.actionFor(
      failure: const NetworkFailure(FailureCodes.roomStreamFailed),
      failureOperation: 'room_stream',
      hasBothPoints: true,
    );
    expect(action, FailureRetryAction.resubscribeRoom);
  });

  test('parse failure is not retryable', () {
    expect(
      policy.canRetry(
        failure: const ParseFailure(FailureCodes.routingFailed),
        failureOperation: 'meeting',
        hasBothPoints: true,
      ),
      isFalse,
    );
  });
}
