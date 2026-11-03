import { defineConfig } from 'astro/config';
import react from '@astrojs/react';
import tailwindcss from '@tailwindcss/vite';
export default defineConfig({ site: process.env.SITE_URL || 'https://allure.want.foundation', trailingSlash: 'always', i18n: { locales: ['en','zh-Hans','hi','es','ar','fr','pt-BR','ru','de','ja','tr','he'], defaultLocale: 'en', routing: { prefixDefaultLocale: false } }, integrations: [react()], vite: { plugins: [tailwindcss()] } });
