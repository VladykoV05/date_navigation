class UiCopy {
  const UiCopy._();

  static const waitSecondParticipant =
      'Ожидаем второго участника...\n'
      'Попросите партнера ввести код комнаты и отправить адрес.';

  static const pickSameFormatFirst =
      'Согласуйте одинаковый формат встречи — после этого появится подбор мест.';

  static const formatNotMatchedPlaceDisabled =
      'Пока формат не совпал, этап выбора места недоступен.';

  static const noResultsInCategory =
      'В этой подкатегории пока нет результатов.\n'
      'Выберите другой чип или сбросьте фильтр.';

  static const noResultsInRadius =
      'В текущем радиусе пока нет результатов.\n'
      'Увеличьте радиус поиска или нажмите "Повторить".';

  static const sessionCompletedHint =
      'Сессия завершена. Можно создать новую комнату.';

  static const sessionExpiredHint =
      'Сессия истекла. Создайте новую комнату для продолжения.';

  static const proposalWaitingPartnerApproval =
      'Ожидаем подтверждение второго участника...';

  static const unstableNetworkShowingCached =
      'Сеть нестабильна. Показываем последние доступные результаты.';

  static const sessionCompletedBanner =
      'Сессия завершена. Можно выйти и создать новую комнату.';

  static const sessionExpiredBanner =
      'Сессия истекла. Создайте новую комнату для продолжения.';

  static const leaveRoomTitle = 'Покинуть комнату?';
  static const leaveRoomMessage =
      'Вы выйдете из комнаты на этом устройстве и вернетесь на стартовый экран.';
  static const leaveRoomConfirm = 'Да, выйти';
  static const sessionClosedActionsDisabled =
      'Сессия завершена. Действия отключены.';
  static const sessionExpiredActionsDisabled =
      'Сессия истекла. Действия отключены.';

  static const loadingGeocoding = 'Проверяем адрес...';
  static const loadingMeeting = 'Ищем точку встречи и места...';
  static const loadingNearbyPlaces =
      'Подбираем места рядом с точкой встречи... Обычно это занимает до 10-15 секунд.';
  static const loadingRoomSync = 'Обновляем комнату...';
  static const loadingGeneric = 'Загрузка...';

  static const otherAddressesLabel = 'Остальные адреса';
  static const clearOtherAddressesTitle = 'Очистить остальные адреса?';
  static const clearOtherAddressesMessage =
      'Все адреса из этого списка будут удалены.';
  static const clearAllAddressesLabel = 'Очистить все';
  static const clearLabel = 'Очистить';
  static const cancelLabel = 'Отмена';
  static const deleteAddressTooltip = 'Удалить адрес';
  static const confirmMyFormatChoiceLabel = 'Подтвердить мой выбор';
  static const yesLabel = 'Да';
  static const noLabel = 'Нет';
  static const okLabel = 'Ок';
  static const openLabel = 'Открыть';
  static const rejectLabel = 'Отклонить';
  static const acceptLabel = 'Согласиться';

  static const focusPointMissing = 'Сначала укажи адрес';
  static const notEnoughPoints = 'Недостаточно точек на карте';

  static const partnerRadiusSuggestTitle = 'Партнер предлагает радиус';
  static const partnerRadiusSuggestPrompt =
      'Изменить радиус поиска на {radius} м?';
  static const partnerRadiusAcceptLabel = 'Да, принять';
  static const partnerRadiusReminder = 'Партнер все еще предлагает {radius} м';
  static const creatorChangedRadius = 'Креатор изменил радиус на {radius} м';

  static const partnerPlaceSuggestTitle = 'Партнер предложил место';
  static const partnerPlaceSuggestPrompt = 'Место: {place}\n\nПринять?';
  static const proposalPlaceLabel = 'Место: {place}';
  static const proposalTypeLabel = 'Тип: {type}';
  static const proposalAddressLabel = 'Адрес: {address}';
  static const proposalAcceptQuestion = 'Принять?';

  static const meetingRevoteRequestTitle = 'Запрос на пересогласование';
  static const meetingRevoteRequestPrompt =
      'Партнер хочет изменить формат встречи. Разрешить пересогласование?';

  static const formatStatusSelectBoth =
      'Выберите форматы. Когда появится пересечение, подтвердите один.';
  static const formatStatusNoCommon =
      'Пока нет пересечения. Добавьте совпадающий формат.';
  static const formatStatusReadyToConfirm =
      'Есть общие форматы. Подтвердите один.';
  static const formatStatusRevoteRequestedByMe =
      'Запрос на пересогласование отправлен. Ждем ответ партнера.';
  static const formatStatusRevoteRequestedByPartner =
      'Партнер запрашивает пересогласование формата.';
  static const formatStatusAgreed = 'Формат согласован: {format}';
  static const formatStatusConfirmedByMe =
      'Ты подтвердил: {format}. Ждем подтверждение партнера.';
  static const formatStatusRevotingNow =
      'Идет пересогласование. Сейчас: {format}.';
  static const formatConfirmationMissing = 'не подтвержден';
  static const formatConfirmationLine = 'Ты: {my} • Партнер: {partner}';
  static const formatDraftResetPrompt =
      'Твой выбранный формат больше не общий. Сбросить выбор и выбрать заново?';
}
