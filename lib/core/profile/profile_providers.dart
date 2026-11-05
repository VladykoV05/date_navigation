import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'public_profile.dart';
import 'public_profile_remote_data_source.dart';
import 'public_profile_repository.dart';
import 'public_profile_repository_impl.dart';

/// Данные профиля для показа (примитивы, без доменных сущностей в UI).
class PublicProfileViewData {
  const PublicProfileViewData({
    required this.uid,
    this.shownName,
    this.displayName,
    this.photoUrl,
    this.avatarBase64,
    this.avatarPreset,
  });

  final String uid;
  final String? shownName;
  final String? displayName;
  final String? photoUrl;
  final String? avatarBase64;
  final int? avatarPreset;
}

final publicProfileRepositoryProvider = Provider<PublicProfileRepository>((
  ref,
) {
  return PublicProfileRepositoryImpl(
    PublicProfileRemoteDataSource(FirebaseFirestore.instance),
  );
});

/// Профиль для показа; null — профиля ещё нет.
final publicProfileViewProvider =
    StreamProvider.family<PublicProfileViewData?, String>((ref, uid) {
      return ref.watch(publicProfileRepositoryProvider).watch(uid).map((
        PublicProfile? profile,
      ) {
        if (profile == null) return null;
        return PublicProfileViewData(
          uid: profile.uid,
          shownName: profile.shownName,
          displayName: profile.displayName,
          photoUrl: profile.photoUrl,
          avatarBase64: profile.avatarBase64,
          avatarPreset: profile.avatarPreset,
        );
      });
    });
