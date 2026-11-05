/// Публичный профиль: видят все вошедшие пользователи (см. design 10.1).
class PublicProfile {
  const PublicProfile({
    required this.uid,
    this.displayName,
    this.googleName,
    this.photoUrl,
    this.avatarBase64,
    this.avatarPreset,
  });

  final String uid;

  /// Имя, которое выбрал пользователь (переименование). Null — берём googleName.
  final String? displayName;

  /// Имя из Google-аккаунта, обновляется при каждом входе.
  final String? googleName;

  /// Google-фото по умолчанию.
  final String? photoUrl;

  /// Фото из галереи: 128×128 JPEG в base64.
  final String? avatarBase64;

  /// Индекс встроенного аватара (0..11).
  final int? avatarPreset;

  String? get shownName {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final google = googleName?.trim();
    if (google != null && google.isNotEmpty) return google;
    return null;
  }
}
