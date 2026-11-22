import type { LucideIcon, LucideProps } from 'lucide-react';
import { lookupResource, useAllureBrand } from './brand-profile.js';
import { cn } from './utils.js';

export function ThemeIcon({ icon: Icon, alternate: Alternate, iconRole, className, ...props }: LucideProps & {
  icon: LucideIcon; alternate?: LucideIcon; iconRole?: string;
}) {
  const brand = useAllureBrand();
  const role = iconRole ?? Icon.displayName;
  const id = lookupResource(brand?.profile.icons, role);
  if (brand) {
    const preset = brand.profile.typographyPreset ?? 'brand';
    const Glyph = lookupResource(brand.resources?.icons, id) ?? (Alternate && (preset === 'pixel' || preset === 'technical') ? Alternate : Icon);
    return <Glyph {...props} aria-hidden="true" data-icon-preset={preset} className={cn('ui-theme-icon', className)} />;
  }
  return <>
    <Icon {...props} aria-hidden="true" className={cn('ui-theme-icon', Alternate && 'ui-theme-icon-regular', className)} />
    {Alternate && <Alternate {...props} aria-hidden="true" className={cn('ui-theme-icon ui-theme-icon-alternate', className)} />}
  </>;
}
