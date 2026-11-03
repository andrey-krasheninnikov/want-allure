import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations_en.dart';
import 'catalogue_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CatalogueLocalizations
/// returned by `CatalogueLocalizations.of(context)`.
///
/// Applications need to include `CatalogueLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/catalogue_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CatalogueLocalizations.localizationsDelegates,
///   supportedLocales: CatalogueLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the CatalogueLocalizations.supportedLocales
/// property.
abstract class CatalogueLocalizations {
  CatalogueLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CatalogueLocalizations of(BuildContext context) {
    return Localizations.of<CatalogueLocalizations>(
      context,
      CatalogueLocalizations,
    )!;
  }

  static const LocalizationsDelegate<CatalogueLocalizations> delegate =
      _CatalogueLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @findInCatalogue.
  ///
  /// In en, this message translates to:
  /// **'Find in catalogue'**
  String get findInCatalogue;

  /// No description provided for @previousMatch.
  ///
  /// In en, this message translates to:
  /// **'Previous match'**
  String get previousMatch;

  /// No description provided for @nextMatch.
  ///
  /// In en, this message translates to:
  /// **'Next match'**
  String get nextMatch;

  /// No description provided for @closeFind.
  ///
  /// In en, this message translates to:
  /// **'Close find'**
  String get closeFind;

  /// No description provided for @noMatches.
  ///
  /// In en, this message translates to:
  /// **'No matches'**
  String get noMatches;

  /// No description provided for @matchActiveOfCount.
  ///
  /// In en, this message translates to:
  /// **'Match {active} of {count}'**
  String matchActiveOfCount(Object active, Object count);

  /// No description provided for @dismissMessage.
  ///
  /// In en, this message translates to:
  /// **'Dismiss message'**
  String get dismissMessage;

  /// No description provided for @pauseBackground.
  ///
  /// In en, this message translates to:
  /// **'Pause background'**
  String get pauseBackground;

  /// No description provided for @resumeBackground.
  ///
  /// In en, this message translates to:
  /// **'Resume background'**
  String get resumeBackground;

  /// No description provided for @oneWantEveryPlatform.
  ///
  /// In en, this message translates to:
  /// **'One Want. Every platform.'**
  String get oneWantEveryPlatform;

  /// No description provided for @theSameWantColorsControlsAndMotionAcrossWeb.
  ///
  /// In en, this message translates to:
  /// **'The same Want colors, controls and motion across web and Flutter. Explore components with keyboard, touch and pointer input.'**
  String get theSameWantColorsControlsAndMotionAcrossWeb;

  /// No description provided for @findCtrlF.
  ///
  /// In en, this message translates to:
  /// **'Find · ⌘/Ctrl F'**
  String get findCtrlF;

  /// No description provided for @useLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get useLightTheme;

  /// No description provided for @useDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// No description provided for @reduceMotion.
  ///
  /// In en, this message translates to:
  /// **'Reduce motion'**
  String get reduceMotion;

  /// No description provided for @opaqueSurfaces.
  ///
  /// In en, this message translates to:
  /// **'Opaque surfaces'**
  String get opaqueSurfaces;

  /// No description provided for @resumeEffects.
  ///
  /// In en, this message translates to:
  /// **'Resume effects'**
  String get resumeEffects;

  /// No description provided for @pauseEffects.
  ///
  /// In en, this message translates to:
  /// **'Pause effects'**
  String get pauseEffects;

  /// No description provided for @palette.
  ///
  /// In en, this message translates to:
  /// **'Palette'**
  String get palette;

  /// No description provided for @typography.
  ///
  /// In en, this message translates to:
  /// **'Typography'**
  String get typography;

  /// No description provided for @variantNameWantMakesRoomForYourContent.
  ///
  /// In en, this message translates to:
  /// **'{variantName} · Want makes room for your content.'**
  String variantNameWantMakesRoomForYourContent(Object variantName);

  /// No description provided for @buttons.
  ///
  /// In en, this message translates to:
  /// **'Buttons'**
  String get buttons;

  /// No description provided for @variantNamePressed.
  ///
  /// In en, this message translates to:
  /// **'{variantName} pressed'**
  String variantNamePressed(Object variantName);

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @downloadSelected.
  ///
  /// In en, this message translates to:
  /// **'Download selected'**
  String get downloadSelected;

