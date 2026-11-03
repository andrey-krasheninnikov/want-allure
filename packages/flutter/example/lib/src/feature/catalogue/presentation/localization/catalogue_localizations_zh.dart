// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'catalogue_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class CatalogueLocalizationsZh extends CatalogueLocalizations {
  CatalogueLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get findInCatalogue => '在目录中查找';

  @override
  String get previousMatch => '上一场比赛';

  @override
  String get nextMatch => '下一场比赛';

  @override
  String get closeFind => '关闭查找';

  @override
  String get noMatches => '没有匹配项';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return '匹配 $count 的 $active';
  }

  @override
  String get dismissMessage => '关闭消息';

  @override
  String get pauseBackground => '暂停背景';

  @override
  String get resumeBackground => '简历背景';

  @override
  String get oneWantEveryPlatform => '1个Want。每个平台。';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      '在网络和 Flutter 上，Want 的颜色、控制和动作相同。探索具有键盘、触摸和指针输入的组件。';

  @override
  String get findCtrlF => '查找 · ⌘/Ctrl F';

  @override
  String get useLightTheme => '使用浅色主题';

  @override
  String get useDarkTheme => '使用深色主题';

  @override
  String get reduceMotion => '减少运动';

  @override
  String get opaqueSurfaces => '不透明表面';

  @override
  String get resumeEffects => '恢复效果';

  @override
  String get pauseEffects => '暂停效果';

  @override
  String get palette => '调色板';

  @override
  String get typography => '版式';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want 为您的内容腾出空间。';
  }

  @override
  String get buttons => '按钮';

  @override
  String variantNamePressed(Object variantName) {
    return '$variantName 按下';
  }

  @override
  String get disabled => '残疾人';

  @override
  String get downloadSelected => '下载选定的';

  @override
  String get downloadExample => '下载示例';

  @override
  String get fieldsInputAndTextarea => '字段、输入和文本区域';

  @override
  String get localExample => '本地示例';

  @override
  String get title => '标题';

  @override
  String get editableLocalValue => '可编辑的本地值。';

  @override
  String get invalidExample => '无效示例';

  @override
  String get enterATitle => '输入标题。';

  @override
  String get disabledExample => '禁用示例';

  @override
  String get contoursOfSilence => '沉默的轮廓';

  @override
  String get description => '描述';

  @override
  String get describeThePreview => '描述预览';

  @override
  String get fieldAndLabel => '字段和标签';

  @override
  String get consumerOwnedHelperText => '消费者拥有的帮助文本。';

  @override
  String get selectRadioCheckboxAndSwitch => '选择、单选、复选框和开关';

  @override
  String get format => '格式';

  @override
  String get desktop => '桌面';

  @override
  String get mobile => '手机';

  @override
  String get unavailable => '不可用';

  @override
  String get wallpaperOrientation => '壁纸方向';

  @override
  String get includePreview => '包括预览';

  @override
  String get aControlledCheckbox => '受控复选框。';

  @override
  String get mixedSelection => '混合选择';

  @override
  String get enableExampleSetting => '启用示例设置';

  @override
  String get disabledCheckbox => '禁用复选框';

  @override
  String get tabsAndAccordion => '标签和手风琴';

  @override
  String get landscapePreview => '风景预览。';

  @override
  String get portraitPreview => '肖像预览。';

  @override
  String get howAreComponentsShared => '组件如何共享？';

  @override
  String get bothAdaptersUseTheSameFoundationTokens => '两个适配器都使用相同的基础令牌。';

  @override
  String get whoOwnsApplicationData => '谁拥有应用程序数据？';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence => '消费应用程序拥有数据和持久性。';

  @override
  String get dialogSheetMenuTooltipAndPopover => '对话框、工作表、菜单、工具提示和弹出窗口';

  @override
  String get previewSettings => '预览设置';

  @override
  String get done => '完成';

  @override
  String get previewName => '预览名称';

  @override
  String get openDialog => '打开对话框';

  @override
  String panelSideName(Object sideName) {
    return '面板$sideName';
  }

  @override
  String get closePanel => '关闭面板';

  @override
  String get theSheetEntersFromItsSelectedSide => '纸张从其选定的一侧进入。';

  @override
  String sideNameSheet(Object sideName) {
    return '$sideName板材';
  }

  @override
  String get actions => '行动';

  @override
  String get copyLink => '复制链接';

  @override
  String get copyActionSelected => '复制已选择的操作';

  @override
  String get aKeyboardAndPointerHint => '键盘和指针提示';

  @override
  String get hintSelected => '已选择提示';

  @override
  String get tooltip => '工具提示';

  @override
  String get settings => '设置';

  @override
  String get note => '注意事项';

  @override
  String get closeSettings => '关闭设置';

  @override
  String get navigationAndBreadcrumbs => '导航和面包屑';

  @override
  String get exampleNavigation => '导航示例';

  @override
  String get collections => '收藏';

  @override
  String get collectionsSelected => '精选系列';

  @override
  String get search => '搜索';

  @override
  String get searchSelected => '搜索已选择';

  @override
  String get breadcrumbs => '面包屑';

  @override
  String get home => '首页';

  @override
  String get homeSelected => '已选择首页';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => '徽章、警报和进度';

  @override
  String get primary => '小学';

  @override
  String get previewAvailable => '可用预览';

  @override
  String get chooseAnExampleActionToContinue => '选择一个示例操作以继续。';

  @override
  String get couldNotLoadPreview => '无法加载预览';

  @override
  String get tryAgain => '再试一次。';

  @override
  String get exampleProgress => '进展示例';

  @override
  String get loadingPreview => '加载预览';

  @override
  String get toastAndSemanticSnackbars => 'Toast 和语义小吃栏';

  @override
  String get localPreviewReady => '本地预览就绪';

  @override
  String get showToast => '显示吐司';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName：状态示例';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction => '通过一项有用的操作进行主题感知反馈。';

  @override
  String get dismissStatus => '解除状态';

  @override
  String get viewDetails => '查看详情';

  @override
  String get detailsSelected => '详细信息已选择';

  @override
  String get searchableCombobox => '可搜索组合框';

  @override
  String get collection => '收藏';

  @override
  String get searchCollections => '搜索收藏';

  @override
  String get violetHorizon => '紫地平线';

  @override
  String get wovenSpectrum => '编织光谱';

  @override
  String get tableAndPagination => '表格和分页';

  @override
  String get localCollection => '本地收藏';

  @override
  String get noRecords => '没有记录';

  @override
  String get name => '名称';

  @override
  String previewValue(Object value) {
    return '预览 $value';
  }

  @override
  String get pages => '页数';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get rowsPerPage => '每页行数';

  @override
  String pagePage(Object page) {
    return '第$page页';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$total的$from–$to';
  }

  @override
  String get fileSelection => '文件选择';

  @override
  String get images => '图片';

  @override
  String get chooseImages => '选择图像';

  @override
  String get dropImagesHereOrChooseAFile => '将图像拖放到此处或选择一个文件。';

  @override
  String get couldNotReadTheSelectedFile => '无法读取所选文件。';

  @override
  String removeName(Object name) {
    return '删除$name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name 不是受支持的图像。';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name 超过 $limit 字节。';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return '最多选择 $count 文件。';
  }

  @override
  String get dateURLAndPageLayout => '日期、URL 和页面布局';

  @override
  String get createAPreview => '创建预览';

  @override
  String get localComposition => '局部成分';

  @override
  String get previewActionSelected => '预览选定的操作';

  @override
  String get preview => '预览';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get useToday => '今天使用';

  @override
  String get sourceURL => '来源网址';

  @override
  String get openSource => '开源';

  @override
  String openUriHost(Object uriHost) {
    return '打开$uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => '卡片、介质和液体玻璃';

  @override
  String get localDemonstrationArtwork => '当地示范艺术作品';

  @override
  String get violetGradient => '紫色渐变';

  @override
  String get previewSelected => '预览已选择';

  @override
  String get downloadPanel => '下载面板';

  @override
  String get aComposedCard => '一张组合卡';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      '公共槽将内容保存在消费应用程序中。';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced => '液态玻璃 · 透明度降低时不透明。';

  @override
  String get contactCard => '联系卡';

  @override
  String get productDesign => '产品设计';

  @override
  String get website => '网站';

  @override
  String get websiteSelected => '已选择网站';

  @override
  String get commentCarousel => '评论轮播';

  @override
  String get comments => '评论';

  @override
  String get noComments => '没有评论';

  @override
  String get previousComments => '之前的评论';

  @override
  String get nextComments => '下一条评论';

  @override
  String get readMore => '了解更多';

  @override
  String get collapse => '崩溃';

  @override
  String reviewerIndex(Object index) {
    return '审稿人$index';
  }

  @override
  String get today => '今天';

  @override
  String get readableCopyFollowsTheSameWantTypography => '可读副本遵循相同的 Want 排版。';

  @override
  String get thePreviewIsReadyToExplore => '预览已准备好探索。';

  @override
  String get reply => '回复';

  @override
  String actionSelected(Object action) {
    return '$action 已选择';
  }

  @override
  String get customLoaders => '定制装载机';

  @override
  String loadingVariantName(Object variantName) {
    return '正在加载$variantName';
  }

  @override
  String get shimmerPlaceholders => '闪光占位符';

  @override
  String get animatedText => '动画文字';

  @override
  String get yourNextIdea => '你的下一个想法。';

  @override
  String get madeWithWant => '用 Want 制作。';

  @override
  String get readyToExplore => '准备探索。';

  @override
  String get changeText => '更改文字';

  @override
  String get reusableGlowAndConfetti => '可重复使用的发光和五彩纸屑';

  @override
  String get aVisibleHaloWithTwoExpandingWaves => '带有两个不断扩展的波浪的可见光环。';

  @override
  String get exploreWant => '探索Want';

  @override
  String get triggerBackgroundWave => '触发背景波';

  @override
  String get switchToRussian => '切换到俄语';

  @override
  String get switchToEnglish => '切换到英语';

  @override
  String get error => '错误';

  @override
  String get warning => '警告';

  @override
  String get info => '信息';

  @override
  String get success => '成功';

  @override
  String get brandAndTheme => '品牌及主题';

  @override
  String get componentPreview => '组件预览';

  @override
  String get categoryFoundation => '基金会';

  @override
  String get categoryInputs => '输入';

  @override
  String get categoryNavigation => '导航';

  @override
  String get categoryData => '数据';

  @override
  String get categoryFeedback => '反馈意见';

  @override
  String get categoryEffects => '效果';

  @override
  String get categoryCompositions => '作文';

  @override
  String get componentsInAction => '运行中的组件';

  @override
  String get sliders => '滑块';

  @override
  String get intensity => '强度';

  @override
  String get range => '范围';

  @override
  String get backgroundLightning => '背景闪电';

  @override
  String get lightAndSpace => '光与空间';

  @override
  String get svg3D => '3D SVG';

  @override
  String get rotateLogo => '拖动或使用箭头键旋转徽标。';

  @override
  String get changeLanguage => '语言';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class CatalogueLocalizationsZhHans extends CatalogueLocalizationsZh {
  CatalogueLocalizationsZhHans() : super('zh_Hans');

  @override
  String get findInCatalogue => '在目录中查找';

  @override
  String get previousMatch => '上一场比赛';

  @override
  String get nextMatch => '下一场比赛';

  @override
  String get closeFind => '关闭查找';

  @override
  String get noMatches => '没有匹配项';

  @override
  String matchActiveOfCount(Object active, Object count) {
    return '匹配 $count 的 $active';
  }

  @override
  String get dismissMessage => '关闭消息';

  @override
  String get pauseBackground => '暂停背景';

  @override
  String get resumeBackground => '简历背景';

  @override
  String get oneWantEveryPlatform => '1个Want。每个平台。';

  @override
  String get theSameWantColorsControlsAndMotionAcrossWeb =>
      '在网络和 Flutter 上，Want 的颜色、控制和动作相同。探索具有键盘、触摸和指针输入的组件。';

  @override
  String get findCtrlF => '查找 · ⌘/Ctrl F';

  @override
  String get useLightTheme => '使用浅色主题';

  @override
  String get useDarkTheme => '使用深色主题';

  @override
  String get reduceMotion => '减少运动';

  @override
  String get opaqueSurfaces => '不透明表面';

  @override
  String get resumeEffects => '恢复效果';

  @override
  String get pauseEffects => '暂停效果';

  @override
  String get palette => '调色板';

  @override
  String get typography => '版式';

  @override
  String variantNameWantMakesRoomForYourContent(Object variantName) {
    return '$variantName · Want 为您的内容腾出空间。';
  }

  @override
  String get buttons => '按钮';

  @override
  String variantNamePressed(Object variantName) {
    return '$variantName 按下';
  }

  @override
  String get disabled => '残疾人';

  @override
  String get downloadSelected => '下载选定的';

  @override
  String get downloadExample => '下载示例';

  @override
  String get fieldsInputAndTextarea => '字段、输入和文本区域';

  @override
  String get localExample => '本地示例';

  @override
  String get title => '标题';

  @override
  String get editableLocalValue => '可编辑的本地值。';

  @override
  String get invalidExample => '无效示例';

  @override
  String get enterATitle => '输入标题。';

  @override
  String get disabledExample => '禁用示例';

  @override
  String get contoursOfSilence => '沉默的轮廓';

  @override
  String get description => '描述';

  @override
  String get describeThePreview => '描述预览';

  @override
  String get fieldAndLabel => '字段和标签';

  @override
  String get consumerOwnedHelperText => '消费者拥有的帮助文本。';

  @override
  String get selectRadioCheckboxAndSwitch => '选择、单选、复选框和开关';

  @override
  String get format => '格式';

  @override
  String get desktop => '桌面';

  @override
  String get mobile => '手机';

  @override
  String get unavailable => '不可用';

  @override
  String get wallpaperOrientation => '壁纸方向';

  @override
  String get includePreview => '包括预览';

  @override
  String get aControlledCheckbox => '受控复选框。';

  @override
  String get mixedSelection => '混合选择';

  @override
  String get enableExampleSetting => '启用示例设置';

  @override
  String get disabledCheckbox => '禁用复选框';

  @override
  String get tabsAndAccordion => '标签和手风琴';

  @override
  String get landscapePreview => '风景预览。';

  @override
  String get portraitPreview => '肖像预览。';

  @override
  String get howAreComponentsShared => '组件如何共享？';

  @override
  String get bothAdaptersUseTheSameFoundationTokens => '两个适配器都使用相同的基础令牌。';

  @override
  String get whoOwnsApplicationData => '谁拥有应用程序数据？';

  @override
  String get theConsumingApplicationOwnsDataAndPersistence => '消费应用程序拥有数据和持久性。';

  @override
  String get dialogSheetMenuTooltipAndPopover => '对话框、工作表、菜单、工具提示和弹出窗口';

  @override
  String get previewSettings => '预览设置';

  @override
  String get done => '完成';

  @override
  String get previewName => '预览名称';

  @override
  String get openDialog => '打开对话框';

  @override
  String panelSideName(Object sideName) {
    return '面板$sideName';
  }

  @override
  String get closePanel => '关闭面板';

  @override
  String get theSheetEntersFromItsSelectedSide => '纸张从其选定的一侧进入。';

  @override
  String sideNameSheet(Object sideName) {
    return '$sideName板材';
  }

  @override
  String get actions => '行动';

  @override
  String get copyLink => '复制链接';

  @override
  String get copyActionSelected => '复制已选择的操作';

  @override
  String get aKeyboardAndPointerHint => '键盘和指针提示';

  @override
  String get hintSelected => '已选择提示';

  @override
  String get tooltip => '工具提示';

  @override
  String get settings => '设置';

  @override
  String get note => '注意事项';

  @override
  String get closeSettings => '关闭设置';

  @override
  String get navigationAndBreadcrumbs => '导航和面包屑';

  @override
  String get exampleNavigation => '导航示例';

  @override
  String get collections => '收藏';

  @override
  String get collectionsSelected => '精选系列';

  @override
  String get search => '搜索';

  @override
  String get searchSelected => '搜索已选择';

  @override
  String get breadcrumbs => '面包屑';

  @override
  String get home => '首页';

  @override
  String get homeSelected => '已选择首页';

  @override
  String get uiKit => 'UI kit';

  @override
  String get badgesAlertsAndProgress => '徽章、警报和进度';

  @override
  String get primary => '小学';

  @override
  String get previewAvailable => '可用预览';

  @override
  String get chooseAnExampleActionToContinue => '选择一个示例操作以继续。';

  @override
  String get couldNotLoadPreview => '无法加载预览';

  @override
  String get tryAgain => '再试一次。';

  @override
  String get exampleProgress => '进展示例';

  @override
  String get loadingPreview => '加载预览';

  @override
  String get toastAndSemanticSnackbars => 'Toast 和语义小吃栏';

  @override
  String get localPreviewReady => '本地预览就绪';

  @override
  String get showToast => '显示吐司';

  @override
  String variantNameExampleStatus(Object variantName) {
    return '$variantName：状态示例';
  }

  @override
  String get themeAwareFeedbackWithOneUsefulAction => '通过一项有用的操作进行主题感知反馈。';

  @override
  String get dismissStatus => '解除状态';

  @override
  String get viewDetails => '查看详情';

  @override
  String get detailsSelected => '详细信息已选择';

  @override
  String get searchableCombobox => '可搜索组合框';

  @override
  String get collection => '收藏';

  @override
  String get searchCollections => '搜索收藏';

  @override
  String get violetHorizon => '紫地平线';

  @override
  String get wovenSpectrum => '编织光谱';

  @override
  String get tableAndPagination => '表格和分页';

  @override
  String get localCollection => '本地收藏';

  @override
  String get noRecords => '没有记录';

  @override
  String get name => '名称';

  @override
  String previewValue(Object value) {
    return '预览 $value';
  }

  @override
  String get pages => '页数';

  @override
  String get previousPage => '上一页';

  @override
  String get nextPage => '下一页';

  @override
  String get rowsPerPage => '每页行数';

  @override
  String pagePage(Object page) {
    return '第$page页';
  }

  @override
  String fromToOfTotal(Object from, Object to, Object total) {
    return '$total的$from–$to';
  }

  @override
  String get fileSelection => '文件选择';

  @override
  String get images => '图片';

  @override
  String get chooseImages => '选择图像';

  @override
  String get dropImagesHereOrChooseAFile => '将图像拖放到此处或选择一个文件。';

  @override
  String get couldNotReadTheSelectedFile => '无法读取所选文件。';

  @override
  String removeName(Object name) {
    return '删除$name';
  }

  @override
  String nameIsNotASupportedImage(Object name) {
    return '$name 不是受支持的图像。';
  }

  @override
  String nameExceedsLimitBytes(Object name, Object limit) {
    return '$name 超过 $limit 字节。';
  }

  @override
  String chooseUpToCountFiles(Object count) {
    return '最多选择 $count 文件。';
  }

  @override
  String get dateURLAndPageLayout => '日期、URL 和页面布局';

  @override
  String get createAPreview => '创建预览';

  @override
  String get localComposition => '局部成分';

  @override
  String get previewActionSelected => '预览选定的操作';

  @override
  String get preview => '预览';

  @override
  String get date => '日期';

  @override
  String get time => '时间';

  @override
  String get useToday => '今天使用';

  @override
  String get sourceURL => '来源网址';

  @override
  String get openSource => '开源';

  @override
  String openUriHost(Object uriHost) {
    return '打开$uriHost';
  }

  @override
  String get cardsMediaAndLiquidGlass => '卡片、介质和液体玻璃';

  @override
  String get localDemonstrationArtwork => '当地示范艺术作品';

  @override
  String get violetGradient => '紫色渐变';

  @override
  String get previewSelected => '预览已选择';

  @override
  String get downloadPanel => '下载面板';

  @override
  String get aComposedCard => '一张组合卡';

  @override
  String get publicSlotsKeepContentInTheConsumingApplication =>
      '公共槽将内容保存在消费应用程序中。';

  @override
  String get liquidGlassOpaqueWhenTransparencyIsReduced => '液态玻璃 · 透明度降低时不透明。';

  @override
  String get contactCard => '联系卡';

  @override
  String get productDesign => '产品设计';

  @override
  String get website => '网站';

  @override
  String get websiteSelected => '已选择网站';

  @override
  String get commentCarousel => '评论轮播';

  @override
  String get comments => '评论';

  @override
  String get noComments => '没有评论';

  @override
  String get previousComments => '之前的评论';

  @override
  String get nextComments => '下一条评论';

  @override
  String get readMore => '了解更多';

  @override
  String get collapse => '崩溃';

  @override
  String reviewerIndex(Object index) {
    return '审稿人$index';
  }

  @override
  String get today => '今天';

  @override
  String get readableCopyFollowsTheSameWantTypography => '可读副本遵循相同的 Want 排版。';

  @override
  String get thePreviewIsReadyToExplore => '预览已准备好探索。';

  @override
  String get reply => '回复';

  @override
  String actionSelected(Object action) {
    return '$action 已选择';
  }

  @override
  String get customLoaders => '定制装载机';

  @override
  String loadingVariantName(Object variantName) {
    return '正在加载$variantName';
  }

  @override
  String get shimmerPlaceholders => '闪光占位符';

  @override
  String get animatedText => '动画文字';

  @override
  String get yourNextIdea => '你的下一个想法。';

  @override
  String get madeWithWant => '用 Want 制作。';

  @override
  String get readyToExplore => '准备探索。';

  @override
  String get changeText => '更改文字';

  @override
  String get reusableGlowAndConfetti => '可重复使用的发光和五彩纸屑';

  @override
  String get aVisibleHaloWithTwoExpandingWaves => '带有两个不断扩展的波浪的可见光环。';

  @override
  String get exploreWant => '探索Want';

  @override
  String get triggerBackgroundWave => '触发背景波';

  @override
  String get switchToRussian => '切换到俄语';

  @override
  String get switchToEnglish => '切换到英语';

  @override
  String get error => '错误';

  @override
  String get warning => '警告';

  @override
  String get info => '信息';

  @override
  String get success => '成功';

  @override
  String get brandAndTheme => '品牌及主题';

  @override
  String get componentPreview => '组件预览';

  @override
  String get categoryFoundation => '基金会';

  @override
  String get categoryInputs => '输入';

  @override
  String get categoryNavigation => '导航';

  @override
  String get categoryData => '数据';

  @override
  String get categoryFeedback => '反馈意见';

  @override
  String get categoryEffects => '效果';

  @override
  String get categoryCompositions => '作文';

  @override
  String get componentsInAction => '运行中的组件';

  @override
  String get sliders => '滑块';

  @override
  String get intensity => '强度';

  @override
  String get range => '范围';

  @override
  String get backgroundLightning => '背景闪电';

  @override
  String get lightAndSpace => '光与空间';

  @override
  String get svg3D => '3D SVG';

  @override
  String get rotateLogo => '拖动或使用箭头键旋转徽标。';

  @override
  String get changeLanguage => '语言';
}
