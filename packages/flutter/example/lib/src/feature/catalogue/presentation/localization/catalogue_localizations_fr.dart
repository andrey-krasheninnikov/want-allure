// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class CatalogueLocalizationsFr extends CatalogueLocalizations {
  CatalogueLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get findInCatalogue => 'Rechercher dans le catalogue';

  @override
  String get previousMatch => 'Match précédent';

  @override
  String get nextMatch => 'Prochain match';

  @override
  String get closeFind => 'Fermer la recherche';

  @override
  String get noMatches => 'Aucune correspondance';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return 'Correspond à $active de $count';
  }

  @override
  String get dismissMessage => 'Ignorer le message';

  @override
  String get pauseBackground => 'Suspendre l\'arrière-plan';

  @override
  String get resumeBackground => 'Reprendre l\'arrière-plan';

  @override
  String get oneWantEveryPlatform => 'Un Want. Chaque plateforme.';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      'Les mêmes couleurs, commandes et mouvements du Want sur le Web et le Flutter. Explorez les composants avec la saisie au clavier, au toucher et au pointeur.';

  @override
  String get findCtrlF => 'Rechercher · ⌘/Ctrl F';

  @override
  String get useLightTheme => 'Utiliser le thème clair';

  @override
  String get useDarkTheme => 'Utiliser le thème sombre';

  @override
  String get reduceMotion => 'Réduire les mouvements';

  @override
  String get opaqueSurfaces => 'Surfaces opaques';

  @override
  String get resumeEffects => 'Reprendre les effets';

  @override
  String get pauseEffects => 'Effets de pause';

  @override
  String get palette => 'Palette';

  @override
  String get typography => 'Typographie';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want fait de la place pour votre contenu.';
  }

  @override
  String get buttons => 'Boutons';

  @override
  String variantNamePressed(Object variantName) {
    return '$variantName pressé';
  }

  @override
  String get disabled => 'Désactivé';

  @override
  String get downloadSelected => 'Télécharger sélectionné';

  @override
  String get downloadExample => 'Exemple de téléchargement';

  @override
  String get fieldsInputAndTextarea => 'Champs, saisie et zone de texte';

  @override
  String get password => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get localExample => 'Exemple local';

  @override
  String get title => 'Titre';

  @override
  String get editableLocalValue => 'Valeur locale modifiable.';

  @override
  String get invalidExample => 'Exemple invalide';

  @override
  String get enterATitle => 'Entrez un titre.';

  @override
  String get disabledExample => 'Exemple désactivé';

  @override
  String get contoursOfSilence => 'Contours du silence';

  @override
  String get description => 'Descriptif';

  @override
  String get describeThePreview => 'Décrire l\'aperçu';

  @override
  String get fieldAndLabel => 'Champ et étiquette';

  @override
  String get consumerOwnedHelperText =>
      'Texte d\'aide appartenant au consommateur.';

  @override
  String get selectRadioCheckboxAndSwitch =>
      'Sélectionnez, radio, case à cocher et commutateur';

  @override
  String get format => 'Formater';

  @override
  String get desktop => 'Bureau';

  @override
  String get mobile => 'Mobile';

  @override
  String get unavailable => 'Indisponible';

  @override
  String get wallpaperOrientation => 'Orientation du papier peint';

  @override
  String get includePreview => 'Inclure un aperçu';

  @override
  String get aControlledCheckbox => 'Une case à cocher contrôlée.';

  @override
  String get mixedSelection => 'Sélection mixte';

  @override
  String get enableExampleSetting => 'Activer l\'exemple de paramètre';

  @override
  String get disabledCheckbox => 'Case à cocher désactivée';

  @override
  String get tabsAndAccordion => 'Tablatures et accordéon';

  @override
  String get landscapePreview => 'Aperçu du paysage.';

  @override
  String get portraitPreview => 'Aperçu du portrait.';

  @override
  String get howAreComponentsShared =>
      'Comment les composants sont-ils partagés ?';

  @override
  String get bothAdaptersUseTheSameFoundationTokens =>
      'Les deux adaptateurs utilisent les mêmes jetons de fondation.';

  @override
  String get whoOwnsApplicationData =>
      'À qui appartiennent les données des applications ?';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence =>
      'L\'application consommatrice possède les données et la persistance.';

  @override
  String get dialogSheetMenuTooltipAndPopover =>
      'Boîte de dialogue, feuille, menu, info-bulle et popover';

  @override
  String get previewSettings => 'Paramètres d\'aperçu';

  @override
  String get done => 'Terminé';

  @override
  String get previewName => 'Nom de l\'aperçu';

  @override
  String get openDialog => 'Ouvrir la boîte de dialogue';

  @override
  String panelSideName(Object sideName) {
    return 'Panneau $sideName';
  }

  @override
  String get closePanel => 'Fermer le panneau';

  @override
  String get theSheetEntersFromItsSelectedSide =>
      'La feuille entre par son côté sélectionné.';

  @override
  String sideNameSheet(Object sideName) {
    return 'Fiche $sideName';
  }

  @override
  String get actions => 'Actions';

  @override
  String get copyLink => 'Copier le lien';

  @override
  String get copyActionSelected => 'Action de copie sélectionnée';

  @override
  String get aKeyboardAndPointerHint => 'Un indice de clavier et de pointeur';

  @override
  String get hintSelected => 'Indice sélectionné';

  @override
  String get tooltip => 'Info-bulle';

  @override
  String get settings => 'Paramètres';

  @override
  String get note => 'Remarque';

  @override
  String get closeSettings => 'Fermer les paramètres';

  @override
  String get navigationAndBreadcrumbs => 'Navigation et fil d\'Ariane';

  @override
  String get exampleNavigation => 'Exemple de navigation';

  @override
  String get collections => 'Collections';

  @override
  String get collectionsSelected => 'Collections sélectionnées';

  @override
  String get search => 'Rechercher';

  @override
  String get searchSelected => 'Rechercher sélectionné';

  @override
  String get breadcrumbs => 'Fil d\'Ariane';

  @override
  String get home => 'Accueil';

  @override
  String get homeSelected => 'Accueil sélectionné';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => 'Badges, alertes et progression';

  @override
  String get primary => 'Primaire';

  @override
  String get previewAvailable => 'Aperçu disponible';

  @override
  String get chooseAnExampleActionToContinue =>
      'Choisissez un exemple d’action pour continuer.';

  @override
  String get couldNotLoadPreview => 'Impossible de charger l\'aperçu';

  @override
  String get tryAgain => 'Réessayez.';

  @override
  String get exampleProgress => 'Exemple de progression';

  @override
  String get loadingPreview => 'Aperçu du chargement';

  @override
  String get toastAndSemanticSnackbars => 'Notifications et messages d’état';

  @override
  String get localPreviewReady => 'Aperçu local prêt';

  @override
  String get showToast => 'Afficher une notification';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName : exemple de statut';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction =>
      'Commentaires adaptés au thème avec une action utile.';

  @override
  String get dismissStatus => 'Statut de rejet';

  @override
  String get viewDetails => 'Afficher les détails';

  @override
  String get detailsSelected => 'Détails sélectionnés';

  @override
  String get searchableCombobox => 'Combobox consultable';

  @override
  String get collection => 'Collecte';

  @override
  String get searchCollections => 'Rechercher des collections';

  @override
  String get violetHorizon => 'Horizon violet';

  @override
  String get wovenSpectrum => 'Spectre tissé';

  @override
  String get tableAndPagination => 'Tableau et pagination';

  @override
  String get localCollection => 'Collecte locale';

  @override
  String get noRecords => 'Aucun enregistrement';

  @override
  String get name => 'Nom';

  @override
  String previewValue(Object value) {
    return 'Aperçu $value';
  }

  @override
  String get pages => 'Pages';

  @override
  String get previousPage => 'Page précédente';

  @override
  String get nextPage => 'Page suivante';

  @override
  String get rowsPerPage => 'Lignes par page';

  @override
  String pagePage(Object page) {
    return 'Page $page';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$from – $to ou $total';
  }

  @override
  String get fileSelection => 'Sélection de fichiers';

  @override
  String get images => 'Images';

  @override
  String get chooseImages => 'Choisissez des images';

  @override
  String get dropImagesHereOrChooseAFile =>
      'Déposez des images ici ou choisissez un fichier.';

  @override
  String get couldNotReadTheSelectedFile =>
      'Impossible de lire le fichier sélectionné.';

  @override
  String removeName(Object name) {
    return 'Supprimer $name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name n’est pas une image prise en charge.';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name dépasse les octets $limit.';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return 'Choisissez jusqu\'à des fichiers $count.';
  }

  @override
  String get dateURLAndPageLayout => 'Date, URL et mise en page';

  @override
  String get createAPreview => 'Créer un aperçu';

  @override
  String get localComposition => 'Composition locale';

  @override
  String get previewActionSelected => 'Action d\'aperçu sélectionnée';

  @override
  String get preview => 'Aperçu';

  @override
  String get date => 'Date';

  @override
  String get time => 'Temps';

  @override
  String get useToday => 'Utiliser aujourd\'hui';

  @override
  String get sourceURL => 'URL source';

  @override
  String get openSource => 'Source ouverte';

  @override
  String openUriHost(Object uriHost) {
    return 'Ouvrir $uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => 'Cartes, supports et verre liquide';

  @override
  String get localDemonstrationArtwork => 'Oeuvre de démonstration locale';

  @override
  String get violetGradient => 'Dégradé violet';

  @override
  String get previewSelected => 'Aperçu sélectionné';

  @override
  String get downloadPanel => 'Panneau de téléchargement';

  @override
  String get aComposedCard => 'Une carte composée';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      'Les emplacements publics conservent le contenu dans l\'application consommatrice.';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced =>
      'Verre liquide · opaque lorsque la transparence est réduite.';

  @override
  String get contactCard => 'Fiche de contact';

  @override
  String get productDesign => 'Conception de produits';

  @override
  String get website => 'Site Web';

  @override
  String get websiteSelected => 'Site Web sélectionné';

  @override
  String get commentCarousel => 'Carrousel de commentaires';

  @override
  String get comments => 'Commentaires';

  @override
  String get noComments => 'Pas de commentaires';

  @override
  String get previousComments => 'Commentaires précédents';

  @override
  String get nextComments => 'Commentaires suivants';

  @override
  String get readMore => 'Lire la suite';

  @override
  String get collapse => 'Réduire';

  @override
  String reviewerIndex(Object index) {
    return 'Évaluateur $index';
  }

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get readableCopyFollowsTheSameWantTypography =>
      'La copie lisible suit la même typographie Want.';

  @override
  String get thePreviewIsReadyToExplore => 'L\'aperçu est prêt à être exploré.';

  @override
  String get reply => 'Répondre';

  @override
  String actionSelected(Object action) {
    return '$action sélectionné';
  }

  @override
  String get customLoaders => 'Indicateurs de chargement personnalisés';

  @override
  String loadingVariantName(Object variantName) {
    return 'Chargement de $variantName';
  }

  @override
  String get shimmerPlaceholders => 'Espaces réservés scintillants';

  @override
  String get animatedText => 'Texte animé';

  @override
  String get yourNextIdea => 'Votre prochaine idée.';

  @override
  String get madeWithWant => 'Fabriqué avec Want.';

  @override
  String get readyToExplore => 'Prêt à explorer.';

  @override
  String get changeText => 'Changer le texte';

  @override
  String get reusableGlowAndConfetti => 'Lueur et confettis réutilisables';

  @override
  String get aVisibleHaloWithTwoExpandingWaves =>
      'Un halo visible avec deux vagues en expansion.';

  @override
  String get exploreWant => 'Explorer Want';

  @override
  String get triggerBackgroundWave => 'Déclencher une vague de fond';

  @override
  String get switchToRussian => 'Passer au russe';

  @override
  String get switchToEnglish => 'Passer à l\'anglais';

  @override
  String get error => 'Erreur';

  @override
  String get warning => 'Avertissement';

  @override
  String get info => 'Informations';

  @override
  String get success => 'Succès';

  @override
  String get brandAndTheme => 'Marque et thème';

  @override
  String get componentPreview => 'Aperçu du composant';

  @override
  String get categoryFoundation => 'Fondation';

  @override
  String get categoryInputs => 'Entrées';

  @override
  String get categoryNavigation => 'Navigation';

  @override
  String get categoryData => 'Données';

  @override
  String get categoryFeedback => 'Commentaires';

  @override
  String get categoryEffects => 'Effets';

  @override
  String get categoryCompositions => 'Compositions';

  @override
  String get componentsInAction => 'Composants en action';

  @override
  String get sliders => 'Curseurs';

  @override
  String get intensity => 'Intensité';

  @override
  String get range => 'Gamme';

  @override
  String get backgroundLightning => 'Éclair de fond';

  @override
  String get lightAndSpace => 'Lumière et espace';

  @override
  String get svg3D => 'SVG modèle 3D';

  @override
  String get rotateLogo =>
      'Faites glisser ou utilisez les touches fléchées pour faire pivoter le logo.';

  @override
  String get changeLanguage => 'Langue';
}
