import { siteUrl } from '../site';
export function GET() {
  return new Response(`User-agent: *\nAllow: /\nSitemap: ${new URL('/sitemap.xml', siteUrl).href}\n`, { headers: { 'Content-Type': 'text/plain; charset=utf-8' } });
}
