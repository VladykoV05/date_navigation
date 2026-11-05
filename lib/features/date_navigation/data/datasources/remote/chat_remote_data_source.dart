import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/error/failure_codes.dart';
import '../../../../../core/error/result.dart';
import '../../../domain/entities/chat_message.dart';

class ChatRemoteDataSource {
  const ChatRemoteDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> _messages(String roomId) {
    return _firestore.collection('rooms').doc(roomId).collection('messages');
  }

  Stream<List<ChatMessage>> watchMessages(String roomId, {int limit = 50}) {
    return _messages(roomId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map(_fromDocument).toList(growable: false),
        );
  }

  Future<Result<List<ChatMessage>>> fetchMessages({
    required String roomId,
    required int limit,
    DateTime? before,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _messages(
        roomId,
      ).orderBy('createdAt', descending: true);
      if (before != null) {
        query = query.endBefore([Timestamp.fromDate(before)]);
      }
      final snapshot = await query.limit(limit).get();
      return Ok(snapshot.docs.map(_fromDocument).toList(growable: false));
    } on FirebaseException catch (e) {
      return Err(_mapFailure(e, FailureCodes.chatLoadFailed));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.chatLoadFailed));
    }
  }

  Stream<DateTime?> watchLastRead({
    required String roomId,
    required String userId,
  }) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('reads')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
          final raw = snapshot.data()?['lastReadAt'];
          return raw is Timestamp ? raw.toDate() : null;
        });
  }

  Future<Result<void>> sendMessage({
    required String roomId,
    required String senderUid,
    required String text,
    required String clientId,
  }) async {
    try {
      await _messages(roomId).add({
        'senderUid': senderUid,
        'kind': ChatMessageKind.text.wireValue,
        'text': text,
        'clientId': clientId,
        'createdAt': FieldValue.serverTimestamp(),
      });
      return const Ok(null);
    } on FirebaseException catch (e) {
      return Err(_mapFailure(e, FailureCodes.chatSendFailed));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.chatSendFailed));
    }
  }

  Future<Result<void>> markRead({
    required String roomId,
    required String userId,
  }) async {
    try {
      await _firestore
          .collection('rooms')
          .doc(roomId)
          .collection('reads')
          .doc(userId)
          .set({
            'lastReadAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
      return const Ok(null);
    } on FirebaseException catch (e) {
      return Err(_mapFailure(e, FailureCodes.chatReadFailed));
    } catch (_) {
      return const Err(UnknownFailure(FailureCodes.chatReadFailed));
    }
  }

  static ChatMessage _fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data() ?? const <String, dynamic>{};
    final createdAt = data['createdAt'];
    return ChatMessage(
      id: document.id,
      senderUid: (data['senderUid'] ?? '').toString(),
      text: (data['text'] ?? '').toString(),
      kind: ChatMessageKind.fromWireValue(data['kind']),
      createdAt: createdAt is Timestamp ? createdAt.toDate() : null,
      clientId: data['clientId']?.toString(),
    );
  }

  Failure _mapFailure(FirebaseException e, String fallback) {
    return switch (e.code) {
      'permission-denied' => const UnknownFailure(
        FailureCodes.permissionDenied,
      ),
      'unavailable' => const NetworkFailure(FailureCodes.serviceUnavailable),
      _ => UnknownFailure(fallback),
    };
  }
}
