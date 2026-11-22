import { useState, type ComponentProps, type ComponentType, type SVGProps } from 'react';
import { ArrowUpRight } from 'lucide-react';
import { cn } from './utils.js';

export type ContactAction = { title: string; detail?: string; href: string; label?: string; external?: boolean; icon?: ComponentType<SVGProps<SVGSVGElement>> };
export type ContactCardProps = ComponentProps<'div'> & { name: string; avatarSrc?: string; subtitle?: string; actions: ContactAction[] };
export function ContactCard({ name, avatarSrc, subtitle, actions, className, ...props }: ContactCardProps) {
  const [failed, setFailed] = useState<string>();
  const words = name.trim().split(/\s+/u).filter(Boolean);
  const graphemes = (word: string) => typeof Intl.Segmenter === 'function'
    ? Array.from(new Intl.Segmenter(undefined, { granularity: 'grapheme' }).segment(word), part => part.segment)
    : Array.from(word);
  const initials = words.length > 1 ? [words[0]!, words[words.length - 1]!].map(word => graphemes(word)[0]).join('')
    : graphemes(words[0] ?? '').slice(0, 2).join('');
  return <div className={cn('contact-card', className)} {...props}>
    <div className="contact-identity"><span className="contact-avatar" aria-hidden="true">{avatarSrc && avatarSrc !== failed ? <img src={avatarSrc} alt="" onError={() => setFailed(avatarSrc)} /> : initials}</span><div><strong dir="auto">{name}</strong>{subtitle && <small dir="auto">{subtitle}</small>}</div></div>
    <div className="contact-actions">{actions.map(({ title, detail, href, label, external, icon: Icon = ArrowUpRight }) => {
      const newTab = external ?? /^https?:/.test(href);
      return <div key={href} className="contact-link"><span>{title}{detail && <small title={detail} dir="auto">{detail}</small>}</span><a className="contact-icon-action" href={href} target={newTab ? '_blank' : undefined} rel={newTab ? 'noopener noreferrer' : undefined} aria-label={label ?? title} title={label ?? title}><Icon aria-hidden="true" /></a></div>;
    })}</div>
  </div>;
}
