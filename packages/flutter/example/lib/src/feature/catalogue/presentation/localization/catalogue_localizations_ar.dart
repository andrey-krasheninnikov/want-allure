// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class CatalogueLocalizationsAr extends CatalogueLocalizations {
  CatalogueLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get findInCatalogue => 'البحث في الكتالوج';

  @override
  String get previousMatch => 'المباراة السابقة';

  @override
  String get nextMatch => 'المباراة القادمة';

  @override
  String get closeFind => 'إغلاق البحث';

  @override
  String get noMatches => 'لا توجد مباريات';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return 'تطابق $active من $count';
  }

  @override
  String get dismissMessage => 'تجاهل الرسالة';

  @override
  String get pauseBackground => 'وقفة الخلفية';

  @override
  String get resumeBackground => 'استئناف الخلفية';

  @override
  String get oneWantEveryPlatform => 'واحد Want. كل منصة.';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      'نفس الألوان وعناصر التحكم والحركة Want عبر الويب وFlutter. استكشف المكونات باستخدام لوحة المفاتيح واللمس وإدخال المؤشر.';

  @override
  String get findCtrlF => 'البحث عن · ⌘/Ctrl F';

  @override
  String get useLightTheme => 'استخدام السمة الفاتحة';

  @override
  String get useDarkTheme => 'استخدام السمة الداكنة';

  @override
  String get reduceMotion => 'تقليل الحركة';

  @override
  String get opaqueSurfaces => 'الأسطح غير الشفافة';

  @override
  String get resumeEffects => 'استئناف التأثيرات';

  @override
  String get pauseEffects => 'تأثيرات الإيقاف المؤقت';

  @override
  String get palette => 'لوحة';

  @override
  String get typography => 'الطباعة';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · يوفر Want مساحة للمحتوى الخاص بك.';
  }

  @override
  String get buttons => 'الأزرار';

  @override
  String variantNamePressed(Object variantName) {
    return 'تم الضغط على $variantName';
  }

  @override
  String get disabled => 'معطل';

  @override
  String get downloadSelected => 'تحميل المحدد';

  @override
  String get downloadExample => 'تنزيل المثال';

  @override
  String get fieldsInputAndTextarea => 'الحقول والمدخلات ومنطقة النص';

  @override
  String get password => 'كلمة المرور';

  @override
  String get showPassword => 'إظهار كلمة المرور';

  @override
  String get hidePassword => 'إخفاء كلمة المرور';

  @override
  String get localExample => 'مثال محلي';

  @override
  String get title => 'العنوان';

  @override
  String get editableLocalValue => 'قيمة محلية قابلة للتحرير.';

  @override
  String get invalidExample => 'مثال غير صالح';

  @override
  String get enterATitle => 'أدخل عنوانا.';

  @override
  String get disabledExample => 'مثال معطل';

  @override
  String get contoursOfSilence => 'ملامح الصمت';

  @override
  String get description => 'الوصف';

  @override
  String get describeThePreview => 'وصف المعاينة';

  @override
  String get fieldAndLabel => 'الحقل والتسمية';

  @override
  String get consumerOwnedHelperText => 'نص مساعد مملوك للمستهلك.';

  @override
  String get selectRadioCheckboxAndSwitch =>
      'حدد، الراديو، خانة الاختيار والتبديل';

  @override
  String get format => 'التنسيق';

  @override
  String get desktop => 'سطح المكتب';

  @override
  String get mobile => 'الجوال';

  @override
  String get unavailable => 'غير متاح';

  @override
  String get wallpaperOrientation => 'اتجاه ورق الجدران';

  @override
  String get includePreview => 'تضمين المعاينة';

  @override
  String get aControlledCheckbox => 'خانة الاختيار التي تسيطر عليها.';

  @override
  String get mixedSelection => 'اختيار مختلط';

  @override
  String get enableExampleSetting => 'تمكين إعداد المثال';

  @override
  String get disabledCheckbox => 'خانة الاختيار معطلة';

  @override
  String get tabsAndAccordion => 'علامات التبويب والأكورديون';

  @override
  String get landscapePreview => 'معاينة المناظر الطبيعية.';

  @override
  String get portraitPreview => 'معاينة الصورة.';

  @override
  String get howAreComponentsShared => 'كيف يتم مشاركة المكونات؟';

  @override
  String get bothAdaptersUseTheSameFoundationTokens =>
      'يستخدم كلا المحولين نفس الرموز الأساسية.';

  @override
  String get whoOwnsApplicationData => 'من يملك بيانات التطبيق؟';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence =>
      'يمتلك التطبيق المستهلك البيانات والثبات.';

  @override
  String get dialogSheetMenuTooltipAndPopover =>
      'الحوار، الورقة، القائمة، تلميح الأدوات والنوافذ المنبثقة';

  @override
  String get previewSettings => 'إعدادات المعاينة';

  @override
  String get done => 'تم';

  @override
  String get previewName => 'اسم المعاينة';

  @override
  String get openDialog => 'فتح الحوار';

  @override
  String panelSideName(Object sideName) {
    return 'لوحة $sideName';
  }

  @override
  String get closePanel => 'إغلاق اللوحة';

  @override
  String get theSheetEntersFromItsSelectedSide =>
      'تدخل الورقة من الجانب المحدد.';

  @override
  String sideNameSheet(Object sideName) {
    return 'ورقة $sideName';
  }

  @override
  String get actions => 'الإجراءات';

  @override
  String get copyLink => 'انسخ الرابط';

  @override
  String get copyActionSelected => 'تم تحديد إجراء النسخ';

  @override
  String get aKeyboardAndPointerHint => 'تلميح لوحة المفاتيح والمؤشر';

  @override
  String get hintSelected => 'تم تحديد التلميح';

  @override
  String get tooltip => 'تلميح الأداة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get note => 'ملاحظة';

  @override
  String get closeSettings => 'إغلاق الإعدادات';

  @override
  String get navigationAndBreadcrumbs => 'الملاحة وفتات الخبز';

  @override
  String get exampleNavigation => 'مثال للملاحة';

  @override
  String get collections => 'المجموعات';

  @override
  String get collectionsSelected => 'المجموعات المختارة';

  @override
  String get search => 'بحث';

  @override
  String get searchSelected => 'تم تحديد البحث';

  @override
  String get breadcrumbs => 'فتات الخبز';

  @override
  String get home => 'الصفحة الرئيسية';

  @override
  String get homeSelected => 'تم اختيار المنزل';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => 'الشارات والتنبيهات والتقدم';

  @override
  String get primary => 'الابتدائية';

  @override
  String get previewAvailable => 'المعاينة متاحة';

  @override
  String get chooseAnExampleActionToContinue =>
      'اختر إجراءً نموذجيًا للمتابعة.';

  @override
  String get couldNotLoadPreview => 'تعذر تحميل المعاينة';

  @override
  String get tryAgain => 'حاول مرة أخرى.';

  @override
  String get exampleProgress => 'تقدم المثال';

  @override
  String get loadingPreview => 'جارٍ تحميل المعاينة';

  @override
  String get toastAndSemanticSnackbars => 'الإشعارات ورسائل الحالة';

  @override
  String get localPreviewReady => 'المعاينة المحلية جاهزة';

  @override
  String get showToast => 'عرض إشعار';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName: حالة المثال';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction =>
      'ردود فعل مدركة للموضوع من خلال إجراء واحد مفيد.';

  @override
  String get dismissStatus => 'تجاهل الحالة';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get detailsSelected => 'التفاصيل مختارة';

  @override
  String get searchableCombobox => 'مربع تحرير وسرد قابل للبحث';

  @override
  String get collection => 'المجموعة';

  @override
  String get searchCollections => 'مجموعات البحث';

  @override
  String get violetHorizon => 'الأفق البنفسجي';

  @override
  String get wovenSpectrum => 'الطيف المنسوج';

  @override
  String get tableAndPagination => 'الجدول وترقيم الصفحات';

  @override
  String get localCollection => 'جمع محلي';

  @override
  String get noRecords => 'لا توجد سجلات';

  @override
  String get name => 'الاسم';

  @override
  String previewValue(Object value) {
    return 'معاينة $value';
  }

  @override
  String get pages => 'الصفحات';

  @override
  String get previousPage => 'الصفحة السابقة';

  @override
  String get nextPage => 'الصفحة التالية';

  @override
  String get rowsPerPage => 'صفوف لكل صفحة';

  @override
  String pagePage(Object page) {
    return 'صفحة $page';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$from – $to من $total';
  }

  @override
  String get fileSelection => 'اختيار الملف';

  @override
  String get images => 'الصور';

  @override
  String get chooseImages => 'اختر الصور';

  @override
  String get dropImagesHereOrChooseAFile =>
      'قم بإسقاط الصور هنا أو اختر ملفًا.';

  @override
  String get couldNotReadTheSelectedFile => 'لا يمكن قراءة الملف المحدد.';

  @override
  String removeName(Object name) {
    return 'إزالة $name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name ليست صورة مدعومة.';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return 'يتجاوز $name بايت $limit.';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return 'اختر ما يصل إلى ملفات $count.';
  }

  @override
  String get dateURLAndPageLayout => 'التاريخ وعنوان URL وتخطيط الصفحة';

  @override
  String get createAPreview => 'قم بإنشاء معاينة';

  @override
  String get localComposition => 'التكوين المحلي';

  @override
  String get previewActionSelected => 'تم تحديد إجراء المعاينة';

  @override
  String get preview => 'معاينة';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get useToday => 'استخدم اليوم';

  @override
  String get sourceURL => 'عنوان URL المصدر';

  @override
  String get openSource => 'مفتوح المصدر';

  @override
  String openUriHost(Object uriHost) {
    return 'افتح $uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => 'البطاقات والوسائط والزجاج السائل';

  @override
  String get localDemonstrationArtwork => 'عرض فني محلي';

  @override
  String get violetGradient => 'التدرج البنفسجي';

  @override
  String get previewSelected => 'تم تحديد المعاينة';

  @override
  String get downloadPanel => 'لوحة التحميل';

  @override
  String get aComposedCard => 'بطاقة مكونة';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      'تحتفظ الفتحات العامة بالمحتوى في التطبيق المستهلك.';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced =>
      'الزجاج السائل · معتم عندما تنخفض الشفافية.';

  @override
  String get contactCard => 'بطاقة الاتصال';

  @override
  String get productDesign => 'تصميم المنتج';

  @override
  String get website => 'موقع الكتروني';

  @override
  String get websiteSelected => 'تم اختيار موقع الويب';

  @override
  String get commentCarousel => 'دائري التعليق';

  @override
  String get comments => 'التعليقات';

  @override
  String get noComments => 'لا تعليقات';

  @override
  String get previousComments => 'التعليقات السابقة';

  @override
  String get nextComments => 'التعليقات التالية';

  @override
  String get readMore => 'اقرأ المزيد';

  @override
  String get collapse => 'طي';

  @override
  String reviewerIndex(Object index) {
    return 'المراجع $index';
  }

  @override
  String get today => 'اليوم';

  @override
  String get readableCopyFollowsTheSameWantTypography =>
      'تتبع النسخة المقروءة نفس أسلوب الطباعة Want.';

  @override
  String get thePreviewIsReadyToExplore => 'المعاينة جاهزة للاستكشاف.';

  @override
  String get reply => 'رد';

  @override
  String actionSelected(Object action) {
    return 'تم تحديد $action';
  }

  @override
  String get customLoaders => 'مؤشرات تحميل مخصصة';

  @override
  String loadingVariantName(Object variantName) {
    return 'جاري التحميل $variantName';
  }

  @override
  String get shimmerPlaceholders => 'عناصر نائبة بتأثير لامع';

  @override
  String get animatedText => 'نص متحرك';

  @override
  String get yourNextIdea => 'فكرتك القادمة.';

  @override
  String get madeWithWant => 'مصنوعة من Want.';

  @override
  String get readyToExplore => 'جاهز للاستكشاف.';

  @override
  String get changeText => 'تغيير النص';

  @override
  String get reusableGlowAndConfetti => 'توهج وقصاصات قابلة لإعادة الاستخدام';

  @override
  String get aVisibleHaloWithTwoExpandingWaves =>
      'هالة مرئية ذات موجتين متوسعتين.';

  @override
  String get exploreWant => 'اكتشف Want';

  @override
  String get triggerBackgroundWave => 'إثارة موجة الخلفية';

  @override
  String get switchToRussian => 'التبديل إلى الروسية';

  @override
  String get switchToEnglish => 'التبديل إلى اللغة الإنجليزية';

  @override
  String get error => 'خطأ';

  @override
  String get warning => 'تحذير';

  @override
  String get info => 'معلومات';

  @override
  String get success => 'النجاح';

  @override
  String get brandAndTheme => 'العلامة التجارية والموضوع';

  @override
  String get componentPreview => 'معاينة المكون';

  @override
  String get categoryFoundation => 'مؤسسة';

  @override
  String get categoryInputs => 'المدخلات';

  @override
  String get categoryNavigation => 'الملاحة';

  @override
  String get categoryData => 'البيانات';

  @override
  String get categoryFeedback => 'ردود الفعل';

  @override
  String get categoryEffects => 'التأثيرات';

  @override
  String get categoryCompositions => 'التراكيب';

  @override
  String get componentsInAction => 'المكونات في العمل';

  @override
  String get sliders => 'المنزلقات';

  @override
  String get intensity => 'الشدة';

  @override
  String get range => 'النطاق';

  @override
  String get backgroundLightning => 'البرق الخلفية';

  @override
  String get lightAndSpace => 'الضوء والفضاء';

  @override
  String get svg3D => '3D SVG';

  @override
  String get rotateLogo => 'اسحب أو استخدم مفاتيح الأسهم لتدوير الشعار.';

  @override
  String get changeLanguage => 'اللغة';
}