  /// No description provided for @downloadExample.
  ///
  /// In en, this message translates to:
  /// **'Download example'**
  String get downloadExample;

  /// No description provided for @fieldsInputAndTextarea.
  ///
  /// In en, this message translates to:
  /// **'Fields, input and textarea'**
  String get fieldsInputAndTextarea;

  /// No description provided for @localExample.
  ///
  /// In en, this message translates to:
  /// **'Local example'**
  String get localExample;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @editableLocalValue.
  ///
  /// In en, this message translates to:
  /// **'Editable local value.'**
  String get editableLocalValue;

  /// No description provided for @invalidExample.
  ///
  /// In en, this message translates to:
  /// **'Invalid example'**
  String get invalidExample;

  /// No description provided for @enterATitle.
  ///
  /// In en, this message translates to:
  /// **'Enter a title.'**
  String get enterATitle;

  /// No description provided for @disabledExample.
  ///
  /// In en, this message translates to:
  /// **'Disabled example'**
  String get disabledExample;

  /// No description provided for @contoursOfSilence.
  ///
  /// In en, this message translates to:
  /// **'Contours of Silence'**
  String get contoursOfSilence;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @describeThePreview.
  ///
  /// In en, this message translates to:
  /// **'Describe the preview'**
  String get describeThePreview;

  /// No description provided for @fieldAndLabel.
  ///
  /// In en, this message translates to:
  /// **'Field and label'**
  String get fieldAndLabel;

  /// No description provided for @consumerOwnedHelperText.
  ///
  /// In en, this message translates to:
  /// **'Consumer-owned helper text.'**
  String get consumerOwnedHelperText;

  /// No description provided for @selectRadioCheckboxAndSwitch.
  ///
  /// In en, this message translates to:
  /// **'Select, radio, checkbox and switch'**
  String get selectRadioCheckboxAndSwitch;

  /// No description provided for @format.
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get format;

  /// No description provided for @desktop.
  ///
  /// In en, this message translates to:
  /// **'Desktop'**
  String get desktop;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile'**
  String get mobile;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailable;

  /// No description provided for @wallpaperOrientation.
  ///
  /// In en, this message translates to:
  /// **'Wallpaper orientation'**
  String get wallpaperOrientation;

  /// No description provided for @includePreview.
  ///
  /// In en, this message translates to:
  /// **'Include preview'**
  String get includePreview;

  /// No description provided for @aControlledCheckbox.
  ///
  /// In en, this message translates to:
  /// **'A controlled checkbox.'**
  String get aControlledCheckbox;

  /// No description provided for @mixedSelection.
  ///
  /// In en, this message translates to:
  /// **'Mixed selection'**
  String get mixedSelection;

  /// No description provided for @enableExampleSetting.
  ///
  /// In en, this message translates to:
  /// **'Enable example setting'**
  String get enableExampleSetting;

  /// No description provided for @disabledCheckbox.
  ///
  /// In en, this message translates to:
  /// **'Disabled checkbox'**
  String get disabledCheckbox;

  /// No description provided for @tabsAndAccordion.
  ///
  /// In en, this message translates to:
  /// **'Tabs and accordion'**
  String get tabsAndAccordion;

  /// No description provided for @landscapePreview.
  ///
  /// In en, this message translates to:
  /// **'Landscape preview.'**
  String get landscapePreview;

  /// No description provided for @portraitPreview.
  ///
  /// In en, this message translates to:
  /// **'Portrait preview.'**
  String get portraitPreview;

  /// No description provided for @howAreComponentsShared.
  ///
  /// In en, this message translates to:
  /// **'How are components shared?'**
  String get howAreComponentsShared;

  /// No description provided for @bothAdaptersUseTheSameFoundationTokens.
  ///
  /// In en, this message translates to:
  /// **'Both adapters use the same foundation tokens.'**
  String get bothAdaptersUseTheSameFoundationTokens;

  /// No description provided for @whoOwnsApplicationData.
  ///
  /// In en, this message translates to:
  /// **'Who owns application data?'**
  String get whoOwnsApplicationData;

