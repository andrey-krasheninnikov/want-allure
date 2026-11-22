import { lookupResource, useAllureBrand } from './brand-profile.js';
import type { ComponentProps } from 'react';
import { cn } from './utils.js';

export type BrandLogoProps = ComponentProps<'img'> & { alt: string; variant?: 'light' | 'dark' | 'mark' };
export function BrandLogo({ className, src, variant, width = 32, height = 32, ...props }: BrandLogoProps) {
  const brand = useAllureBrand();
  const logos = brand?.profile.logos;
  const logoId = logos?.[variant ?? brand?.mode ?? 'mark'];
  const source = src ?? lookupResource(brand?.resources?.logos, logoId) ?? lookupResource(brand?.resources?.logos, logos?.mark);
  if (!source) return <span role={props.alt ? 'img' : undefined} aria-label={props.alt || undefined} aria-hidden={!props.alt || undefined}
    className={cn('brand-logo', className)} style={{ display:'inline-block', width, height }} />;
  return <img src={source} width={width} height={height} className={cn('brand-logo', className)} {...props} />;
}
export type BrandLockupProps = Omit<ComponentProps<'a'>, 'children'> & { name: string; logoSrc?: string; subtitle?: string };
export function BrandLockup({ name, logoSrc, subtitle, className, ...props }: BrandLockupProps) {
  return <a aria-label={name} className={cn('brand-lockup', className)} {...props}>
    <BrandLogo src={logoSrc} alt="" /><span>{name}{subtitle && <small>{subtitle}</small>}</span>
  </a>;
}
