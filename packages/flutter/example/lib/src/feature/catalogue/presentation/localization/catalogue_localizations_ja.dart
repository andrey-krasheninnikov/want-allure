// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class CatalogueLocalizationsJa extends CatalogueLocalizations {
  CatalogueLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get findInCatalogue => 'カタログで探す';

  @override
  String get previousMatch => '前回の試合';

  @override
  String get nextMatch => '次の試合';

  @override
  String get closeFind => '検索を閉じる';

  @override
  String get noMatches => '一致しません';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return '$active または $count と一致';
  }

  @override
  String get dismissMessage => 'メッセージを閉じる';

  @override
  String get pauseBackground => '背景を一時停止する';

  @override
  String get resumeBackground => '履歴書の背景';

  @override
  String get oneWantEveryPlatform => 'Want 1 つ。すべてのプラットフォーム。';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      'ウェブと Flutter で同じ Want カラー、コントロール、モーション。キーボード、タッチ、ポインター入力を使用してコンポーネントを探索します。';

  @override
  String get findCtrlF => '検索 · ⌘/Ctrl F';

  @override
  String get useLightTheme => 'ライトテーマを使う';

  @override
  String get useDarkTheme => 'ダークテーマを使う';

  @override
  String get reduceMotion => '動きを減らす';

  @override
  String get opaqueSurfaces => '不透明な表面';

  @override
  String get resumeEffects => '効果を再開する';

  @override
  String get pauseEffects => 'エフェクトを一時停止する';

  @override
  String get palette => 'パレット';

  @override
  String get typography => 'タイポグラフィー';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want はコンテンツ用のスペースを確保します。';
  }

  @override
  String get buttons => 'ボタン';

  @override
  String variantNamePressed(Object variantName) {
    return '$variantNameが押されました';
  }

  @override
  String get disabled => '障害者';

  @override
  String get downloadSelected => '選択したダウンロード';

  @override
  String get downloadExample => 'ダウンロード例';

  @override
  String get fieldsInputAndTextarea => 'フィールド、入力エリア、テキストエリア';

  @override
  String get localExample => '地元の例';

  @override
  String get title => 'タイトル';

  @override
  String get editableLocalValue => '編集可能なローカル値。';

  @override
  String get invalidExample => '無効な例';

  @override
  String get enterATitle => 'タイトルを入力します。';

  @override
  String get disabledExample => '無効な例';

  @override
  String get contoursOfSilence => '静寂の輪郭';

  @override
  String get description => '説明';

  @override
  String get describeThePreview => 'プレビューの説明';

  @override
  String get fieldAndLabel => 'フィールドとラベル';

  @override
  String get consumerOwnedHelperText => '消費者所有のヘルパー テキスト。';

  @override
  String get selectRadioCheckboxAndSwitch => '選択、ラジオ、チェックボックス、スイッチ';

  @override
  String get format => 'フォーマット';

  @override
  String get desktop => 'デスクトップ';

  @override
  String get mobile => 'モバイル';

  @override
  String get unavailable => '利用不可';

  @override
  String get wallpaperOrientation => '壁紙の向き';

  @override
  String get includePreview => 'プレビューを含める';

  @override
  String get aControlledCheckbox => '制御されたチェックボックス。';

  @override
  String get mixedSelection => '混合選択';

  @override
  String get enableExampleSetting => '設定例を有効にする';

  @override
  String get disabledCheckbox => '無効なチェックボックス';

  @override
  String get tabsAndAccordion => 'タブ譜とアコーディオン';

  @override
  String get landscapePreview => '風景のプレビュー。';

  @override
  String get portraitPreview => 'ポートレートプレビュー。';

  @override
  String get howAreComponentsShared => 'コンポーネントはどのように共有されますか?';

  @override
  String get bothAdaptersUseTheSameFoundationTokens =>
      'どちらのアダプターも同じ基盤トークンを使用します。';

  @override
  String get whoOwnsApplicationData => 'アプリケーションデータの所有者は誰ですか?';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence =>
      '使用側アプリケーションはデータと永続性を所有します。';

  @override
  String get dialogSheetMenuTooltipAndPopover =>
      'ダイアログ、シート、メニュー、ツールチップ、ポップオーバー';

  @override
  String get previewSettings => 'プレビュー設定';

  @override
  String get done => '完了';

  @override
  String get previewName => 'プレビュー名';

  @override
  String get openDialog => 'ダイアログを開く';

  @override
  String panelSideName(Object sideName) {
    return 'パネル $sideName';
  }

  @override
  String get closePanel => 'パネルを閉じる';

  @override
  String get theSheetEntersFromItsSelectedSide => 'シートは選択した側から入ります。';

  @override
  String sideNameSheet(Object sideName) {
    return '$sideNameシート';
  }

  @override
  String get actions => 'アクション';

  @override
  String get copyLink => 'リンクをコピー';

  @override
  String get copyActionSelected => 'コピーアクションが選択されました';

  @override
  String get aKeyboardAndPointerHint => 'キーボードとポインタのヒント';

  @override
  String get hintSelected => 'ヒントが選択されました';

  @override
  String get tooltip => 'ツールチップ';

  @override
  String get settings => '設定';

  @override
  String get note => '注記';

  @override
  String get closeSettings => '設定を閉じる';

  @override
  String get navigationAndBreadcrumbs => 'ナビゲーションとブレッドクラム';

  @override
  String get exampleNavigation => 'ナビゲーションの例';

  @override
  String get collections => 'コレクション';

  @override
  String get collectionsSelected => '選択されたコレクション';

  @override
  String get search => '検索';

  @override
  String get searchSelected => '選択された検索';

  @override
  String get breadcrumbs => 'ブレッドクラム';

  @override
  String get home => 'ホーム';

  @override
  String get homeSelected => 'ホームが選択されました';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => 'バッジ、アラート、進捗状況';

  @override
  String get primary => 'プライマリー';

  @override
  String get previewAvailable => 'プレビューが利用可能';

  @override
  String get chooseAnExampleActionToContinue => '続行するにはアクション例を選択してください。';

  @override
  String get couldNotLoadPreview => 'プレビューを読み込めませんでした';

  @override
  String get tryAgain => 'もう一度試してください。';

  @override
  String get exampleProgress => '進捗状況の例';

  @override
  String get loadingPreview => 'プレビューを読み込んでいます';

  @override
  String get toastAndSemanticSnackbars => 'トーストおよびセマンティック スナックバー';

  @override
  String get localPreviewReady => 'ローカルプレビューの準備ができました';

  @override
  String get showToast => 'トーストを表示';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName: ステータスの例';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction =>
      '1 つの便利なアクションを含むテーマに応じたフィードバック。';

  @override
  String get dismissStatus => 'ステータスを却下';

  @override
  String get viewDetails => '詳細を見る';

  @override
  String get detailsSelected => '選択された詳細';

  @override
  String get searchableCombobox => '検索可能なコンボボックス';

  @override
  String get collection => 'コレクション';

  @override
  String get searchCollections => 'コレクションを検索する';

  @override
  String get violetHorizon => 'バイオレットホライゾン';

  @override
  String get wovenSpectrum => '織られたスペクトル';

  @override
  String get tableAndPagination => '表とページネーション';

  @override
  String get localCollection => '地元のコレクション';

  @override
  String get noRecords => '記録がありません';

  @override
  String get name => '名前';

  @override
  String previewValue(Object value) {
    return '$valueのプレビュー';
  }

  @override
  String get pages => 'ページ';

  @override
  String get previousPage => '前のページへ';

  @override
  String get nextPage => '次のページ';

  @override
  String get rowsPerPage => 'ページあたりの行数';

  @override
  String pagePage(Object page) {
    return 'ページ $page';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$from～$to/$total';
  }

  @override
  String get fileSelection => 'ファイルの選択';

  @override
  String get images => '画像';

  @override
  String get chooseImages => '画像を選択してください';

  @override
  String get dropImagesHereOrChooseAFile => 'ここに画像をドロップするか、ファイルを選択します。';

  @override
  String get couldNotReadTheSelectedFile => '選択したファイルを読み取れませんでした。';

  @override
  String removeName(Object name) {
    return '$nameを削除';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name はサポートされているイメージではありません。';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name が $limit バイトを超えています。';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return '最大 $count ファイルを選択します。';
  }

  @override
  String get dateURLAndPageLayout => '日付、URL、ページレイアウト';

  @override
  String get createAPreview => 'プレビューを作成する';

  @override
  String get localComposition => '地域構成';

  @override
  String get previewActionSelected => 'プレビューアクションが選択されました';

  @override
  String get preview => 'プレビュー';

  @override
  String get date => '日付';

  @override
  String get time => '時間';

  @override
  String get useToday => '今日使用してください';

  @override
  String get sourceURL => 'ソースURL';

  @override
  String get openSource => 'オープンソース';

  @override
  String openUriHost(Object uriHost) {
    return '$uriHostを開く';
  }

  @override
  String get cardsMediaAndLiquidGlass => 'カード、メディア、液体ガラス';

  @override
  String get localDemonstrationArtwork => '現地デモンストレーション作品';

  @override
  String get violetGradient => '紫のグラデーション';

  @override
  String get previewSelected => 'プレビューが選択されました';

  @override
  String get downloadPanel => 'ダウンロードパネル';

  @override
  String get aComposedCard => '構成されたカード';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      'パブリック スロットは、消費側アプリケーションにコンテンツを保持します。';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced =>
      '液体ガラス・透明度が下がると不透明になります。';

  @override
  String get contactCard => '連絡先カード';

  @override
  String get productDesign => 'プロダクトデザイン';

  @override
  String get website => 'ウェブサイト';

  @override
  String get websiteSelected => '選択されたウェブサイト';

  @override
  String get commentCarousel => 'コメントカルーセル';

  @override
  String get comments => 'コメント';

  @override
  String get noComments => 'コメントはありません';

  @override
  String get previousComments => '以前のコメント';

  @override
  String get nextComments => '次のコメント';

  @override
  String get readMore => '続きを読む';

  @override
  String get collapse => '崩壊する';

  @override
  String reviewerIndex(Object index) {
    return 'レビュアー $index';
  }

  @override
  String get today => '今日';

  @override
  String get readableCopyFollowsTheSameWantTypography =>
      '読みやすいコピーは、同じ Want タイポグラフィに従っています。';

  @override
  String get thePreviewIsReadyToExplore => 'プレビューを探索する準備ができました。';

  @override
  String get reply => '返信';

  @override
  String actionSelected(Object action) {
    return '$actionが選択されました';
  }

  @override
  String get customLoaders => 'カスタムローダー';

  @override
  String loadingVariantName(Object variantName) {
    return '$variantNameをロード中';
  }

  @override
  String get shimmerPlaceholders => 'シマープレースホルダー';

  @override
  String get animatedText => 'アニメーションテキスト';

  @override
  String get yourNextIdea => '次のアイデア。';

  @override
  String get madeWithWant => 'Wantで作られています。';

  @override
  String get readyToExplore => '探検する準備ができました。';

  @override
  String get changeText => 'テキストを変更する';

  @override
  String get reusableGlowAndConfetti => '再利用可能なグローと紙吹雪';

  @override
  String get aVisibleHaloWithTwoExpandingWaves => '2 つの拡大する波を持つ目に見えるハロー。';

  @override
  String get exploreWant => 'Want を探索する';

  @override
  String get triggerBackgroundWave => 'トリガーバックグラウンドウェーブ';

  @override
  String get switchToRussian => 'ロシア語に切り替える';

  @override
  String get switchToEnglish => '英語に切り替える';

  @override
  String get error => 'エラー';

  @override
  String get warning => '警告';

  @override
  String get info => '情報';

  @override
  String get success => '成功';

  @override
  String get brandAndTheme => 'ブランドとテーマ';

  @override
  String get componentPreview => 'コンポーネントのプレビュー';

  @override
  String get categoryFoundation => '財団';

  @override
  String get categoryInputs => '入力';

  @override
  String get categoryNavigation => 'ナビゲーション';

  @override
  String get categoryData => 'データ';

  @override
  String get categoryFeedback => 'フィードバック';

  @override
  String get categoryEffects => '効果';

  @override
  String get categoryCompositions => '組成物';

  @override
  String get componentsInAction => '動作中のコンポーネント';

  @override
  String get sliders => 'スライダー';

  @override
  String get intensity => '強度';

  @override
  String get range => '範囲';

  @override
  String get backgroundLightning => '背景の稲妻';

  @override
  String get lightAndSpace => '光と空間';

  @override
  String get svg3D => '3D SVG';

  @override
  String get rotateLogo => 'ロゴを回転するには、ドラッグするか矢印キーを使用します。';

  @override
  String get changeLanguage => '言語';
}
