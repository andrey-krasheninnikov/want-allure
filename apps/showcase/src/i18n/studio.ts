import { siteText, type Locale } from '../site';

// The editor names raw token keys and resource IDs exactly as they appear in the profile.
const languages: Locale[] = ['en','ru','zh-Hans','hi','es','ar','fr','pt-BR','de','ja','tr','he'];
const rows = {
  brand: ['Brand color','Цвет бренда','品牌色','ब्रांड का रंग','Color de marca','لون العلامة','Couleur de marque','Cor da marca','Markenfarbe','ブランドカラー','Marka rengi','צבע המותג'],
  profile: ['Brand profile','Профиль бренда','品牌配置','ब्रांड प्रोफ़ाइल','Perfil de marca','ملف العلامة','Profil de marque','Perfil da marca','Markenprofil','ブランドプロファイル','Marka profili','פרופיל מותג'],
  geometry: ['Shape and spacing','Форма и отступы','形状与间距','आकार और अंतराल','Forma y espaciado','الشكل والتباعد','Forme et espacement','Forma e espaçamento','Form und Abstand','形と余白','Şekil ve aralık','צורה וריווח'],
  resources: ['Fonts, icons and logos','Шрифты, иконки и логотипы','字体、图标与标志','फ़ॉन्ट, आइकन और लोगो','Fuentes, iconos y logotipos','الخطوط والأيقونات والشعارات','Polices, icônes et logos','Fontes, ícones e logotipos','Schriften, Symbole und Logos','フォント・アイコン・ロゴ','Yazı tipleri, simgeler ve logolar','גופנים, סמלים וסמלילים'],
  roles: ['Semantic colors','Семантические цвета','语义色','अर्थसूचक रंग','Colores semánticos','الألوان الدلالية','Couleurs sémantiques','Cores semânticas','Semantische Farben','セマンティックカラー','Anlamsal renkler','צבעים סמנטיים'],
  modes: ['Motion','Движение','动效','गति','Movimiento','الحركة','Mouvement','Movimento','Bewegung','モーション','Hareket','תנועה'],
  compare: ['Compare themes','Сравнить темы','比较主题','थीम की तुलना','Comparar temas','مقارنة المظاهر','Comparer les thèmes','Comparar temas','Themen vergleichen','テーマを比較','Temaları karşılaştır','השוואת ערכות נושא'],
  apply: ['Apply JSON','Применить JSON','应用 JSON','JSON लागू करें','Aplicar JSON','تطبيق JSON','Appliquer le JSON','Aplicar JSON','JSON anwenden','JSONを適用','JSON uygula','החלת JSON'],
  download: ['Download JSON','Скачать JSON','下载 JSON','JSON डाउनलोड करें','Descargar JSON','تنزيل JSON','Télécharger le JSON','Baixar JSON','JSON herunterladen','JSONをダウンロード','JSON indir','הורדת JSON'],
  load: ['Import JSON file','Импортировать файл JSON','导入 JSON 文件','JSON फ़ाइल आयात करें','Importar archivo JSON','استيراد ملف JSON','Importer un fichier JSON','Importar arquivo JSON','JSON-Datei importieren','JSONファイルを読み込む','JSON dosyasını içe aktar','ייבוא קובץ JSON'],
  fileLimit: ['Choose a file under 10 MB.','Выберите файл меньше 10 МБ.','请选择小于 10 MB 的文件。','10 MB से छोटी फ़ाइल चुनें।','Elige un archivo de menos de 10 MB.','اختر ملفاً أصغر من 10 م.ب.','Choisissez un fichier de moins de 10 Mo.','Escolha um arquivo com menos de 10 MB.','Datei unter 10 MB wählen.','10 MB未満のファイルを選択してください。','10 MB altında bir dosya seçin.','יש לבחור קובץ קטן מ־10 MB.'],
  resourceTip: ['Register these IDs in your app. Local files stay in this preview.','Зарегистрируйте эти ID в приложении. Локальные файлы остаются в этом превью.','请在应用中注册这些 ID。本地文件仅用于此预览。','अपनी ऐप में ये ID पंजीकृत करें। स्थानीय फ़ाइलें केवल इस पूर्वावलोकन में रहती हैं।','Registra estos ID en tu aplicación. Los archivos locales solo se usan en esta vista previa.','سجّل هذه المعرّفات في تطبيقك. تبقى الملفات المحلية في المعاينة.','Enregistrez ces identifiants dans votre application. Les fichiers locaux restent dans cet aperçu.','Registre estes IDs no aplicativo. Os arquivos locais ficam nesta prévia.','Diese IDs in der App registrieren. Lokale Dateien bleiben in dieser Vorschau.','アプリにこれらのIDを登録します。ローカルファイルはこのプレビューでのみ使用します。','Bu kimlikleri uygulamanıza kaydedin. Yerel dosyalar bu önizlemede kalır.','רשמו את המזהים ביישום. הקבצים המקומיים נשארים בתצוגה המקדימה.'],
  search: ['Find a component','Найти компонент','查找组件','कंपोनेंट खोजें','Buscar componente','البحث عن مكوّن','Rechercher un composant','Buscar componente','Komponente suchen','コンポーネントを検索','Bileşen ara','חיפוש רכיב'],
  clear: ['Clear','Очистить','清除','साफ़ करें','Borrar','مسح','Effacer','Limpar','Löschen','クリア','Temizle','ניקוי'],
  blank: ['Empty','Пусто','空','खाली','Vacío','فارغ','Vide','Vazio','Leer','空','Boş','ריק'],
  loading: ['Loading','Загрузка','加载中','लोड हो रहा है','Cargando','جارٍ التحميل','Chargement','Carregando','Wird geladen','読み込み中','Yükleniyor','בטעינה'],
  empty: ['No matches','Ничего не найдено','无匹配项','कोई परिणाम नहीं','Sin resultados','لا توجد نتائج','Aucun résultat','Sem resultados','Keine Treffer','該当なし','Sonuç yok','אין תוצאות'],
  upload: ['Use local file','Выбрать локальный файл','使用本地文件','स्थानीय फ़ाइल चुनें','Usar archivo local','استخدام ملف محلي','Choisir un fichier local','Usar arquivo local','Lokale Datei verwenden','ローカルファイルを選択','Yerel dosya seç','בחירת קובץ מקומי'],
  registry: ['Resource IDs','Идентификаторы ресурсов','资源 ID','संसाधन ID','ID de recursos','معرّفات الموارد','Identifiants de ressources','IDs de recursos','Ressourcen-IDs','リソースID','Kaynak kimlikleri','מזהי משאבים'],
  code: ['Integration','Подключение','接入代码','एकीकरण','Integración','التكامل','Intégration','Integração','Integration','組み込み','Entegrasyon','שילוב'],
} as const;
export function studioText(locale: Locale, key: keyof typeof rows) { return rows[key][languages.indexOf(locale)]; }
export const themeName = (locale: Locale, mode: 'light'|'dark') => siteText(locale,mode === 'light' ? 'Light theme' : 'Dark theme');