  /// No description provided for @theConsumingApplicationOwnsDataAndPersistence.
  ///
  /// In en, this message translates to:
  /// **'The consuming application owns data and persistence.'**
  String get theConsumingApplicationOwnsDataAndPersistence;

  /// No description provided for @dialogSheetMenuTooltipAndPopover.
  ///
  /// In en, this message translates to:
  /// **'Dialog, sheet, menu, tooltip and popover'**
  String get dialogSheetMenuTooltipAndPopover;

  /// No description provided for @previewSettings.
  ///
  /// In en, this message translates to:
  /// **'Preview settings'**
  String get previewSettings;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @previewName.
  ///
  /// In en, this message translates to:
  /// **'Preview name'**
  String get previewName;

  /// No description provided for @openDialog.
  ///
  /// In en, this message translates to:
  /// **'Open dialog'**
  String get openDialog;

  /// No description provided for @panelSideName.
  ///
  /// In en, this message translates to:
  /// **'Panel {sideName}'**
  String panelSideName(Object sideName);

  /// No description provided for @closePanel.
  ///
  /// In en, this message translates to:
  /// **'Close panel'**
  String get closePanel;

  /// No description provided for @theSheetEntersFromItsSelectedSide.
  ///
  /// In en, this message translates to:
  /// **'The sheet enters from its selected side.'**
  String get theSheetEntersFromItsSelectedSide;

  /// No description provided for @sideNameSheet.
  ///
  /// In en, this message translates to:
  /// **'{sideName} sheet'**
  String sideNameSheet(Object sideName);

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @copyLink.
  ///
  /// In en, this message translates to:
  /// **'Copy link'**
  String get copyLink;

  /// No description provided for @copyActionSelected.
  ///
  /// In en, this message translates to:
  /// **'Copy action selected'**
  String get copyActionSelected;

  /// No description provided for @aKeyboardAndPointerHint.
  ///
  /// In en, this message translates to:
  /// **'A keyboard and pointer hint'**
  String get aKeyboardAndPointerHint;

  /// No description provided for @hintSelected.
  ///
  /// In en, this message translates to:
  /// **'Hint selected'**
  String get hintSelected;

  /// No description provided for @tooltip.
  ///
  /// In en, this message translates to:
  /// **'Tooltip'**
  String get tooltip;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @closeSettings.
  ///
  /// In en, this message translates to:
  /// **'Close settings'**
  String get closeSettings;

  /// No description provided for @navigationAndBreadcrumbs.
  ///
  /// In en, this message translates to:
  /// **'Navigation and breadcrumbs'**
  String get navigationAndBreadcrumbs;

  /// No description provided for @exampleNavigation.
  ///
  /// In en, this message translates to:
  /// **'Example navigation'**
  String get exampleNavigation;

  /// No description provided for @collections.
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collections;

  /// No description provided for @collectionsSelected.
  ///
  /// In en, this message translates to:
  /// **'Collections selected'**
  String get collectionsSelected;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchSelected.
  ///
  /// In en, this message translates to:
  /// **'Search selected'**
  String get searchSelected;

  /// No description provided for @breadcrumbs.
  ///
  /// In en, this message translates to:
  /// **'Breadcrumbs'**
  String get breadcrumbs;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @homeSelected.
  ///
  /// In en, this message translates to:
  /// **'Home selected'**
  String get homeSelected;

  /// No description provided for @uiKit.
  ///
  /// In en, this message translates to:
  /// **'UI kit'**
  String get uiKit;

  /// No description provided for @badgesAlertsAndProgress.
  ///
  /// In en, this message translates to:
  /// **'Badges, alerts and progress'**
  String get badgesAlertsAndProgress;

  /// No description provided for @primary.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primary;

  /// No description provided for @previewAvailable.
  ///
  /// In en, this message translates to:
  /// **'Preview available'**
  String get previewAvailable;

  /// No description provided for @chooseAnExampleActionToContinue.
  ///
  /// In en, this message translates to:
  /// **'Choose an example action to continue.'**
  String get chooseAnExampleActionToContinue;

  /// No description provided for @couldNotLoadPreview.
  ///
  /// In en, this message translates to:
  /// **'Could not load preview'**
  String get couldNotLoadPreview;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again.'**
  String get tryAgain;

