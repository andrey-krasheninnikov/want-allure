// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class CatalogueLocalizationsEs extends CatalogueLocalizations {
  CatalogueLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get findInCatalogue => 'Buscar en catálogo';

  @override
  String get previousMatch => 'Partido anterior';

  @override
  String get nextMatch => 'Próximo partido';

  @override
  String get closeFind => 'Cerrar encontrar';

  @override
  String get noMatches => 'No hay coincidencias';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return 'Partido $active de $count';
  }

  @override
  String get dismissMessage => 'Descartar mensaje';

  @override
  String get pauseBackground => 'Pausa de fondo';

  @override
  String get resumeBackground => 'Reanudar antecedentes';

  @override
  String get oneWantEveryPlatform => 'Un Want. Cada plataforma.';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      'Los mismos colores, controles y movimientos de Want en la web y Flutter. Explore componentes con entrada de teclado, táctil y de puntero.';

  @override
  String get findCtrlF => 'Buscar · ⌘/Ctrl F';

  @override
  String get useLightTheme => 'Usar tema claro';

  @override
  String get useDarkTheme => 'Usar tema oscuro';

  @override
  String get reduceMotion => 'Reducir el movimiento';

  @override
  String get opaqueSurfaces => 'Superficies opacas';

  @override
  String get resumeEffects => 'Reanudar efectos';

  @override
  String get pauseEffects => 'Efectos de pausa';

  @override
  String get palette => 'paleta';

  @override
  String get typography => 'tipografía';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want deja espacio para su contenido.';
  }

  @override
  String get buttons => 'Botones';

  @override
  String variantNamePressed(Object variantName) {
    return '$variantName presionado';
  }

  @override
  String get disabled => 'Discapacitado';

  @override
  String get downloadSelected => 'Descargar seleccionado';

  @override
  String get downloadExample => 'Descargar ejemplo';

  @override
  String get fieldsInputAndTextarea => 'Campos, entrada y área de texto.';

  @override
  String get localExample => 'Ejemplo local';

  @override
  String get title => 'Título';

  @override
  String get editableLocalValue => 'Valor local editable.';

  @override
  String get invalidExample => 'Ejemplo no válido';

  @override
  String get enterATitle => 'Introduzca un título.';

  @override
  String get disabledExample => 'Ejemplo deshabilitado';

  @override
  String get contoursOfSilence => 'Contornos del silencio';

  @override
  String get description => 'Descripción';

  @override
  String get describeThePreview => 'Describe la vista previa';

  @override
  String get fieldAndLabel => 'Campo y etiqueta';

  @override
  String get consumerOwnedHelperText =>
      'Texto de ayuda propiedad del consumidor.';

  @override
  String get selectRadioCheckboxAndSwitch =>
      'Seleccionar, radio, casilla de verificación y cambiar';

  @override
  String get format => 'Formato';

  @override
  String get desktop => 'Escritorio';

  @override
  String get mobile => 'Móvil';

  @override
  String get unavailable => 'No disponible';

  @override
  String get wallpaperOrientation => 'Orientación del papel tapiz';

  @override
  String get includePreview => 'Incluir vista previa';

  @override
  String get aControlledCheckbox => 'Una casilla de verificación controlada.';

  @override
  String get mixedSelection => 'Selección mixta';

  @override
  String get enableExampleSetting => 'Habilitar configuración de ejemplo';

  @override
  String get disabledCheckbox => 'Casilla de verificación deshabilitada';

  @override
  String get tabsAndAccordion => 'Tablaturas y acordeón';

  @override
  String get landscapePreview => 'Vista previa del paisaje.';

  @override
  String get portraitPreview => 'Vista previa del retrato.';

  @override
  String get howAreComponentsShared => '¿Cómo se comparten los componentes?';

  @override
  String get bothAdaptersUseTheSameFoundationTokens =>
      'Ambos adaptadores utilizan los mismos tokens básicos.';

  @override
  String get whoOwnsApplicationData =>
      '¿A quién pertenecen los datos de la aplicación?';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence =>
      'La aplicación consumidora posee datos y persistencia.';

  @override
  String get dialogSheetMenuTooltipAndPopover =>
      'Diálogo, hoja, menú, información sobre herramientas y ventana emergente';

  @override
  String get previewSettings => 'Configuración de vista previa';

  @override
  String get done => 'hecho';

  @override
  String get previewName => 'Nombre de vista previa';

  @override
  String get openDialog => 'Abrir diálogo';

  @override
  String panelSideName(Object sideName) {
    return 'Panel $sideName';
  }

  @override
  String get closePanel => 'Cerrar panel';

  @override
  String get theSheetEntersFromItsSelectedSide =>
      'La hoja entra por su lado seleccionado.';

  @override
  String sideNameSheet(Object sideName) {
    return 'Hoja $sideName';
  }

  @override
  String get actions => 'Acciones';

  @override
  String get copyLink => 'Copiar enlace';

  @override
  String get copyActionSelected => 'Copiar acción seleccionada';

  @override
  String get aKeyboardAndPointerHint => 'Una sugerencia de teclado y puntero';

  @override
  String get hintSelected => 'Pista seleccionada';

  @override
  String get tooltip => 'Información sobre herramientas';

  @override
  String get settings => 'Configuración';

  @override
  String get note => 'Nota';

  @override
  String get closeSettings => 'Cerrar configuración';

  @override
  String get navigationAndBreadcrumbs => 'Navegación y migas de pan';

  @override
  String get exampleNavigation => 'Navegación de ejemplo';

  @override
  String get collections => 'Colecciones';

  @override
  String get collectionsSelected => 'Colecciones seleccionadas';

  @override
  String get search => 'Buscar';

  @override
  String get searchSelected => 'Búsqueda seleccionada';

  @override
  String get breadcrumbs => 'Pan rallado';

  @override
  String get home => 'Inicio';

  @override
  String get homeSelected => 'Casa seleccionada';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => 'Insignias, alertas y progreso.';

  @override
  String get primary => 'Primaria';

  @override
  String get previewAvailable => 'Vista previa disponible';

  @override
  String get chooseAnExampleActionToContinue =>
      'Elija una acción de ejemplo para continuar.';

  @override
  String get couldNotLoadPreview => 'No se pudo cargar la vista previa';

  @override
  String get tryAgain => 'Inténtalo de nuevo.';

  @override
  String get exampleProgress => 'Ejemplo de progreso';

  @override
  String get loadingPreview => 'Cargando vista previa';

  @override
  String get toastAndSemanticSnackbars => 'Notificaciones y avisos de estado';

  @override
  String get localPreviewReady => 'Vista previa local lista';

  @override
  String get showToast => 'Mostrar notificación';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName: ejemplo de estado';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction =>
      'Comentarios basados ​​en el tema con una acción útil.';

  @override
  String get dismissStatus => 'Descartar estado';

  @override
  String get viewDetails => 'Ver detalles';

  @override
  String get detailsSelected => 'Detalles seleccionados';

  @override
  String get searchableCombobox => 'Cuadro combinado de búsqueda';

  @override
  String get collection => 'Colección';

  @override
  String get searchCollections => 'Buscar colecciones';

  @override
  String get violetHorizon => 'Horizonte violeta';

  @override
  String get wovenSpectrum => 'Espectro tejido';

  @override
  String get tableAndPagination => 'Tabla y paginación';

  @override
  String get localCollection => 'Colección local';

  @override
  String get noRecords => 'Sin registros';

  @override
  String get name => 'Nombre';

  @override
  String previewValue(Object value) {
    return 'Vista previa $value';
  }

  @override
  String get pages => 'paginas';

  @override
  String get previousPage => 'Pagina anterior';

  @override
  String get nextPage => 'Página siguiente';

  @override
  String get rowsPerPage => 'Filas por página';

  @override
  String pagePage(Object page) {
    return 'Página $page';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$from–$to de $total';
  }

  @override
  String get fileSelection => 'Selección de archivos';

  @override
  String get images => 'Imágenes';

  @override
  String get chooseImages => 'Elige imágenes';

  @override
  String get dropImagesHereOrChooseAFile =>
      'Suelta imágenes aquí o elige un archivo.';

  @override
  String get couldNotReadTheSelectedFile =>
      'No se pudo leer el archivo seleccionado.';

  @override
  String removeName(Object name) {
    return 'Quitar $name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name no es una imagen compatible.';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name excede los bytes de $limit.';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return 'Elija hasta archivos $count.';
  }

  @override
  String get dateURLAndPageLayout => 'Fecha, URL y diseño de página';

  @override
  String get createAPreview => 'Crear una vista previa';

  @override
  String get localComposition => 'Composición local';

  @override
  String get previewActionSelected => 'Acción de vista previa seleccionada';

  @override
  String get preview => 'Vista previa';

  @override
  String get date => 'Fecha';

  @override
  String get time => 'tiempo';

  @override
  String get useToday => 'Usar hoy';

  @override
  String get sourceURL => 'URL de origen';

  @override
  String get openSource => 'Código abierto';

  @override
  String openUriHost(Object uriHost) {
    return 'Abrir $uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => 'Tarjetas, medios y vidrio líquido.';

  @override
  String get localDemonstrationArtwork => 'Obra de arte de demostración local';

  @override
  String get violetGradient => 'gradiente violeta';

  @override
  String get previewSelected => 'Vista previa seleccionada';

  @override
  String get downloadPanel => 'Panel de descarga';

  @override
  String get aComposedCard => 'Una tarjeta compuesta';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      'Los espacios públicos mantienen el contenido en la aplicación consumidora.';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced =>
      'Vidrio líquido · opaco cuando se reduce la transparencia.';

  @override
  String get contactCard => 'tarjeta de contacto';

  @override
  String get productDesign => 'Diseño de producto';

  @override
  String get website => 'Sitio web';

  @override
  String get websiteSelected => 'Sitio web seleccionado';

  @override
  String get commentCarousel => 'Carrusel de comentarios';

  @override
  String get comments => 'Comentarios';

  @override
  String get noComments => 'Sin comentarios';

  @override
  String get previousComments => 'Comentarios anteriores';

  @override
  String get nextComments => 'Siguientes comentarios';

  @override
  String get readMore => 'Leer más';

  @override
  String get collapse => 'Colapso';

  @override
  String reviewerIndex(Object index) {
    return 'Revisor $index';
  }

  @override
  String get today => 'hoy';

  @override
  String get readableCopyFollowsTheSameWantTypography =>
      'La copia legible sigue la misma tipografía Want.';

  @override
  String get thePreviewIsReadyToExplore =>
      'La vista previa está lista para explorar.';

  @override
  String get reply => 'Responder';

  @override
  String actionSelected(Object action) {
    return '$action seleccionado';
  }

  @override
  String get customLoaders => 'Indicadores de carga personalizados';

  @override
  String loadingVariantName(Object variantName) {
    return 'Cargando $variantName';
  }

  @override
  String get shimmerPlaceholders => 'Marcadores con efecto de brillo';

  @override
  String get animatedText => 'texto animado';

  @override
  String get yourNextIdea => 'Tu próxima idea.';

  @override
  String get madeWithWant => 'Fabricado con Want.';

  @override
  String get readyToExplore => 'Listo para explorar.';

  @override
  String get changeText => 'Cambiar texto';

  @override
  String get reusableGlowAndConfetti => 'Resplandor y confeti reutilizables';

  @override
  String get aVisibleHaloWithTwoExpandingWaves =>
      'Un halo visible con dos ondas en expansión.';

  @override
  String get exploreWant => 'Explorar Want';

  @override
  String get triggerBackgroundWave => 'Activar onda de fondo';

  @override
  String get switchToRussian => 'Cambiar a ruso';

  @override
  String get switchToEnglish => 'Cambiar al inglés';

  @override
  String get error => 'error';

  @override
  String get warning => 'Advertencia';

  @override
  String get info => 'Información';

  @override
  String get success => 'Éxito';

  @override
  String get brandAndTheme => 'Marca y tema';

  @override
  String get componentPreview => 'Vista previa del componente';

  @override
  String get categoryFoundation => 'Fundación';

  @override
  String get categoryInputs => 'Entradas';

  @override
  String get categoryNavigation => 'Navegación';

  @override
  String get categoryData => 'Datos';

  @override
  String get categoryFeedback => 'Comentarios';

  @override
  String get categoryEffects => 'Efectos';

  @override
  String get categoryCompositions => 'Composiciones';

  @override
  String get componentsInAction => 'Componentes en acción';

  @override
  String get sliders => 'Controles deslizantes';

  @override
  String get intensity => 'intensidad';

  @override
  String get range => 'Rango';

  @override
  String get backgroundLightning => 'Rayo de fondo';

  @override
  String get lightAndSpace => 'Luz y espacio';

  @override
  String get svg3D => '3D SVG';

  @override
  String get rotateLogo =>
      'Arrastre o use las teclas de flecha para rotar el logotipo.';

  @override
  String get changeLanguage => 'Idioma';
}
