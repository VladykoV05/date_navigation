import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/result.dart';

typedef FirestoreFailureMapper =
    Failure Function(FirebaseException e, {required String fallback});

class FirestoreErrorGuard {
  const FirestoreErrorGuard._();

  static Future<Result<T>> run<T>(
    Future<T> Function() action, {
    required FirestoreFailureMapper mapper,
    required String fallback,
  }) async {
    try {
      return Ok(await action());
    } on FirebaseException catch (e) {
      return mapFirebase(e, mapper: mapper, fallback: fallback);
    } catch (_) {
      return mapUnknown(fallback);
    }
  }

  static Future<Result<void>> runVoid(
    Future<void> Function() action, {
    required FirestoreFailureMapper mapper,
    required String fallback,
  }) async {
    try {
      await action();
      return const Ok(null);
    } on FirebaseException catch (e) {
      return mapFirebase(e, mapper: mapper, fallback: fallback);
    } catch (_) {
      return mapUnknown(fallback);
    }
  }

  static Future<Result<void>> runVoidWithFallback(
    Future<void> Function() action, {
    required FirestoreFailureMapper mapper,
    required String Function(FirebaseException) fallbackFor,
    required String unknownFallback,
  }) async {
    try {
      await action();
      return const Ok(null);
    } on FirebaseException catch (e) {
      final fallback = fallbackFor(e);
      return mapFirebase(e, mapper: mapper, fallback: fallback);
    } catch (_) {
      return mapUnknown(unknownFallback);
    }
  }

  static Result<T> mapFirebase<T>(
    FirebaseException e, {
    required FirestoreFailureMapper mapper,
    required String fallback,
  }) {
    return Err(mapper(e, fallback: fallback));
  }

  static Result<T> mapUnknown<T>(String message) {
    return Err(UnknownFailure(message));
  }
}
