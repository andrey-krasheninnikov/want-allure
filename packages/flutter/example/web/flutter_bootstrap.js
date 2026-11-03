{{flutter_js}}
{{flutter_build_config}}
const query = new URLSearchParams(location.search);
document.documentElement.lang = query.get('locale') === 'ru' ? 'ru' : 'en';
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
  document.body.textContent = query.get('locale') === 'ru' ? 'Не удалось запустить каталог. Перезагрузите страницу.' : 'Could not start the catalogue. Reload this page.';
  document.body.style.color = query.get('theme') === 'light' ? '#242321' : '#E8E8E8';
}
