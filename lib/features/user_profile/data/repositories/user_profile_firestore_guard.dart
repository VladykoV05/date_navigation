import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/error/result.dart';

Future<Result<void>> runUserProfileVoid(
  Future<void> Function() action, {
  required String fallback,
}) async {
  try {
    await action();
    return const Ok(null);
  } on FirebaseException catch (e) {
    return Err(_mapFirestoreFailure(e, fallback: fallback));
  } catch (_) {
    return Err(UnknownFailure(fallback));
  }
}

Failure _mapFirestoreFailure(
  FirebaseException e, {
  required String fallback,
}) {
  return switch (e.code) {
    'unavailable' => const NetworkFailure('Сервис временно недоступен'),
    'permission-denied' => const UnknownFailure('Нет прав для операции'),
    _ => UnknownFailure(fallback),
  };
}
