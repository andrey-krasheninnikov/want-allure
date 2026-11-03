import { siteUrl, locales, route } from '../site';
export function GET() {
  const urls = locales.map(locale=>route(locale)).map(path => `<url><loc>${new URL(path, siteUrl).href}</loc></url>`).join('');
  return new Response(`<?xml version="1.0" encoding="UTF-8"?><urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">${urls}</urlset>`, { headers: { 'Content-Type': 'application/xml; charset=utf-8' } });
}
