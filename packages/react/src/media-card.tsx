import { useState, type ComponentProps, type ReactNode } from 'react';
import { Card, CardContent } from './ui/card.js';
import { cn } from './utils.js';

export type MediaCardProps = Omit<ComponentProps<'a'>, 'title' | 'children'> & {
  title: string; caption?: string; index?: number; headingLevel?: 2 | 3;
  image: { src: string; width: number; height: number; alt: string; srcSet?: string; sizes?: string };
  fallback?: ReactNode;
};
export function MediaCard({ title, caption, index, image, fallback, headingLevel = 3, className, ...props }: MediaCardProps) {
  const [failed, setFailed] = useState<string>();
  const source = JSON.stringify([image.src, image.srcSet, image.sizes]);
  const Heading = headingLevel === 2 ? 'h2' : 'h3';
  return <article className="min-w-0"><Card className="gallery-card">
    <a className={cn('media-card-link', className)} {...props}>
      <div className="media-frame" style={image.width > 0 && image.height > 0 ? { aspectRatio:image.width + ' / ' + image.height } : undefined}>{source !== failed
        ? <img {...image} loading="lazy" decoding="async" className="gallery-image" onError={() => setFailed(source)} />
        : <span className="ui-media-placeholder" role={image.alt ? 'img' : undefined} aria-label={image.alt || undefined}>{fallback ?? image.alt}</span>}</div>
      <CardContent className="media-card-caption">
        <div className="min-w-0"><Heading className="media-card-title">{title}</Heading>{caption && <p className="media-card-description">{caption}</p>}</div>
        {index !== undefined && <span aria-hidden="true" className="media-card-index">{String(index).padStart(2, '0')}</span>}
      </CardContent>
    </a>
  </Card></article>;
}