  /// No description provided for @exampleProgress.
  ///
  /// In en, this message translates to:
  /// **'Example progress'**
  String get exampleProgress;

  /// No description provided for @loadingPreview.
  ///
  /// In en, this message translates to:
  /// **'Loading preview'**
  String get loadingPreview;

  /// No description provided for @toastAndSemanticSnackbars.
  ///
  /// In en, this message translates to:
  /// **'Toast and semantic snackbars'**
  String get toastAndSemanticSnackbars;

  /// No description provided for @localPreviewReady.
  ///
  /// In en, this message translates to:
  /// **'Local preview ready'**
  String get localPreviewReady;

  /// No description provided for @showToast.
  ///
  /// In en, this message translates to:
  /// **'Show toast'**
  String get showToast;

  /// No description provided for @variantNameExampleStatus.
  ///
  /// In en, this message translates to:
  /// **'{variantName}: example status'**
  String variantNameExampleStatus(Object variantName);

  /// No description provided for @themeAwareFeedbackWithOneUsefulAction.
  ///
  /// In en, this message translates to:
  /// **'Theme-aware feedback with one useful action.'**
  String get themeAwareFeedbackWithOneUsefulAction;

  /// No description provided for @dismissStatus.
  ///
  /// In en, this message translates to:
  /// **'Dismiss status'**
  String get dismissStatus;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View details'**
  String get viewDetails;

  /// No description provided for @detailsSelected.
  ///
  /// In en, this message translates to:
  /// **'Details selected'**
  String get detailsSelected;

  /// No description provided for @searchableCombobox.
  ///
  /// In en, this message translates to:
  /// **'Searchable combobox'**
  String get searchableCombobox;

  /// No description provided for @collection.
  ///
  /// In en, this message translates to:
  /// **'Collection'**
  String get collection;

  /// No description provided for @searchCollections.
  ///
  /// In en, this message translates to:
  /// **'Search collections'**
  String get searchCollections;

  /// No description provided for @violetHorizon.
  ///
  /// In en, this message translates to:
  /// **'Violet Horizon'**
  String get violetHorizon;

  /// No description provided for @wovenSpectrum.
  ///
  /// In en, this message translates to:
  /// **'Woven Spectrum'**
  String get wovenSpectrum;

  /// No description provided for @tableAndPagination.
  ///
  /// In en, this message translates to:
  /// **'Table and pagination'**
  String get tableAndPagination;

  /// No description provided for @localCollection.
  ///
  /// In en, this message translates to:
  /// **'Local collection'**
  String get localCollection;

  /// No description provided for @noRecords.
  ///
  /// In en, this message translates to:
  /// **'No records'**
  String get noRecords;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @previewValue.
  ///
  /// In en, this message translates to:
  /// **'Preview {value}'**
  String previewValue(Object value);

  /// No description provided for @pages.
  ///
  /// In en, this message translates to:
  /// **'Pages'**
  String get pages;

  /// No description provided for @previousPage.
  ///
  /// In en, this message translates to:
  /// **'Previous page'**
  String get previousPage;

  /// No description provided for @nextPage.
  ///
  /// In en, this message translates to:
  /// **'Next page'**
  String get nextPage;

  /// No description provided for @rowsPerPage.
  ///
  /// In en, this message translates to:
  /// **'Rows per page'**
  String get rowsPerPage;

  /// No description provided for @pagePage.
  ///
  /// In en, this message translates to:
  /// **'Page {page}'**
  String pagePage(Object page);

  /// No description provided for @fromToOfTotal.
  ///
  /// In en, this message translates to:
  /// **'{from}–{to} of {total}'**
  String fromToOfTotal(Object from, Object to, Object total);

  /// No description provided for @fileSelection.
  ///
  /// In en, this message translates to:
  /// **'File selection'**
  String get fileSelection;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Images'**
  String get images;

  /// No description provided for @chooseImages.
  ///
  /// In en, this message translates to:
  /// **'Choose images'**
  String get chooseImages;

  /// No description provided for @dropImagesHereOrChooseAFile.
  ///
  /// In en, this message translates to:
  /// **'Drop images here or choose a file.'**
  String get dropImagesHereOrChooseAFile;

