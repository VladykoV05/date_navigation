// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(roomSessionRepository)
final roomSessionRepositoryProvider = RoomSessionRepositoryProvider._();

final class RoomSessionRepositoryProvider
    extends
        $FunctionalProvider<
          RoomSessionRepository,
          RoomSessionRepository,
          RoomSessionRepository
        >
    with $Provider<RoomSessionRepository> {
  RoomSessionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomSessionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomSessionRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomSessionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoomSessionRepository create(Ref ref) {
    return roomSessionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomSessionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomSessionRepository>(value),
    );
  }
}

String _$roomSessionRepositoryHash() =>
    r'9e0524410fd8b47e3ffd9b7a6a1131e159dfa5f7';

@ProviderFor(roomVotingRepository)
final roomVotingRepositoryProvider = RoomVotingRepositoryProvider._();

final class RoomVotingRepositoryProvider
    extends
        $FunctionalProvider<
          RoomVotingRepository,
          RoomVotingRepository,
          RoomVotingRepository
        >
    with $Provider<RoomVotingRepository> {
  RoomVotingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomVotingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomVotingRepositoryHash();

  @$internal
  @override
  $ProviderElement<RoomVotingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RoomVotingRepository create(Ref ref) {
    return roomVotingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RoomVotingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RoomVotingRepository>(value),
    );
  }
}

String _$roomVotingRepositoryHash() =>
    r'38ffde1a28092cdb3ac8722b3952f6b5c84004a5';

@ProviderFor(meetingSnapshotRepository)
final meetingSnapshotRepositoryProvider = MeetingSnapshotRepositoryProvider._();

final class MeetingSnapshotRepositoryProvider
    extends
        $FunctionalProvider<
          MeetingSnapshotRepository,
          MeetingSnapshotRepository,
          MeetingSnapshotRepository
        >
    with $Provider<MeetingSnapshotRepository> {
  MeetingSnapshotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingSnapshotRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingSnapshotRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeetingSnapshotRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeetingSnapshotRepository create(Ref ref) {
    return meetingSnapshotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingSnapshotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingSnapshotRepository>(value),
    );
  }
}

String _$meetingSnapshotRepositoryHash() =>
    r'd6f241dc82c97255c79e495ddef81c1d61997032';

@ProviderFor(geocodingRepository)
final geocodingRepositoryProvider = GeocodingRepositoryProvider._();

final class GeocodingRepositoryProvider
    extends
        $FunctionalProvider<
          GeocodingRepository,
          GeocodingRepository,
          GeocodingRepository
        >
    with $Provider<GeocodingRepository> {
  GeocodingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geocodingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geocodingRepositoryHash();

  @$internal
  @override
  $ProviderElement<GeocodingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GeocodingRepository create(Ref ref) {
    return geocodingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GeocodingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GeocodingRepository>(value),
    );
  }
}

String _$geocodingRepositoryHash() =>
    r'5a0292535be4967a13a3d70ffd5010f70fb84c88';

@ProviderFor(meetingRepository)
final meetingRepositoryProvider = MeetingRepositoryProvider._();

final class MeetingRepositoryProvider
    extends
        $FunctionalProvider<
          MeetingRepository,
          MeetingRepository,
          MeetingRepository
        >
    with $Provider<MeetingRepository> {
  MeetingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meetingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meetingRepositoryHash();

  @$internal
  @override
  $ProviderElement<MeetingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MeetingRepository create(Ref ref) {
    return meetingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MeetingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MeetingRepository>(value),
    );
  }
}

String _$meetingRepositoryHash() => r'ada510aa3d830635eb74618216866f868554bd92';
