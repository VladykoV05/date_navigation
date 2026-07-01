// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(favoritesRepository)
final favoritesRepositoryProvider = FavoritesRepositoryProvider._();

final class FavoritesRepositoryProvider
    extends
        $FunctionalProvider<
          FavoritesRepository,
          FavoritesRepository,
          FavoritesRepository
        >
    with $Provider<FavoritesRepository> {
  FavoritesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesRepositoryHash();

  @$internal
  @override
  $ProviderElement<FavoritesRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FavoritesRepository create(Ref ref) {
    return favoritesRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavoritesRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavoritesRepository>(value),
    );
  }
}

String _$favoritesRepositoryHash() =>
    r'50517b266009c1a2480a0266911b00859585db21';

@ProviderFor(addressMemoryRepository)
final addressMemoryRepositoryProvider = AddressMemoryRepositoryProvider._();

final class AddressMemoryRepositoryProvider
    extends
        $FunctionalProvider<
          AddressMemoryRepository,
          AddressMemoryRepository,
          AddressMemoryRepository
        >
    with $Provider<AddressMemoryRepository> {
  AddressMemoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addressMemoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addressMemoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<AddressMemoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AddressMemoryRepository create(Ref ref) {
    return addressMemoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddressMemoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddressMemoryRepository>(value),
    );
  }
}

String _$addressMemoryRepositoryHash() =>
    r'a9c5f23f2ca05a53e26c7ce6c0fef9fce46b4e1e';

@ProviderFor(meetingHistoryRepository)
final meetingHistoryRepositoryProvider = MeetingHistoryRepositoryProvider._();

final class MeetingHistoryRepositoryProvider
    extends
        $FunctionalProvider<
          MeetingHistoryRepository,
          MeetingHistoryRepository,
          MeetingHistoryRepository
        >
    with $Provider<MeetingHistoryRepository> {
  MeetingHistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingHistoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingHistoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeetingHistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeetingHistoryRepository create(Ref ref) {
    return meetingHistoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingHistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingHistoryRepository>(value),
    );
  }
}

String _$meetingHistoryRepositoryHash() =>
    r'd41cdc21a71eb089836bc4b84f5e3922bba03b53';

@ProviderFor(userProfileRepository)
final userProfileRepositoryProvider = UserProfileRepositoryProvider._();

final class UserProfileRepositoryProvider
    extends
        $FunctionalProvider<
          UserProfileRepository,
          UserProfileRepository,
          UserProfileRepository
        >
    with $Provider<UserProfileRepository> {
  UserProfileRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileRepositoryHash();

  @$internal
  @override
  $ProviderElement<UserProfileRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  UserProfileRepository create(Ref ref) {
    return userProfileRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserProfileRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserProfileRepository>(value),
    );
  }
}

String _$userProfileRepositoryHash() =>
    r'f37c52f7d7fc5c7c13ec42087dff35432e81fda9';