  /// No description provided for @couldNotReadTheSelectedFile.
  ///
  /// In en, this message translates to:
  /// **'Could not read the selected file.'**
  String get couldNotReadTheSelectedFile;

  /// No description provided for @removeName.
  ///
  /// In en, this message translates to:
  /// **'Remove {name}'**
  String removeName(Object name);

  /// No description provided for @nameIsNotASupportedImage.
  ///
  /// In en, this message translates to:
  /// **'{name} is not a supported image.'**
  String nameIsNotASupportedImage(Object name);

  /// No description provided for @nameExceedsLimitBytes.
  ///
  /// In en, this message translates to:
  /// **'{name} exceeds {limit} bytes.'**
  String nameExceedsLimitBytes(Object name, Object limit);

  /// No description provided for @chooseUpToCountFiles.
  ///
  /// In en, this message translates to:
  /// **'Choose up to {count} files.'**
  String chooseUpToCountFiles(Object count);

  /// No description provided for @dateURLAndPageLayout.
  ///
  /// In en, this message translates to:
  /// **'Date, URL and page layout'**
  String get dateURLAndPageLayout;

  /// No description provided for @createAPreview.
  ///
  /// In en, this message translates to:
  /// **'Create a preview'**
  String get createAPreview;

  /// No description provided for @localComposition.
  ///
  /// In en, this message translates to:
  /// **'Local composition'**
  String get localComposition;

  /// No description provided for @previewActionSelected.
  ///
  /// In en, this message translates to:
  /// **'Preview action selected'**
  String get previewActionSelected;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @useToday.
  ///
  /// In en, this message translates to:
  /// **'Use today'**
  String get useToday;

  /// No description provided for @sourceURL.
  ///
  /// In en, this message translates to:
  /// **'Source URL'**
  String get sourceURL;

  /// No description provided for @openSource.
  ///
  /// In en, this message translates to:
  /// **'Open source'**
  String get openSource;

  /// No description provided for @openUriHost.
  ///
  /// In en, this message translates to:
  /// **'Open {uriHost}'**
  String openUriHost(Object uriHost);

  /// No description provided for @cardsMediaAndLiquidGlass.
  ///
  /// In en, this message translates to:
  /// **'Cards, media and liquid glass'**
  String get cardsMediaAndLiquidGlass;

  /// No description provided for @localDemonstrationArtwork.
  ///
  /// In en, this message translates to:
  /// **'Local demonstration artwork'**
  String get localDemonstrationArtwork;

  /// No description provided for @violetGradient.
  ///
  /// In en, this message translates to:
  /// **'Violet gradient'**
  String get violetGradient;

  /// No description provided for @previewSelected.
  ///
  /// In en, this message translates to:
  /// **'Preview selected'**
  String get previewSelected;

  /// No description provided for @downloadPanel.
  ///
  /// In en, this message translates to:
  /// **'Download panel'**
  String get downloadPanel;

  /// No description provided for @aComposedCard.
  ///
  /// In en, this message translates to:
  /// **'A composed card'**
  String get aComposedCard;

  /// No description provided for @publicSlotsKeepContentInTheConsumingApplication.
  ///
  /// In en, this message translates to:
  /// **'Public slots keep content in the consuming application.'**
  String get publicSlotsKeepContentInTheConsumingApplication;

  /// No description provided for @liquidGlassOpaqueWhenTransparencyIsReduced.
  ///
  /// In en, this message translates to:
  /// **'Liquid glass · opaque when transparency is reduced.'**
  String get liquidGlassOpaqueWhenTransparencyIsReduced;

  /// No description provided for @contactCard.
  ///
  /// In en, this message translates to:
  /// **'Contact card'**
  String get contactCard;

  /// No description provided for @productDesign.
  ///
  /// In en, this message translates to:
  /// **'Product design'**
  String get productDesign;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @websiteSelected.
  ///
  /// In en, this message translates to:
  /// **'Website selected'**
  String get websiteSelected;

  /// No description provided for @commentCarousel.
  ///
  /// In en, this message translates to:
  /// **'Comment carousel'**
  String get commentCarousel;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments'**
  String get noComments;

  /// No description provided for @previousComments.
  ///
  /// In en, this message translates to:
  /// **'Previous comments'**
  String get previousComments;

