import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../location/geolocator_location_service.dart';
import '../notifications/flutter_local_notification_service.dart';
import '../notifications/local_notification_service.dart';
import '../location/location_service.dart';
import '../onboarding/onboarding_preferences.dart';
import '../services/navigation_service.dart';

final navigationServiceProvider = Provider<NavigationService>(
  (ref) => NavigationService(),
);

final locationServiceProvider = Provider<LocationService>(
  (ref) => const GeolocatorLocationService(),
);

final onboardingPreferencesProvider = Provider<OnboardingPreferences>(
  (ref) => OnboardingPreferences(),
);

final localNotificationServiceProvider = Provider<LocalNotificationService>(
  (ref) => FlutterLocalNotificationService(),
);
