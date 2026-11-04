import tokens from '@want-foundation/allure/tokens.json';
export function GET() {
  return Response.json({ name: 'Want Allure', short_name: 'Allure', start_url: '/', scope: '/', display: 'browser', background_color: tokens.themes.wallpapers.dark.background, theme_color: tokens.themes.wallpapers.dark.primary, icons: [
    { src: '/favicon/dark/favicon-192.png', sizes: '192x192', type: 'image/png' },
    { src: '/favicon/dark/favicon-512.png', sizes: '512x512', type: 'image/png' },
    { src: '/favicon/dark/maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
  ] }, { headers: { 'Content-Type': 'application/manifest+json' } });
}
