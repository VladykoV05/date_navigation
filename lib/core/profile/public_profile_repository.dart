import '../error/result.dart';
import 'public_profile.dart';

abstract interface class PublicProfileRepository {
  Stream<PublicProfile?> watch(String uid);

  /// Вызывается при входе: обновляет googleName и photoUrl, не трогая
  /// displayName, который пользователь мог переименовать.
  Future<Result<void>> syncFromAuth({
    required String uid,
    String? googleName,
    String? photoUrl,
  });

  Future<Result<void>> rename({required String uid, required String name});

  /// Фото из галереи (base64 JPEG). Сбрасывает встроенный аватар.
  Future<Result<void>> setAvatarBase64({
    required String uid,
    required String avatarBase64,
  });

  /// Встроенный аватар. Сбрасывает фото из галереи.
  Future<Result<void>> setPreset({required String uid, required int preset});

  /// Возврат к Google-фото: очищает галерею и встроенный аватар.
  Future<Result<void>> resetAvatar({required String uid});
}
