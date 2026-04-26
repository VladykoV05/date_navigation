import '../../../../../core/utils/app_logger.dart';
import '../../../domain/entities/place.dart';

enum PlaceDiscoveryMode { strictOnly, strictThenSoft }

class PlaceDiscoveryPipeline {
  const PlaceDiscoveryPipeline({
    required bool Function(Place place) matchesFormat,
    required bool Function(Place place) isUsablePlace,
    required String diagnosticsLabel,
    required String allowedTypesLabel,
    this.mode = PlaceDiscoveryMode.strictOnly,
  }) : _matchesFormat = matchesFormat,
       _isUsablePlace = isUsablePlace,
       _diagnosticsLabel = diagnosticsLabel,
       _allowedTypesLabel = allowedTypesLabel;

  final bool Function(Place place) _matchesFormat;
  final bool Function(Place place) _isUsablePlace;
  final String _diagnosticsLabel;
  final String _allowedTypesLabel;
  final PlaceDiscoveryMode mode;

  List<Place> resolve(List<Place> candidates) {
    AppLogger.i(
      'PlaceDiscoveryPipeline($_diagnosticsLabel, candidates=${candidates.length}, mode=$mode)',
    );
    final strict = candidates
        .where(_matchesFormat)
        .where(_isUsablePlace)
        .toList(growable: false);
    AppLogger.i(
      'PlaceDiscoveryPipeline(strict=${strict.length}, allowedTypes=$_allowedTypesLabel)',
    );
    if (strict.isNotEmpty || mode == PlaceDiscoveryMode.strictOnly) {
      return strict;
    }

    final soft = candidates.where(_isUsablePlace).toList(growable: false);
    AppLogger.i('PlaceDiscoveryPipeline(soft=${soft.length})');
    return soft;
  }
}