  /// No description provided for @nextComments.
  ///
  /// In en, this message translates to:
  /// **'Next comments'**
  String get nextComments;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @collapse.
  ///
  /// In en, this message translates to:
  /// **'Collapse'**
  String get collapse;

  /// No description provided for @reviewerIndex.
  ///
  /// In en, this message translates to:
  /// **'Reviewer {index}'**
  String reviewerIndex(Object index);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @readableCopyFollowsTheSameWantTypography.
  ///
  /// In en, this message translates to:
  /// **'Readable copy follows the same Want typography.'**
  String get readableCopyFollowsTheSameWantTypography;

  /// No description provided for @thePreviewIsReadyToExplore.
  ///
  /// In en, this message translates to:
  /// **'The preview is ready to explore.'**
  String get thePreviewIsReadyToExplore;

  /// No description provided for @reply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// No description provided for @actionSelected.
  ///
  /// In en, this message translates to:
  /// **'{action} selected'**
  String actionSelected(Object action);

  /// No description provided for @customLoaders.
  ///
  /// In en, this message translates to:
  /// **'Custom loaders'**
  String get customLoaders;

  /// No description provided for @loadingVariantName.
  ///
  /// In en, this message translates to:
  /// **'Loading {variantName}'**
  String loadingVariantName(Object variantName);

  /// No description provided for @shimmerPlaceholders.
  ///
  /// In en, this message translates to:
  /// **'Shimmer placeholders'**
  String get shimmerPlaceholders;

  /// No description provided for @animatedText.
  ///
  /// In en, this message translates to:
  /// **'Animated text'**
  String get animatedText;

  /// No description provided for @yourNextIdea.
  ///
  /// In en, this message translates to:
  /// **'Your next idea.'**
  String get yourNextIdea;

  /// No description provided for @madeWithWant.
  ///
  /// In en, this message translates to:
  /// **'Made with Want.'**
  String get madeWithWant;

  /// No description provided for @readyToExplore.
  ///
  /// In en, this message translates to:
  /// **'Ready to explore.'**
  String get readyToExplore;

  /// No description provided for @changeText.
  ///
  /// In en, this message translates to:
  /// **'Change text'**
  String get changeText;

  /// No description provided for @reusableGlowAndConfetti.
  ///
  /// In en, this message translates to:
  /// **'Reusable glow and confetti'**
  String get reusableGlowAndConfetti;

  /// No description provided for @aVisibleHaloWithTwoExpandingWaves.
  ///
  /// In en, this message translates to:
  /// **'A visible halo with two expanding waves.'**
  String get aVisibleHaloWithTwoExpandingWaves;

  /// No description provided for @exploreWant.
  ///
  /// In en, this message translates to:
  /// **'Explore Want'**
  String get exploreWant;

  /// No description provided for @triggerBackgroundWave.
  ///
  /// In en, this message translates to:
  /// **'Trigger background wave'**
  String get triggerBackgroundWave;

  /// No description provided for @switchToRussian.
  ///
  /// In en, this message translates to:
  /// **'Switch to Russian'**
  String get switchToRussian;

  /// No description provided for @switchToEnglish.
  ///
  /// In en, this message translates to:
  /// **'Switch to English'**
  String get switchToEnglish;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @warning.
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @brandAndTheme.
  ///
  /// In en, this message translates to:
  /// **'Brand and theme'**
  String get brandAndTheme;

  /// No description provided for @componentPreview.
  ///
  /// In en, this message translates to:
  /// **'Component preview'**
  String get componentPreview;
}

class _CatalogueLocalizationsDelegate
    extends LocalizationsDelegate<CatalogueLocalizations> {
  const _CatalogueLocalizationsDelegate();

  @override
  Future<CatalogueLocalizations> load(Locale locale) {
    return SynchronousFuture<CatalogueLocalizations>(
      lookupCatalogueLocalizations(locale),
    );
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_CatalogueLocalizationsDelegate old) => false;
}

CatalogueLocalizations lookupCatalogueLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return CatalogueLocalizationsEn();
    case 'ru':
      return CatalogueLocalizationsRu();
  }

  throw FlutterError(
    'CatalogueLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
