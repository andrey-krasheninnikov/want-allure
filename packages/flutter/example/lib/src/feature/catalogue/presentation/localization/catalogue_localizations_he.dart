// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class CatalogueLocalizationsHe extends CatalogueLocalizations {
  CatalogueLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get findInCatalogue => 'מצא בקטלוג';

  @override
  String get previousMatch => 'משחק קודם';

  @override
  String get nextMatch => 'המשחק הבא';

  @override
  String get closeFind => 'סגור למצוא';

  @override
  String get noMatches => 'אין התאמות';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return 'התאם $active של $count';
  }

  @override
  String get dismissMessage => 'סגור הודעה';

  @override
  String get pauseBackground => 'השהה רקע';

  @override
  String get resumeBackground => 'רקע המשך';

  @override
  String get oneWantEveryPlatform => 'אחד Want. כל פלטפורמה.';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      'אותם צבעים, בקרות ותנועה של Want ברחבי האינטרנט ו-Flutter. חקור רכיבים עם קלט מקלדת, מגע ומצביע.';

  @override
  String get findCtrlF => 'מצא · ⌘/Ctrl F';

  @override
  String get useLightTheme => 'שימוש בערכת נושא בהירה';

  @override
  String get useDarkTheme => 'שימוש בערכת נושא כהה';

  @override
  String get reduceMotion => 'הפחת תנועה';

  @override
  String get opaqueSurfaces => 'משטחים אטומים';

  @override
  String get resumeEffects => 'אפקטים של קורות חיים';

  @override
  String get pauseEffects => 'השהה אפקטים';

  @override
  String get palette => 'פלטה';

  @override
  String get typography => 'טיפוגרפיה';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want מפנה מקום לתוכן שלך.';
  }

  @override
  String get buttons => 'כפתורים';

  @override
  String variantNamePressed(Object variantName) {
    return '$variantName לחוץ';
  }

  @override
  String get disabled => 'מושבת';

  @override
  String get downloadSelected => 'ההורדה נבחרה';

  @override
  String get downloadExample => 'דוגמה להורדה';

  @override
  String get fieldsInputAndTextarea => 'שדות, קלט ואזור טקסט';

  @override
  String get localExample => 'דוגמה מקומית';

  @override
  String get title => 'כותרת';

  @override
  String get editableLocalValue => 'ערך מקומי ניתן לעריכה.';

  @override
  String get invalidExample => 'דוגמה לא חוקית';

  @override
  String get enterATitle => 'הזן כותרת.';

  @override
  String get disabledExample => 'דוגמה לנכים';

  @override
  String get contoursOfSilence => 'קווי מתאר של שתיקה';

  @override
  String get description => 'תיאור';

  @override
  String get describeThePreview => 'תאר את התצוגה המקדימה';

  @override
  String get fieldAndLabel => 'שדה ותווית';

  @override
  String get consumerOwnedHelperText => 'טקסט עוזר בבעלות הצרכן.';

  @override
  String get selectRadioCheckboxAndSwitch => 'בחר, רדיו, תיבת סימון והחלף';

  @override
  String get format => 'פורמט';

  @override
  String get desktop => 'שולחן עבודה';

  @override
  String get mobile => 'נייד';

  @override
  String get unavailable => 'לא זמין';

  @override
  String get wallpaperOrientation => 'כיוון טפט';

  @override
  String get includePreview => 'כלול תצוגה מקדימה';

  @override
  String get aControlledCheckbox => 'תיבת סימון מבוקרת.';

  @override
  String get mixedSelection => 'מבחר מעורב';

  @override
  String get enableExampleSetting => 'אפשר הגדרת דוגמה';

  @override
  String get disabledCheckbox => 'תיבת סימון מושבתת';

  @override
  String get tabsAndAccordion => 'טאבים ואקורדיון';

  @override
  String get landscapePreview => 'תצוגה מקדימה של נוף.';

  @override
  String get portraitPreview => 'תצוגה מקדימה לאורך.';

  @override
  String get howAreComponentsShared => 'כיצד משותפים רכיבים?';

  @override
  String get bothAdaptersUseTheSameFoundationTokens =>
      'שני המתאמים משתמשים באותם אסימוני בסיס.';

  @override
  String get whoOwnsApplicationData => 'מי הבעלים של נתוני האפליקציה?';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence =>
      'האפליקציה הצורכת היא הבעלים של נתונים והתמדה.';

  @override
  String get dialogSheetMenuTooltipAndPopover =>
      'דיאלוג, גיליון, תפריט, תיאור כלים ופופ-אובר';

  @override
  String get previewSettings => 'תצוגה מקדימה של הגדרות';

  @override
  String get done => 'בוצע';

  @override
  String get previewName => 'שם תצוגה מקדימה';

  @override
  String get openDialog => 'פתח דו-שיח';

  @override
  String panelSideName(Object sideName) {
    return 'פאנל $sideName';
  }

  @override
  String get closePanel => 'סגור לוח';

  @override
  String get theSheetEntersFromItsSelectedSide =>
      'הגיליון נכנס מהצד הנבחר שלו.';

  @override
  String sideNameSheet(Object sideName) {
    return 'גיליון $sideName';
  }

  @override
  String get actions => 'פעולות';

  @override
  String get copyLink => 'העתק קישור';

  @override
  String get copyActionSelected => 'נבחרה פעולת העתקה';

  @override
  String get aKeyboardAndPointerHint => 'רמז למקלדת ומצביע';

  @override
  String get hintSelected => 'רמז נבחר';

  @override
  String get tooltip => 'טיפים לכלי עבודה';

  @override
  String get settings => 'הגדרות';

  @override
  String get note => 'הערה';

  @override
  String get closeSettings => 'סגור הגדרות';

  @override
  String get navigationAndBreadcrumbs => 'ניווט ופירורי לחם';

  @override
  String get exampleNavigation => 'ניווט לדוגמה';

  @override
  String get collections => 'אוספים';

  @override
  String get collectionsSelected => 'נבחרו אוספים';

  @override
  String get search => 'חפש';

  @override
  String get searchSelected => 'חיפוש נבחר';

  @override
  String get breadcrumbs => 'פירורי לחם';

  @override
  String get home => 'בית';

  @override
  String get homeSelected => 'נבחר בית';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => 'תגים, התראות והתקדמות';

  @override
  String get primary => 'ראשוני';

  @override
  String get previewAvailable => 'תצוגה מקדימה זמינה';

  @override
  String get chooseAnExampleActionToContinue => 'בחר פעולה לדוגמה כדי להמשיך.';

  @override
  String get couldNotLoadPreview => 'לא ניתן היה לטעון את התצוגה המקדימה';

  @override
  String get tryAgain => 'נסה שוב.';

  @override
  String get exampleProgress => 'התקדמות לדוגמה';

  @override
  String get loadingPreview => 'טוען תצוגה מקדימה';

  @override
  String get toastAndSemanticSnackbars => 'התראות והודעות מצב';

  @override
  String get localPreviewReady => 'תצוגה מקדימה מקומית מוכנה';

  @override
  String get showToast => 'הצגת התראה';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName: מצב לדוגמה';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction =>
      'משוב מודע לנושא עם פעולה שימושית אחת.';

  @override
  String get dismissStatus => 'בטל סטטוס';

  @override
  String get viewDetails => 'הצג פרטים';

  @override
  String get detailsSelected => 'פרטים נבחרו';

  @override
  String get searchableCombobox => 'תיבה משולבת ניתנת לחיפוש';

  @override
  String get collection => 'אוסף';

  @override
  String get searchCollections => 'חפש באוספים';

  @override
  String get violetHorizon => 'אופק סגול';

  @override
  String get wovenSpectrum => 'ספקטרום ארוג';

  @override
  String get tableAndPagination => 'טבלה ועימוד';

  @override
  String get localCollection => 'אוסף מקומי';

  @override
  String get noRecords => 'אין רשומות';

  @override
  String get name => 'שם';

  @override
  String previewValue(Object value) {
    return 'תצוגה מקדימה של $value';
  }

  @override
  String get pages => 'דפים';

  @override
  String get previousPage => 'העמוד הקודם';

  @override
  String get nextPage => 'העמוד הבא';

  @override
  String get rowsPerPage => 'שורות בעמוד';

  @override
  String pagePage(Object page) {
    return 'עמוד $page';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$from–$to של $total';
  }

  @override
  String get fileSelection => 'בחירת קובץ';

  @override
  String get images => 'תמונות';

  @override
  String get chooseImages => 'בחר תמונות';

  @override
  String get dropImagesHereOrChooseAFile => 'שחרר תמונות כאן או בחר קובץ.';

  @override
  String get couldNotReadTheSelectedFile => 'לא ניתן היה לקרוא את הקובץ שנבחר.';

  @override
  String removeName(Object name) {
    return 'הסר את $name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name אינה תמונה נתמכת.';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name חורג מ-$limit בתים.';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return 'בחר עד קבצי $count.';
  }

  @override
  String get dateURLAndPageLayout => 'תאריך, כתובת אתר ופריסת עמוד';

  @override
  String get createAPreview => 'צור תצוגה מקדימה';

  @override
  String get localComposition => 'הרכב מקומי';

  @override
  String get previewActionSelected => 'נבחרה פעולת תצוגה מקדימה';

  @override
  String get preview => 'תצוגה מקדימה';

  @override
  String get date => 'תאריך';

  @override
  String get time => 'זמן';

  @override
  String get useToday => 'השתמש היום';

  @override
  String get sourceURL => 'כתובת האתר של המקור';

  @override
  String get openSource => 'קוד פתוח';

  @override
  String openUriHost(Object uriHost) {
    return 'פתח את $uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => 'כרטיסים, מדיה וזכוכית נוזלית';

  @override
  String get localDemonstrationArtwork => 'יצירות הדגמה מקומיות';

  @override
  String get violetGradient => 'שיפוע סגול';

  @override
  String get previewSelected => 'נבחרה תצוגה מקדימה';

  @override
  String get downloadPanel => 'פאנל הורדה';

  @override
  String get aComposedCard => 'קלף מורכב';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      'משבצות ציבוריות שומרים תוכן באפליקציה הצורכת.';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced =>
      'זכוכית נוזלית · אטומה כאשר השקיפות מצטמצמת.';

  @override
  String get contactCard => 'כרטיס איש קשר';

  @override
  String get productDesign => 'עיצוב מוצר';

  @override
  String get website => 'אתר אינטרנט';

  @override
  String get websiteSelected => 'אתר נבחר';

  @override
  String get commentCarousel => 'קרוסלת הערות';

  @override
  String get comments => 'הערות';

  @override
  String get noComments => 'אין הערות';

  @override
  String get previousComments => 'הערות קודמות';

  @override
  String get nextComments => 'הערות הבאות';

  @override
  String get readMore => 'קרא עוד';

  @override
  String get collapse => 'התמוטט';

  @override
  String reviewerIndex(Object index) {
    return 'מבקר $index';
  }

  @override
  String get today => 'היום';

  @override
  String get readableCopyFollowsTheSameWantTypography =>
      'עותק קריא עוקב אחר אותה טיפוגרפיה Want.';

  @override
  String get thePreviewIsReadyToExplore => 'התצוגה המקדימה מוכנה לחקור.';

  @override
  String get reply => 'השב';

  @override
  String actionSelected(Object action) {
    return '$action נבחר';
  }

  @override
  String get customLoaders => 'מחווני טעינה מותאמים';

  @override
  String loadingVariantName(Object variantName) {
    return 'טוען $variantName';
  }

  @override
  String get shimmerPlaceholders => 'מצייני מיקום מנצנצים';

  @override
  String get animatedText => 'טקסט מונפש';

  @override
  String get yourNextIdea => 'הרעיון הבא שלך.';

  @override
  String get madeWithWant => 'מיוצר עם Want.';

  @override
  String get readyToExplore => 'מוכן לחקור.';

  @override
  String get changeText => 'שנה טקסט';

  @override
  String get reusableGlowAndConfetti => 'זוהר וקונפטי לשימוש חוזר';

  @override
  String get aVisibleHaloWithTwoExpandingWaves =>
      'הילה גלויה עם שני גלים מתרחבים.';

  @override
  String get exploreWant => 'חקור את Want';

  @override
  String get triggerBackgroundWave => 'מפעיל גל רקע';

  @override
  String get switchToRussian => 'תעבור לרוסית';

  @override
  String get switchToEnglish => 'עבור לאנגלית';

  @override
  String get error => 'שְׁגִיאָה';

  @override
  String get warning => 'אזהרה';

  @override
  String get info => 'מידע';

  @override
  String get success => 'הצלחה';

  @override
  String get brandAndTheme => 'מותג ומוטיב';

  @override
  String get componentPreview => 'תצוגה מקדימה של רכיב';

  @override
  String get categoryFoundation => 'קרן';

  @override
  String get categoryInputs => 'תשומות';

  @override
  String get categoryNavigation => 'ניווט';

  @override
  String get categoryData => 'נתונים';

  @override
  String get categoryFeedback => 'משוב';

  @override
  String get categoryEffects => 'אפקטים';

  @override
  String get categoryCompositions => 'קומפוזיציות';

  @override
  String get componentsInAction => 'רכיבים בפעולה';

  @override
  String get sliders => 'מחוונים';

  @override
  String get intensity => 'אינטנסיביות';

  @override
  String get range => 'טווח';

  @override
  String get backgroundLightning => 'ברק רקע';

  @override
  String get lightAndSpace => 'אור וחלל';

  @override
  String get svg3D => '3D SVG';

  @override
  String get rotateLogo => 'גרור או השתמש במקשי החצים כדי לסובב את הלוגו.';

  @override
  String get changeLanguage => 'שפה';
}
