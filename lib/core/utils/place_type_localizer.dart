String localizePlaceType(String? rawType) {
  final normalizedType = rawType?.trim().toLowerCase().replaceAll(' ', '_');
  if (normalizedType == null || normalizedType.isEmpty) return 'Место';
  return switch (normalizedType) {
    'bar' || 'pub' || 'biergarten' => 'Бар',
    'restaurant' || 'diner' => 'Ресторан',
    'fast_food' || 'food_court' => 'Фастфуд',
    'cafe' || 'coffee_shop' => 'Кафе',
    'cinema' => 'Кино',
    'museum' || 'gallery' => 'Культура',
    'theatre' => 'Театр',
    'park' => 'Парк',
    'viewpoint' => 'Видовое место',
    'fitness_centre' || 'sports_centre' => 'Спорт',
    'swimming_pool' => 'Бассейн',
    'ice_rink' => 'Каток',
    'active_racket' ||
    'active_team' ||
    'active_climb' ||
    'active_dance' ||
    'active_mind_body' => 'Активность',
    _ => 'Место',
  };
}
