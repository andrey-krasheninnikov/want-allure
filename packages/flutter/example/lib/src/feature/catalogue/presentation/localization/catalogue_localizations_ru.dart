// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class CatalogueLocalizationsRu extends CatalogueLocalizations {
  CatalogueLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get findInCatalogue => 'Найти в каталоге';

  @override
  String get previousMatch => 'Предыдущее совпадение';

  @override
  String get nextMatch => 'Следующее совпадение';

  @override
  String get closeFind => 'Закрыть поиск';

  @override
  String get noMatches => 'Нет совпадений';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return 'Совпадение $active из $count';
  }

  @override
  String get dismissMessage => 'Закрыть сообщение';

  @override
  String get pauseBackground => 'Приостановить фон';

  @override
  String get resumeBackground => 'Продолжить фон';

  @override
  String get oneWantEveryPlatform => 'Один Want. На любой платформе.';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      'Единые цвета, компоненты и анимации Want для web и Flutter. Изучите элементы с клавиатурой, касаниями и мышью.';

  @override
  String get findCtrlF => 'Поиск · ⌘/Ctrl F';

  @override
  String get useLightTheme => 'Светлая тема';

  @override
  String get useDarkTheme => 'Тёмная тема';

  @override
  String get reduceMotion => 'Уменьшить движение';

  @override
  String get opaqueSurfaces => 'Непрозрачные поверхности';

  @override
  String get resumeEffects => 'Продолжить эффекты';

  @override
  String get pauseEffects => 'Приостановить эффекты';

  @override
  String get palette => 'Палитра';

  @override
  String get typography => 'Типографика';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want оставляет место вашему контенту.';
  }

  @override
  String get buttons => 'Кнопки';

  @override
  String variantNamePressed(Object variantName) {
    return 'Нажато: $variantName';
  }

  @override
  String get disabled => 'Недоступно';

  @override
  String get downloadSelected => 'Выбрано скачивание';

  @override
  String get downloadExample => 'Пример скачивания';

  @override
  String get fieldsInputAndTextarea => 'Поля, ввод и текстовая область';

  @override
  String get password => 'Пароль';

  @override
  String get showPassword => 'Показать пароль';

  @override
  String get hidePassword => 'Скрыть пароль';

  @override
  String get localExample => 'Локальный пример';

  @override
  String get title => 'Название';

  @override
  String get editableLocalValue => 'Редактируемое локальное значение.';

  @override
  String get invalidExample => 'Пример ошибки ввода';

  @override
  String get enterATitle => 'Введите название.';

  @override
  String get disabledExample => 'Недоступный пример';

  @override
  String get contoursOfSilence => 'Контуры тишины';

  @override
  String get description => 'Описание';

  @override
  String get describeThePreview => 'Опишите превью';

  @override
  String get fieldAndLabel => 'Поле и подпись';

  @override
  String get consumerOwnedHelperText => 'Подсказку задаёт приложение.';

  @override
  String get selectRadioCheckboxAndSwitch =>
      'Список, радиокнопки, флажок и переключатель';

  @override
  String get format => 'Формат';

  @override
  String get desktop => 'Компьютер';

  @override
  String get mobile => 'Телефон';

  @override
  String get unavailable => 'Недоступно';

  @override
  String get wallpaperOrientation => 'Ориентация обоев';

  @override
  String get includePreview => 'Включить превью';

  @override
  String get aControlledCheckbox => 'Управляемый флажок.';

  @override
  String get mixedSelection => 'Частичный выбор';

  @override
  String get enableExampleSetting => 'Включить настройку примера';

  @override
  String get disabledCheckbox => 'Недоступный флажок';

  @override
  String get tabsAndAccordion => 'Вкладки и аккордеон';

  @override
  String get landscapePreview => 'Горизонтальное превью.';

  @override
  String get portraitPreview => 'Вертикальное превью.';

  @override
  String get howAreComponentsShared => 'Что объединяет компоненты?';

  @override
  String get bothAdaptersUseTheSameFoundationTokens =>
      'Оба адаптера используют общие токены foundation.';

  @override
  String get whoOwnsApplicationData => 'Кто управляет данными приложения?';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence =>
      'Данные и хранение находятся в приложении.';

  @override
  String get dialogSheetMenuTooltipAndPopover =>
      'Диалог, панель, меню и подсказки';

  @override
  String get previewSettings => 'Настройки превью';

  @override
  String get done => 'Готово';

  @override
  String get previewName => 'Название превью';

  @override
  String get openDialog => 'Открыть диалог';

  @override
  String panelSideName(Object sideName) {
    return 'Панель $sideName';
  }

  @override
  String get closePanel => 'Закрыть панель';

  @override
  String get theSheetEntersFromItsSelectedSide =>
      'Панель появляется с выбранной стороны.';

  @override
  String sideNameSheet(Object sideName) {
    return 'Панель $sideName';
  }

  @override
  String get actions => 'Действия';

  @override
  String get copyLink => 'Копировать ссылку';

  @override
  String get copyActionSelected => 'Выбрано копирование';

  @override
  String get aKeyboardAndPointerHint => 'Подсказка для клавиатуры и мыши';

  @override
  String get hintSelected => 'Выбрана подсказка';

  @override
  String get tooltip => 'Подсказка';

  @override
  String get settings => 'Настройки';

  @override
  String get note => 'Заметка';

  @override
  String get closeSettings => 'Закрыть настройки';

  @override
  String get navigationAndBreadcrumbs => 'Навигация и путь';

  @override
  String get exampleNavigation => 'Пример навигации';

  @override
  String get collections => 'Коллекции';

  @override
  String get collectionsSelected => 'Выбраны коллекции';

  @override
  String get search => 'Поиск';

  @override
  String get searchSelected => 'Выбран поиск';

  @override
  String get breadcrumbs => 'Путь навигации';

  @override
  String get home => 'Главная';

  @override
  String get homeSelected => 'Выбрана главная';

  @override
  String get uiKit => 'UI-кит';

  @override
  String get badgesAlertsAndProgress => 'Метки, сообщения и прогресс';

  @override
  String get primary => 'Основной';

  @override
  String get previewAvailable => 'Превью доступно';

  @override
  String get chooseAnExampleActionToContinue => 'Выберите действие в примере.';

  @override
  String get couldNotLoadPreview => 'Не удалось загрузить превью';

  @override
  String get tryAgain => 'Попробуйте снова.';

  @override
  String get exampleProgress => 'Прогресс примера';

  @override
  String get loadingPreview => 'Загружаем превью';

  @override
  String get toastAndSemanticSnackbars => 'Тосты и уведомления состояний';

  @override
  String get localPreviewReady => 'Локальное превью готово';

  @override
  String get showToast => 'Показать тост';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName: пример состояния';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction =>
      'Уведомление в цвете темы с полезным действием.';

  @override
  String get dismissStatus => 'Закрыть сообщение';

  @override
  String get viewDetails => 'Посмотреть подробности';

  @override
  String get detailsSelected => 'Выбраны подробности';

  @override
  String get searchableCombobox => 'Список с поиском';

  @override
  String get collection => 'Коллекция';

  @override
  String get searchCollections => 'Поиск коллекций';

  @override
  String get violetHorizon => 'Фиолетовый горизонт';

  @override
  String get wovenSpectrum => 'Переплетённый спектр';

  @override
  String get tableAndPagination => 'Таблица и страницы';

  @override
  String get localCollection => 'Локальная коллекция';

  @override
  String get noRecords => 'Нет записей';

  @override
  String get name => 'Название';

  @override
  String previewValue(Object value) {
    return 'Превью $value';
  }

  @override
  String get pages => 'Страницы';

  @override
  String get previousPage => 'Предыдущая страница';

  @override
  String get nextPage => 'Следующая страница';

  @override
  String get rowsPerPage => 'Строк на странице';

  @override
  String pagePage(Object page) {
    return 'Страница $page';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$from–$to из $total';
  }

  @override
  String get fileSelection => 'Выбор файлов';

  @override
  String get images => 'Изображения';

  @override
  String get chooseImages => 'Выбрать изображения';

  @override
  String get dropImagesHereOrChooseAFile =>
      'Перетащите изображения или выберите файл.';

  @override
  String get couldNotReadTheSelectedFile =>
      'Не удалось прочитать выбранный файл.';

  @override
  String removeName(Object name) {
    return 'Удалить $name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name: неподдерживаемое изображение.';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name: размер превышает $limit байт.';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return 'Выберите до $count файлов.';
  }

  @override
  String get dateURLAndPageLayout => 'Дата, URL и компоновка страницы';

  @override
  String get createAPreview => 'Создать превью';

  @override
  String get localComposition => 'Локальная композиция';

  @override
  String get previewActionSelected => 'Выбрано действие превью';

  @override
  String get preview => 'Превью';

  @override
  String get date => 'Дата';

  @override
  String get time => 'Время';

  @override
  String get useToday => 'Выбрать сегодня';

  @override
  String get sourceURL => 'Ссылка на источник';

  @override
  String get openSource => 'Открыть источник';

  @override
  String openUriHost(Object uriHost) {
    return 'Открыть $uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => 'Карточки, медиа и жидкое стекло';

  @override
  String get localDemonstrationArtwork => 'Локальное изображение для примера';

  @override
  String get violetGradient => 'Фиолетовый градиент';

  @override
  String get previewSelected => 'Выбрано превью';

  @override
  String get downloadPanel => 'Панель скачивания';

  @override
  String get aComposedCard => 'Составная карточка';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      'Публичные слоты оставляют контент в приложении.';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced =>
      'Жидкое стекло становится непрозрачным при уменьшении прозрачности.';

  @override
  String get contactCard => 'Карточка контакта';

  @override
  String get productDesign => 'Дизайн продукта';

  @override
  String get website => 'Сайт';

  @override
  String get websiteSelected => 'Выбран сайт';

  @override
  String get commentCarousel => 'Карусель комментариев';

  @override
  String get comments => 'Комментарии';

  @override
  String get noComments => 'Нет комментариев';

  @override
  String get previousComments => 'Предыдущие комментарии';

  @override
  String get nextComments => 'Следующие комментарии';

  @override
  String get readMore => 'Читать дальше';

  @override
  String get collapse => 'Свернуть';

  @override
  String reviewerIndex(Object index) {
    return 'Участник $index';
  }

  @override
  String get today => 'Сегодня';

  @override
  String get readableCopyFollowsTheSameWantTypography =>
      'Читаемый текст следует единой типографике Want.';

  @override
  String get thePreviewIsReadyToExplore => 'Превью готово к просмотру.';

  @override
  String get reply => 'Ответить';

  @override
  String actionSelected(Object action) {
    return 'Выбрано действие: $action';
  }

  @override
  String get customLoaders => 'Индикаторы загрузки';

  @override
  String loadingVariantName(Object variantName) {
    return 'Загрузка $variantName';
  }

  @override
  String get shimmerPlaceholders => 'Shimmer-заглушки';

  @override
  String get animatedText => 'Анимированный текст';

  @override
  String get yourNextIdea => 'Ваша следующая идея.';

  @override
  String get madeWithWant => 'Создано с Want.';

  @override
  String get readyToExplore => 'Можно начинать.';

  @override
  String get changeText => 'Сменить текст';

  @override
  String get reusableGlowAndConfetti => 'Свечение и конфетти';

  @override
  String get aVisibleHaloWithTwoExpandingWaves =>
      'Заметное свечение с двумя расходящимися волнами.';

  @override
  String get exploreWant => 'Открыть Want';

  @override
  String get triggerBackgroundWave => 'Запустить волну фона';

  @override
  String get switchToRussian => 'Switch to English';

  @override
  String get switchToEnglish => 'Переключить на английский';

  @override
  String get error => 'Ошибка';

  @override
  String get warning => 'Предупреждение';

  @override
  String get info => 'Информация';

  @override
  String get success => 'Успех';

  @override
  String get brandAndTheme => 'Бренд и тема';

  @override
  String get componentPreview => 'Пример компонентов';

  @override
  String get categoryFoundation => 'Основа';

  @override
  String get categoryInputs => 'Ввод';

  @override
  String get categoryNavigation => 'Навигация';

  @override
  String get categoryData => 'Данные';

  @override
  String get categoryFeedback => 'Обратная связь';

  @override
  String get categoryEffects => 'Эффекты';

  @override
  String get categoryCompositions => 'Композиции';

  @override
  String get componentsInAction => 'Компоненты в действии';

  @override
  String get sliders => 'Ползунки';

  @override
  String get intensity => 'Интенсивность';

  @override
  String get range => 'Диапазон';

  @override
  String get backgroundLightning => 'Фоновые молнии';

  @override
  String get lightAndSpace => 'Свет и пространство';

  @override
  String get svg3D => '3D модель SVG';

  @override
  String get rotateLogo =>
      'Перетащите или используйте клавиши со стрелками, чтобы повернуть логотип.';

  @override
  String get changeLanguage => 'Язык';
}
