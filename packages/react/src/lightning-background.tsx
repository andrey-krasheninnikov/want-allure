import React, { useEffect, useRef, useState, type ComponentProps, type CSSProperties } from 'react';
import { cn } from './utils.js';

export type LightningBackgroundProps = Omit<ComponentProps<'div'>, 'children' | 'color'> & {
  paused?: boolean;
  colors?: readonly [string, string];
};

/** A decorative, viewport-aware background with two slow electrical discharges. */
export function LightningBackground({ paused = false, colors, className, style, ...props }: LightningBackgroundProps) {
  const host = useRef<HTMLDivElement>(null);
  const [active, setActive] = useState(false);
  useEffect(() => {
    const element = host.current!;
    let visible = false;
    const sync = () => setActive(visible && !document.hidden);
    const observer = new IntersectionObserver(entries => { visible = entries[0].isIntersecting; sync(); });
    observer.observe(element);
    document.addEventListener('visibilitychange', sync);
    return () => { observer.disconnect(); document.removeEventListener('visibilitychange', sync); };
  }, []);
  return <div {...props} ref={host} aria-hidden="true" data-slot="lightning-background" data-paused={paused || !active}
    className={cn('ui-lightning-background', className)} style={{ '--lightning-primary': colors?.[0], '--lightning-warning': colors?.[1], ...style } as CSSProperties}>
    <svg viewBox="0 0 1000 700" preserveAspectRatio="none" focusable="false">
      <g className="lightning-bolt lightning-primary" fill="none" strokeLinejoin="round" strokeLinecap="round">
        <path pathLength="100" d="M90 -10 155 100 130 168 224 220 191 286 310 368 280 425 400 510 370 572 490 710 M224 220 302 194 353 238 M310 368 233 398 219 454" />
      </g>
      <g className="lightning-bolt lightning-warning" fill="none" strokeLinejoin="round" strokeLinecap="round">
        <path pathLength="100" d="M920 -10 850 104 881 170 784 236 818 294 704 376 741 439 628 516 654 579 540 710 M784 236 708 212 668 248 M704 376 781 408 793 458" />
      </g>
    </svg>
  </div>;
}
