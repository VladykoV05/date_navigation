import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'search_region.dart';

class SearchRegionPreferences {
  static const _key = 'search_region_v2';

  const SearchRegionPreferences();

  Future<SearchRegion> read() async {
    final prefs = await SharedPreferences.getInstance();
    return SearchRegion.fromStorage(prefs.getString(_key));
  }

  Future<void> write(SearchRegion region) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(region.toJson()));
  }
}

final searchRegionPreferencesProvider = Provider<SearchRegionPreferences>(
  (ref) => const SearchRegionPreferences(),
);

class SearchRegionController extends AsyncNotifier<SearchRegion> {
  @override
  Future<SearchRegion> build() {
    return ref.read(searchRegionPreferencesProvider).read();
  }

  Future<void> setRegion(SearchRegion region) async {
    await ref.read(searchRegionPreferencesProvider).write(region);
    state = AsyncData(region);
  }
}

final searchRegionControllerProvider =
    AsyncNotifierProvider<SearchRegionController, SearchRegion>(
      SearchRegionController.new,
    );
