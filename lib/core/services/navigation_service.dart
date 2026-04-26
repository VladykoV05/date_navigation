import 'package:url_launcher/url_launcher.dart';

class NavigationService {
  Future<bool> openYandexMaps({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) async {
    final yandexUrl =
        'yandexmaps://build_route_on_map?'
        'lat_from=$startLat&lon_from=$startLon&'
        'lat_to=$endLat&lon_to=$endLon&'
        'route_list=auto';

    final webUrl =
        'https://yandex.ru/maps/?rtext=$startLat,$startLon~$endLat,$endLon&rtt=auto';

    final uri = Uri.parse(yandexUrl);

    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    } else {
      final webUri = Uri.parse(webUrl);
      return launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }

  Future<bool> openGoogleMaps({
    required double startLat,
    required double startLon,
    required double endLat,
    required double endLon,
  }) async {
    final googleUrl =
        'https://www.google.com/maps/dir/?api=1&'
        'origin=$startLat,$startLon&'
        'destination=$endLat,$endLon&travelmode=driving';

    final uri = Uri.parse(googleUrl);
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
