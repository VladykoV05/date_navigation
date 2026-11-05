import '../error/result.dart';
import 'public_profile.dart';
import 'public_profile_repository.dart';
import 'public_profile_remote_data_source.dart';

class PublicProfileRepositoryImpl implements PublicProfileRepository {
  PublicProfileRepositoryImpl(this._remote);

  final PublicProfileRemoteDataSource _remote;

  @override
  Stream<PublicProfile?> watch(String uid) => _remote.watch(uid);

  @override
  Future<Result<void>> syncFromAuth({
    required String uid,
    String? googleName,
    String? photoUrl,
  }) => _remote.syncFromAuth(
    uid: uid,
    googleName: googleName,
    photoUrl: photoUrl,
  );

  @override
  Future<Result<void>> rename({required String uid, required String name}) =>
      _remote.rename(uid, name);

  @override
  Future<Result<void>> setAvatarBase64({
    required String uid,
    required String avatarBase64,
  }) => _remote.setAvatarBase64(uid, avatarBase64);

  @override
  Future<Result<void>> setPreset({required String uid, required int preset}) =>
      _remote.setPreset(uid, preset);

  @override
  Future<Result<void>> resetAvatar({required String uid}) =>
      _remote.resetAvatar(uid);
}
