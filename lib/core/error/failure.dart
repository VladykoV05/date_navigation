sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class TimeoutFailure extends Failure {
  const TimeoutFailure(super.message);
}

class RateLimitFailure extends Failure {
  const RateLimitFailure(super.message);
}

class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}
