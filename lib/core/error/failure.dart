sealed class Failure {
  final String message;
  const Failure(this.message);

  /// Whether retrying the failed operation can succeed (intrinsic to the failure).
  bool get isRetryable => false;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);

  @override
  bool get isRetryable => true;
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);

  @override
  bool get isRetryable => true;
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);

  @override
  bool get isRetryable => true;
}

class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
