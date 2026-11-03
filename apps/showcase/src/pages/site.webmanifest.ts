export function GET() {
  return Response.json({ name: 'Want Allure', short_name: 'Allure', start_url: '/', scope: '/', display: 'browser', background_color: '#141414', theme_color: '#5962F0', icons: [
    { src: '/favicon/dark/favicon-192.png', sizes: '192x192', type: 'image/png' },
    { src: '/favicon/dark/favicon-512.png', sizes: '512x512', type: 'image/png' },
    { src: '/favicon/dark/maskable-512.png', sizes: '512x512', type: 'image/png', purpose: 'maskable' },
  ] }, { headers: { 'Content-Type': 'application/manifest+json' } });
}
