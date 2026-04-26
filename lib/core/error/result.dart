import 'failure.dart';

sealed class Result<T> {
  const Result();
  bool get isSuccess => this is Ok<T>;
  bool get isFailure => this is Err<T>;
}

class Ok<T> extends Result<T> {
  final T value;
  const Ok(this.value);
}

class Err<T> extends Result<T> {
  final Failure failure;
  const Err(this.failure);
}
