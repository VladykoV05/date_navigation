// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Date Navigator';

  @override
  String get signInTitle => 'Приложение для встречи';

  @override
  String get signInSubtitle =>
      'Войдите через Google, чтобы сохранять избранные места и быстро продолжать встречу.';

  @override
  String get signInButton => 'Войти через Google';

  @override
  String get signInLoading => 'Входим...';

  @override
  String get welcomeTitle => 'Встречаемся?';

  @override
  String get welcomeSubtitle =>
      'Создай комнату, отправь код другу и укажите свои адреса.\nМы подберем удобные места примерно посередине.';

  @override
  String get welcomeCreateMeeting => 'Создать встречу';

  @override
  String get welcomeJoinByCode => 'Войти по коду';

  @override
  String get waitSecondParticipant =>
      'Ожидаем второго участника...\nПопросите партнера ввести код комнаты и отправить адрес.';

  @override
  String get pickSameFormatFirst =>
      'Согласуйте одинаковый формат встречи — после этого появится подбор мест.';

  @override
  String get formatNotMatchedPlaceDisabled =>
      'Пока формат не совпал, этап выбора места недоступен.';

  @override
  String get noResultsInCategory =>
      'В этой подкатегории пока нет результатов.\nВыберите другой чип или сбросьте фильтр.';

  @override
  String get noResultsInRadius =>
      'В текущем радиусе пока нет результатов.\nУвеличьте радиус поиска или нажмите \"Повторить\".';

  @override
  String get sessionCompletedHint =>
      'Сессия завершена. Можно создать новую комнату.';

  @override
  String get sessionExpiredHint =>
      'Сессия истекла. Создайте новую комнату для продолжения.';

  @override
  String get unstableNetworkShowingCached =>
      'Сеть нестабильна. Показываем последние доступные результаты.';

  @override
  String get sessionCompletedBanner =>
      'Сессия завершена. Можно выйти и создать новую комнату.';

  @override
  String get sessionExpiredBanner =>
      'Сессия истекла. Создайте новую комнату для продолжения.';

  @override
  String get leaveRoomTitle => 'Покинуть комнату?';

  @override
  String get leaveRoomMessage =>
      'Вы выйдете из комнаты на этом устройстве и вернетесь на стартовый экран.';

  @override
  String get leaveRoomConfirm => 'Да, выйти';

  @override
  String get leaveRoomButton => 'Покинуть комнату';

  @override
  String get sessionClosedActionsDisabled =>
      'Сессия завершена. Действия отключены.';

  @override
  String get sessionExpiredActionsDisabled =>
      'Сессия истекла. Действия отключены.';

  @override
  String get loadingGeocoding => 'Проверяем адрес...';

  @override
  String get loadingMeeting => 'Ищем точку встречи и места...';

  @override
  String get loadingNearbyPlaces =>
      'Подбираем места рядом с точкой встречи... Обычно это занимает до 10-15 секунд.';

  @override
  String get loadingRoomSync => 'Обновляем комнату...';

  @override
  String get loadingGeneric => 'Загрузка...';

  @override
  String get otherAddressesLabel => 'Остальные адреса';

  @override
  String get clearOtherAddressesTitle => 'Очистить остальные адреса?';

  @override
  String get clearOtherAddressesMessage =>
      'Все адреса из этого списка будут удалены.';

  @override
  String get clearAllAddressesLabel => 'Очистить все';

  @override
  String get clearLabel => 'Очистить';

  @override
  String get cancelLabel => 'Отмена';

  @override
  String get deleteAddressTooltip => 'Удалить адрес';

  @override
  String get confirmMyFormatChoiceLabel => 'Подтвердить мой выбор';

  @override
  String get yesLabel => 'Да';

  @override
  String get noLabel => 'Нет';

  @override
  String get okLabel => 'Ок';

  @override
  String get openLabel => 'Открыть';

  @override
  String get rejectLabel => 'Отклонить';

  @override
  String get acceptLabel => 'Согласиться';

  @override
  String get focusPointMissing => 'Сначала укажи адрес';

  @override
  String get notEnoughPoints => 'Недостаточно точек на карте';

  @override
  String get partnerRadiusSuggestTitle => 'Партнер предлагает радиус';

  @override
  String partnerRadiusSuggestPrompt(int radius) {
    return 'Изменить радиус поиска на $radius м?';
  }

  @override
  String get partnerRadiusAcceptLabel => 'Да, принять';

  @override
  String partnerRadiusReminder(int radius) {
    return 'Партнер все еще предлагает $radius м';
  }

  @override
  String creatorChangedRadius(int radius) {
    return 'Креатор изменил радиус на $radius м';
  }

  @override
  String get partnerPlaceSuggestTitle => 'Партнер предложил место';

  @override
  String proposalPlaceLabel(String place) {
    return 'Место: $place';
  }

  @override
  String proposalTypeLabel(String type) {
    return 'Тип: $type';
  }

  @override
  String proposalAddressLabel(String address) {
    return 'Адрес: $address';
  }

  @override
  String get proposalAcceptQuestion => 'Принять?';

  @override
  String get meetingRevoteRequestTitle => 'Запрос на пересогласование';

  @override
  String get meetingRevoteRequestPrompt =>
      'Партнер хочет изменить формат встречи. Разрешить пересогласование?';

  @override
  String get formatStatusSelectBoth =>
      'Выберите форматы. Когда появится пересечение, подтвердите один.';

  @override
  String get formatStatusNoCommon =>
      'Пока нет пересечения. Добавьте совпадающий формат.';

  @override
  String get formatStatusReadyToConfirm =>
      'Есть общие форматы. Подтвердите один.';

  @override
  String get formatStatusRevoteRequestedByMe =>
      'Запрос на пересогласование отправлен. Ждем ответ партнера.';

  @override
  String get formatStatusRevoteRequestedByPartner =>
      'Партнер запрашивает пересогласование формата.';

  @override
  String formatStatusAgreed(String format) {
    return 'Формат согласован: $format';
  }

  @override
  String formatStatusConfirmedByMe(String format) {
    return 'Ты подтвердил: $format. Ждем подтверждение партнера.';
  }

  @override
  String formatStatusRevotingNow(String format) {
    return 'Идет пересогласование. Сейчас: $format.';
  }

  @override
  String get formatConfirmationMissing => 'не подтвержден';

  @override
  String formatConfirmationLine(String my, String partner) {
    return 'Ты: $my • Партнер: $partner';
  }

  @override
  String get formatDraftResetPrompt =>
      'Твой выбранный формат больше не общий. Сбросить выбор и выбрать заново?';

  @override
  String roomCodeLabel(String code) {
    return 'КОД: $code';
  }

  @override
  String get venueAgreedTitle => 'Место согласовано';

  @override
  String get dateAssistantTitle => 'Date Assistant';

  @override
  String get commonFormatsTitle => 'Общие форматы (выберите один)';

  @override
  String get formatChangedTitle => 'Выбор формата изменился';

  @override
  String get onboardingSkip => 'Пропустить';

  @override
  String get onboardingNext => 'Далее';

  @override
  String get onboardingStart => 'Начать';

  @override
  String get onboardingSlide1Title => 'Создайте комнату';

  @override
  String get onboardingSlide1Body =>
      'Сгенерируйте код и отправьте его партнеру — так вы окажетесь в одной сессии.';

  @override
  String get onboardingSlide2Title => 'Согласуйте формат';

  @override
  String get onboardingSlide2Body =>
      'Выберите общий формат встречи: кафе, прогулка, активность или культура.';

  @override
  String get onboardingSlide3Title => 'Найдите место';

  @override
  String get onboardingSlide3Body =>
      'Укажите адреса, приложение подберет точку встречи и места рядом.';

  @override
  String addressDeleteUndoMessage(int seconds) {
    return 'Адрес будет удален через $seconds секунд';
  }

  @override
  String addressesDeleteUndoMessage(int seconds) {
    return 'Адреса будут удалены через $seconds секунд';
  }

  @override
  String get undoLabel => 'Отменить';

  @override
  String signInError(String message) {
    return 'Ошибка входа: $message';
  }

  @override
  String signInGenericError(String error) {
    return 'Google вход не выполнен: $error';
  }

  @override
  String get languageRussian => 'Русский';

  @override
  String get languageEnglish => 'English';

  @override
  String get accountMenuTooltip => 'Аккаунт';

  @override
  String get accountMenuCabinet => 'Кабинет';

  @override
  String get accountMenuLogout => 'Выйти';

  @override
  String get accountMenuLanguage => 'Язык';

  @override
  String get accountFallbackTitle => 'Аккаунт';

  @override
  String get accountTitle => 'Кабинет';

  @override
  String get accountTabFavorites => 'Избранное';

  @override
  String get accountTabHistory => 'История';

  @override
  String get accountUserFallback => 'Пользователь';

  @override
  String get accountFavoritesEmpty => 'Избранное пока пустое';

  @override
  String get accountHistoryEmpty => 'История встреч пока пустая';

  @override
  String get addressNotSpecified => 'Адрес не указан';

  @override
  String get removeFromFavoritesTooltip => 'Удалить из избранного';

  @override
  String get timeUnknown => 'Время неизвестно';

  @override
  String get coordinatesNotSaved => 'Координаты не сохранены';

  @override
  String get openOnMap => 'Открыть на карте';

  @override
  String get typeNotSpecified => 'Тип не указан';

  @override
  String get addressNotSaved => 'Адрес не сохранен';

  @override
  String get addedToFavorites => 'Добавлено в избранное';

  @override
  String get alreadyInFavorites => 'Уже в избранном';

  @override
  String get addToFavorites => 'В избранное';

  @override
  String get removeFromFavorites => 'Убрать из избранного';

  @override
  String get removedFromFavorites => 'Удалено из избранного';

  @override
  String get userNotAuthenticated => 'Пользователь не авторизован';

  @override
  String get favoritesLoadFailed => 'Не удалось загрузить избранное';

  @override
  String get historyLoadFailed => 'Не удалось загрузить историю';

  @override
  String get joinRoomTitle => 'Введите код';

  @override
  String get joinRoomCodeLabel => 'Код комнаты';

  @override
  String get joinRoomCodeHint => '4 цифры, например 1234';

  @override
  String get joinRoomCodeHelper => 'Введите код, который отправил партнер';

  @override
  String get joinRoomSubmit => 'Войти';

  @override
  String get mapActionsLabel => 'Действия карты';

  @override
  String get mapShowAllTooltip => 'Показать всех';

  @override
  String get mapResetBearingTooltip => 'Сбросить поворот';

  @override
  String get mapCenterOnMeTooltip => 'Ко мне';

  @override
  String get mapMarkerMe => 'Я';

  @override
  String get mapMarkerPartner => 'Партнер';

  @override
  String get mapMarkerCenter => 'Центр';

  @override
  String get mapMarkerPlaces => 'Места';

  @override
  String get searchRadiusLabel => 'Радиус поиска';

  @override
  String metersShort(int meters) {
    return '$meters м';
  }

  @override
  String kilometersShort(String km) {
    return '$km км';
  }

  @override
  String get meetingPlacesTitle => 'Места для встречи';

  @override
  String get retryLabel => 'Повторить';

  @override
  String get dismissLabel => 'Скрыть';

  @override
  String get createNewRoom => 'Создать новую комнату';

  @override
  String get addressFieldLabel => 'Адрес';

  @override
  String get addressFieldHint => 'Например: Минск, пр. Независимости 10';

  @override
  String get addressFieldHelper =>
      'Введите точный адрес, чтобы найти общую точку встречи. Можно и латиницей (например Nezavisimosti), но надёжнее — как на картах OSM.';

  @override
  String get frequentAddressesTitle => 'Частые адреса';

  @override
  String get meetingFormatFood => 'Кофе или ужин';

  @override
  String get meetingFormatCulture => 'Культура и впечатления';

  @override
  String get meetingFormatWalk => 'Просто прогулка';

  @override
  String get meetingFormatActive => 'Активный формат';

  @override
  String get placeTypeBar => 'Бар';

  @override
  String get placeTypeRestaurant => 'Ресторан';

  @override
  String get placeTypeFastFood => 'Фастфуд';

  @override
  String get placeTypeCafe => 'Кафе';

  @override
  String get placeTypeCinema => 'Кино';

  @override
  String get placeTypeCulture => 'Культура';

  @override
  String get placeTypeTheatre => 'Театр';

  @override
  String get placeTypePark => 'Парк';

  @override
  String get placeTypeViewpoint => 'Видовое место';

  @override
  String get placeTypeSport => 'Спорт';

  @override
  String get placeTypePool => 'Бассейн';

  @override
  String get placeTypeIceRink => 'Каток';

  @override
  String get placeTypeActive => 'Активность';

  @override
  String get placeTypeFallback => 'Место';

  @override
  String get chipAll => 'Все';

  @override
  String get chipCafe => 'Кафе';

  @override
  String get chipRestaurants => 'Рестораны';

  @override
  String get chipCinema => 'Кино';

  @override
  String get chipMuseums => 'Музеи';

  @override
  String get chipGalleries => 'Галереи';

  @override
  String get chipTheatres => 'Театры';

  @override
  String get chipParks => 'Парки';

  @override
  String get chipViewpoints => 'Видовые';

  @override
  String get chipFitness => 'Фитнес';

  @override
  String get chipSportsCentre => 'Спортцентр';

  @override
  String get chipPool => 'Бассейн';

  @override
  String get chipIceRink => 'Каток';

  @override
  String get chipRackets => 'Ракетки';

  @override
  String get chipTeamSports => 'Командные';

  @override
  String get chipClimbing => 'Скалолаз.';

  @override
  String get chipDance => 'Танцы';

  @override
  String get chipYoga => 'Йога';

  @override
  String get proposePlace => 'Предложить';

  @override
  String get placeProposedToPartner => 'Место предложено партнеру';

  @override
  String get distanceForYou => 'Тебе';

  @override
  String get distanceForPartner => 'Партнеру';

  @override
  String get routeLabel => 'Маршрут';

  @override
  String distanceLine(String who, String dist) {
    return 'Расстояние: $who, $dist';
  }

  @override
  String placeSemanticsLabel(String name) {
    return 'Место $name';
  }

  @override
  String get placeSemanticsHint => 'Открывает карточку места с деталями';

  @override
  String get removeVote => 'Убрать голос';

  @override
  String get castVote => 'Проголосовать';

  @override
  String get loadingBestPlaces => 'Ищем лучшие места...';

  @override
  String get scenarioPlanTitle => 'Итоговый план встречи';

  @override
  String scenarioRoomLabel(String roomId) {
    return 'Комната #$roomId';
  }

  @override
  String scenarioDuration(int minutes) {
    return 'Длительность: $minutes мин';
  }

  @override
  String scenarioAnchor(String name) {
    return 'Точка встречи: $name';
  }

  @override
  String get scenarioSteps => 'Шаги';

  @override
  String minutesShort(int minutes) {
    return '($minutes мин)';
  }

  @override
  String get sharePlan => 'Поделиться планом';

  @override
  String get openFinalPlan => 'Открыть итоговый план';

  @override
  String sharePlanHeader(String roomId) {
    return 'План встречи в комнате #$roomId';
  }

  @override
  String sharePlanDuration(int minutes) {
    return 'Длительность: $minutes мин';
  }

  @override
  String sharePlanPlace(String name) {
    return 'Место: $name';
  }

  @override
  String sharePlanAddress(String address) {
    return 'Адрес: $address';
  }

  @override
  String get sharePlanSteps => 'Шаги:';

  @override
  String get sharePlanFooter => 'Собрано в приложении для встречи';

  @override
  String get failureTimeout =>
      'Сервер долго отвечает. Попробуй ещё раз через пару секунд.';

  @override
  String get failureRateLimit =>
      'Слишком много запросов. Подожди немного и повтори.';

  @override
  String get failureNetwork =>
      'Проблема с сетью или доступом. Проверь интернет и попробуй снова.';

  @override
  String get failureParse =>
      'Получили неожиданный ответ сервера. Попробуй повторить.';

  @override
  String get failureGeneric => 'Что-то пошло не так. Попробуй ещё раз.';

  @override
  String get failureAddressNotFound => 'Адрес не найден';

  @override
  String get failureLocationServiceDisabled => 'Геолокация выключена';

  @override
  String get failureLocationPermissionDenied => 'Нет разрешения на геолокацию';

  @override
  String get failureLocationPermissionDeniedForever =>
      'Разрешение на геолокацию заблокировано в настройках';

  @override
  String get failureLocationUnavailable => 'Не удалось получить местоположение';

  @override
  String get failureLocationTimeout =>
      'Не удалось получить местоположение вовремя';

  @override
  String get useCurrentLocationLabel => 'Моя точка';

  @override
  String get useCurrentLocationLoading => 'Определяем...';

  @override
  String get failureRoomNotFound => 'Комната не найдена';

  @override
  String get failureRoomCodeExists => 'Комната с таким кодом уже существует';

  @override
  String get failureRoomFull => 'Комната уже занята';

  @override
  String get failureMeetingPointCalc => 'Не удалось рассчитать точку встречи';

  @override
  String get failureFormatMustBeCommon =>
      'Выберите формат только из общих вариантов';

  @override
  String get failureSessionAlreadyEnded => 'Сессия комнаты уже завершена';

  @override
  String get failureOnlyCreatorCanEnd =>
      'Завершить сессию может только создатель комнаты';

  @override
  String scenarioTitleFood(int variant, String placeName) {
    return 'План с кофе или ужином #$variant в $placeName';
  }

  @override
  String scenarioTitleCulture(int variant) {
    return 'Культурный вечер #$variant';
  }

  @override
  String scenarioTitleWalk(int variant) {
    return 'Прогулочный план #$variant';
  }

  @override
  String scenarioTitleActive(int variant) {
    return 'Активный план #$variant';
  }

  @override
  String get scenarioDescFood =>
      'Универсальный формат: можно зайти на кофе или поужинать в одном месте.';

  @override
  String get scenarioDescCulture =>
      'Формат для впечатлений: кино, выставка или атмосферное культурное место.';

  @override
  String get scenarioDescWalk =>
      'Спокойный формат без заведения: прогулка по парку или набережной.';

  @override
  String get scenarioDescActive =>
      'Динамичный формат: спортивная или активная встреча.';

  @override
  String get scenarioStepGatherVenue => 'Сбор в заведении';

  @override
  String get scenarioStepGatherVenueDesc =>
      'Встречаетесь и выбираете удобный стол.';

  @override
  String get scenarioStepFoodTalk => 'Еда и общение';

  @override
  String get scenarioStepFoodTalkDesc =>
      'Формат под настроение: кофе-брейк или полноценный ужин.';

  @override
  String get scenarioStepMeetCulture => 'Встреча у локации';

  @override
  String get scenarioStepMeetCultureDesc =>
      'Встречаетесь у выбранного культурного места.';

  @override
  String get scenarioStepMainCulture => 'Основная часть';

  @override
  String get scenarioStepMainCultureDesc =>
      'Проводите время вместе и обсуждаете впечатления.';

  @override
  String get scenarioStepMeetWalk => 'Встреча у стартовой точки';

  @override
  String get scenarioStepMeetWalkDesc =>
      'Собираетесь в удобной точке рядом с маршрутом.';

  @override
  String get scenarioStepWalk => 'Прогулка';

  @override
  String get scenarioStepWalkDesc => 'Гуляете по парку/набережной и общаетесь.';

  @override
  String get scenarioStepGatherActive => 'Сбор на локации';

  @override
  String get scenarioStepGatherActiveDesc =>
      'Встречаетесь и готовитесь к активности.';

  @override
  String get scenarioStepActive => 'Активная часть';

  @override
  String get scenarioStepActiveDesc =>
      'Совместная активность в комфортном темпе.';

  @override
  String get failureCreateRoomRetry =>
      'Не удалось создать комнату: попробуй еще раз';

  @override
  String get failureCreateRoomFailed => 'Не удалось создать комнату';

  @override
  String get failureJoinRoom => 'Не удалось присоединиться к комнате';

  @override
  String get failureRoomCodeEmpty => 'Код комнаты пустой';

  @override
  String get failureRoomCorrupt => 'Комната повреждена';

  @override
  String get failureCreatorUnresolved =>
      'Не удалось определить создателя комнаты';

  @override
  String get failureNotRoomMember =>
      'Пользователь не является участником комнаты';

  @override
  String get failureUpdateLocation => 'Не удалось обновить координаты';

  @override
  String get failureCompleteSession => 'Не удалось завершить сессию';

  @override
  String get failurePickFormatBeforePlace =>
      'Сначала выберите финальный формат, затем выбирайте место';

  @override
  String get failureFormatNotSelected => 'Не выбран финальный формат встречи';

  @override
  String get failureVotingClosed =>
      'Голосование закрыто после финального выбора';

  @override
  String get failureVote => 'Не удалось проголосовать';

  @override
  String get failureFinalPlaceAlreadyChosen => 'Финальное место уже выбрано';

  @override
  String get failureProposePlace => 'Не удалось предложить место';

  @override
  String get failureRespondProposal => 'Не удалось ответить на предложение';

  @override
  String get failureSyncResults => 'Не удалось синхронизировать результаты';

  @override
  String get failureSaveScenario => 'Не удалось сохранить сценарий встречи';

  @override
  String get failureSaveFormat => 'Не удалось сохранить формат встречи';

  @override
  String get failureRevoteAlreadyRequested =>
      'Запрос на пересогласование уже отправлен';

  @override
  String get failureRequestRevote => 'Не удалось запросить пересогласование';

  @override
  String get failureCannotConfirmOwnRevote =>
      'Нельзя подтвердить собственный запрос';

  @override
  String get failureProcessRevote =>
      'Не удалось обработать запрос пересогласования';

  @override
  String get failureConfirmFormat => 'Не удалось подтвердить формат встречи';

  @override
  String get failureSaveRadius => 'Не удалось сохранить радиус поиска';

  @override
  String get failureSaveFavorite => 'Не удалось сохранить в избранное';

  @override
  String get failureDeleteFavorite => 'Не удалось удалить из избранного';

  @override
  String get failureSaveAddress => 'Не удалось сохранить адрес';

  @override
  String get failureDeleteAddress => 'Не удалось удалить адрес';

  @override
  String get failureSaveMeetingHistory =>
      'Не удалось сохранить историю встречи';

  @override
  String get failureServiceUnavailable => 'Сервис временно недоступен';

  @override
  String get failurePermissionDenied => 'Нет прав для операции';

  @override
  String get failureGeocodingTimeout => 'Таймаут геокодинга';

  @override
  String get failureGeocodingRateLimit => 'Слишком много запросов (геокодинг)';

  @override
  String get failureGeocodingHttp => 'Ошибка геокодинга';

  @override
  String get failureGeocodingUnknown => 'Не удалось выполнить геокодинг';

  @override
  String get failureRoomStream => 'Связь с комнатой потеряна. Проверьте сеть.';

  @override
  String get failureRoutingTimeout => 'Таймаут расчёта маршрута';

  @override
  String get failureRoutingFailed =>
      'Не удалось построить маршрут между адресами';

  @override
  String get presenceWaitingPartnerJoin =>
      'Ждём, пока партнёр присоединится.\nОтправьте ссылку-приглашение или код комнаты.';

  @override
  String get presenceWaitingPartnerAddress =>
      'Партнёр в комнате. Ждём его адрес.';

  @override
  String get presenceWaitingYourAddress =>
      'Введите свой адрес, чтобы продолжить.';

  @override
  String get presenceWaitingYourFormats =>
      'Выберите форматы встречи, которые вам подходят.';

  @override
  String get presenceWaitingPartnerFormats =>
      'Ждём, пока партнёр выберет форматы встречи.';

  @override
  String get presenceWaitingYourFormatConfirm =>
      'Подтвердите общий формат встречи.';

  @override
  String get presenceWaitingPartnerFormatConfirm =>
      'Ждём подтверждения формата от партнёра.';

  @override
  String get routingDegradedBanner =>
      'Сервис маршрутов недоступен. Показана упрощённая середина — нажмите «Повторить» для полного маршрута.';

  @override
  String get failureActionEditAddress =>
      'Исправьте адрес и попробуйте снова или нажмите «Повторить».';

  @override
  String get failureActionResubscribeRoom =>
      'Нажмите «Повторить», чтобы переподключиться к комнате.';

  @override
  String get failureActionRetryMeeting =>
      'Нажмите «Повторить», чтобы пересчитать точку встречи.';

  @override
  String get shareInviteLabel => 'Поделиться приглашением';

  @override
  String shareInviteMessage(String code, String link) {
    return 'Присоединяйся к комнате Date Navigation по коду $code:\n$link';
  }

  @override
  String get inviteInvalidTitle => 'Приглашение недоступно';

  @override
  String get inviteInvalidMessage =>
      'Код приглашения недействителен или истёк. Запросите новый код.';

  @override
  String get searchRegionLabel => 'Регион поиска';

  @override
  String get searchRegionGlobal => 'Весь мир';

  @override
  String get searchRegionMinsk => 'Минск';

  @override
  String get noResultsInRadiusHint =>
      'Увеличьте радиус, сбросьте фильтр категории или смените формат встречи.';

  @override
  String get showAllCategoriesLabel => 'Показать все категории';

  @override
  String get increaseRadiusHint => 'Увеличить радиус и повторить';

  @override
  String get privacyTitle => 'Конфиденциальность';

  @override
  String get privacyBody =>
      'Date Navigation хранит профиль, участие в комнатах, избранное и историю встреч в Firebase для синхронизации совместного планирования.\n\nАдреса и координаты записываются только в комнаты, в которые вы входите. Удалить аккаунт и связанные личные данные можно в профиле.\n\nГеолокация используется только при отправке адреса на геокодинг. Аналитика и отчёты о сбоях собираются в release-сборках.';

  @override
  String get deleteAccountTitle => 'Удалить аккаунт?';

  @override
  String get deleteAccountMessage =>
      'Это навсегда удалит аккаунт Firebase, избранное, историю и память адресов. Комнаты, которые вы создали, не удаляются принудительно для партнёра.';

  @override
  String get deleteAccountConfirm => 'Удалить аккаунт';

  @override
  String get deleteAccountButton => 'Удалить аккаунт';

  @override
  String get deleteAccountFailed =>
      'Не удалось удалить аккаунт. Войдите снова и повторите.';

  @override
  String get storeReadyChecklistNote =>
      'Разрешения: только Интернет. Без постоянного GPS. Данные: аккаунт и sync комнат через Firebase.';

  @override
  String get openSessionsTitle => 'Открытые сессии';

  @override
  String get openSessionsCreate => 'Создать сессию';

  @override
  String get openSessionsRefresh => 'Обновить';

  @override
  String get openSessionsEmpty =>
      'Открытых сессий пока нет. Создай свою и позови людей.';

  @override
  String get openSessionsLoadFailed => 'Не удалось загрузить открытые сессии';

  @override
  String get openSessionsCapacity => 'Максимум людей';

  @override
  String get openSessionNoEvent => 'Открытая сессия';

  @override
  String openSessionMembers(int count, int capacity) {
    return '$count из $capacity';
  }

  @override
  String get openSessionJoin => 'Войти';

  @override
  String get openSessionFull => 'Заполнено';

  @override
  String get openSessionsEvent => 'Событие';

  @override
  String get openSessionsEventNone => 'Без события';

  @override
  String get openSessionsEventsUnavailable =>
      'Каталог событий недоступен. Можно создать сессию без события.';

  @override
  String get openEventRoute => 'Маршрут к событию';

  @override
  String get chatTitle => 'Чат';

  @override
  String get chatInputHint => 'Сообщение';

  @override
  String get chatSend => 'Отправить';

  @override
  String get chatEmpty => 'Сообщений пока нет';

  @override
  String get chatLoadFailed => 'Не удалось загрузить сообщения';

  @override
  String get chatSendFailed => 'Не удалось отправить сообщение';

  @override
  String get chatOpen => 'Чат';

  @override
  String get chatLoadOlder => 'Загрузить старые';

  @override
  String get systemParticipantJoined => 'Участник присоединился';

  @override
  String get systemFormatConfirmed => 'Формат встречи подтверждён';

  @override
  String get systemPlaceSelected => 'Место выбрано';

  @override
  String get openSessionTabParticipants => 'Участники';

  @override
  String get openSessionTabPlan => 'План';

  @override
  String get openSessionTabChat => 'Чат';

  @override
  String get openSessionEnterAddress => 'Ввести адрес';

  @override
  String get openSessionAddressSheetTitle => 'Ваш адрес';

  @override
  String get openSessionAddressSheetHint =>
      'Адрес нужен, чтобы участники увидели вашу точку';

  @override
  String get openSessionParticipantSelf => 'Вы';

  @override
  String get openSessionParticipantHost => 'Хост';

  @override
  String openSessionParticipantNumber(Object number) {
    return 'Участник $number';
  }

  @override
  String get openSessionAddressSet => 'адрес указан';

  @override
  String get openSessionAddressNotSet => 'адрес не указан';

  @override
  String get openSessionLeave => 'Выйти';

  @override
  String get openSessionPlanFromEvent => 'Событие';

  @override
  String get openSessionEmptyParticipants => 'Пока никого нет';

  @override
  String get openSessionParticipantMember => 'Участник';

  @override
  String get failureLeaveRoom =>
      'Не удалось выйти из сессии. Попробуйте ещё раз.';

  @override
  String get systemParticipantLeft => 'Участник вышел';

  @override
  String get openSessionComplete => 'Завершить сессию';

  @override
  String get openSessionCompleteTitle => 'Завершить сессию?';

  @override
  String get openSessionCompleteBody =>
      'Чат станет только для чтения, вход в сессию закроется.';

  @override
  String get openSessionCompleteAction => 'Завершить';

  @override
  String get openSessionCancel => 'Отмена';

  @override
  String get chatReadOnlyHint => 'Сессия завершена: только чтение';

  @override
  String get openSessionClosedHint =>
      'Сессия завершена. Чат только для чтения, вход закрыт.';

  @override
  String get failureHostAlone =>
      'Вы единственный участник. Завершите сессию, чтобы выйти.';

  @override
  String get openSessionHostAlone =>
      'Чтобы выйти, завершите сессию: вы единственный участник';

  @override
  String get systemHostTransferred => 'Хост передан участнику';

  @override
  String get openSessionExpiredHint =>
      'Сессия истекла. Чат только для чтения, вход закрыт.';

  @override
  String get profileEditName => 'Изменить имя';

  @override
  String get profileNameLabel => 'Имя';

  @override
  String get profileNameHint => 'Как вас видят другие';

  @override
  String get profilePhotoGallery => 'Фото из галереи';

  @override
  String get profilePhotoPreset => 'Встроенный аватар';

  @override
  String get profilePhotoGoogle => 'Фото из Google';

  @override
  String get profileAvatarTooLarge =>
      'Не удалось подготовить фото. Выберите другое.';

  @override
  String get profileSaveError => 'Не удалось сохранить профиль';

  @override
  String get profileCancel => 'Отмена';

  @override
  String get profileSave => 'Сохранить';

  @override
  String get profileChooseAvatar => 'Выберите аватар';

  @override
  String get planNextStepTitle => 'Следующее место';

  @override
  String get planNotChosen => 'Место пока не выбрано';

  @override
  String get planSuggestButton => 'Предложить место';

  @override
  String get planSuggestionsTitle => 'Предложения';

  @override
  String get planChooseButton => 'Выбрать';

  @override
  String get planChosenLabel => 'Выбрано';

  @override
  String get planEmptySuggestions => 'Предложений пока нет';

  @override
  String get planRadiusLabel => 'Радиус от события';

  @override
  String planRadiusOption(Object meters) {
    return '$meters м';
  }

  @override
  String get planSuggestNameLabel => 'Название места';

  @override
  String get planSuggestAddressLabel => 'Адрес';

  @override
  String get planSuggestSubmit => 'Предложить';

  @override
  String get planAddressNotFound => 'Адрес не найден';

  @override
  String planTooFar(Object meters) {
    return 'Место дальше $meters м от площадки события';
  }

  @override
  String get planSuggestLimit => 'Можно предложить не больше 5 мест в час';

  @override
  String get planSaveFailed => 'Не удалось сохранить план. Попробуйте ещё раз.';

  @override
  String planProposedBy(Object name) {
    return 'от $name';
  }
}
