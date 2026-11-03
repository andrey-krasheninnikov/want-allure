{{flutter_js}}
{{flutter_build_config}}
const query = new URLSearchParams(location.search);
const startupErrors = {
  en:'Could not start the catalogue. Reload this page.',
  'zh-Hans':'无法启动组件目录。请重新加载此页面。',
  hi:'कैटलॉग शुरू नहीं हो सका। पेज फिर से लोड करें।',
  es:'No se pudo iniciar el catálogo. Vuelve a cargar la página.',
  ar:'تعذّر تشغيل الكتالوج. أعد تحميل الصفحة.',
  fr:'Le catalogue n’a pas pu démarrer. Rechargez cette page.',
  'pt-BR':'Não foi possível iniciar o catálogo. Recarregue a página.',
  ru:'Не удалось запустить каталог. Перезагрузите страницу.',
  de:'Der Katalog konnte nicht gestartet werden. Laden Sie diese Seite neu.',
  ja:'カタログを起動できませんでした。ページを再読み込みしてください。',
  tr:'Katalog başlatılamadı. Sayfayı yeniden yükleyin.',
  he:'לא ניתן להפעיל את הקטלוג. יש לטעון את העמוד מחדש.'
};
const locale=Object.hasOwn(startupErrors,query.get('locale'))?query.get('locale'):'en';
document.documentElement.lang=locale;
document.documentElement.dir=['ltr','rtl'].includes(query.get('direction'))?query.get('direction'):(['ar','he'].includes(locale)?'rtl':'ltr');
document.body.style.margin = '0';
document.body.style.background = query.get('theme') === 'light' ? '#F6F5F3' : '#141414';
_flutter.loader.load({
  config: { canvasKitBaseUrl: 'canvaskit/' },
  onEntrypointLoaded: async function(initializer) {
    try { const app = await initializer.initializeEngine(); await app.runApp(); }
    catch (error) { fail(); }
  }
}).catch(fail);
function fail() {
  if (query.get('embedded') === '1') parent.postMessage({ type: 'want-allure:error' }, location.origin);
  document.body.textContent = startupErrors[document.documentElement.lang] ?? startupErrors.en;
  document.body.style.color = query.get('theme') === 'light' ? '#242321' : '#E8E8E8';
}
