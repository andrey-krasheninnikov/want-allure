import { useEffect, useId, useRef, useState, type ReactNode } from 'react';
import { Menu, X } from 'lucide-react';
import { Button } from './ui/button.js';
import { Input } from './ui/input.js';
import { Sheet, SheetContent, SheetDescription, SheetTitle } from './ui/sheet.js';
import { Tooltip, TooltipContent, TooltipProvider, TooltipTrigger } from './ui/tooltip.js';

export function ListRow({ children, leading, trailing, selected = false, onSelect }: {
  children: ReactNode; leading?: ReactNode; trailing?: ReactNode; selected?: boolean; onSelect: () => void;
}) {
  return <Button type="button" variant="ghost" className="ui-list-row" aria-pressed={selected} onClick={onSelect}>
    {leading != null && <span aria-hidden="true">{leading}</span>}<span>{children}</span>
    {trailing != null && <span className="ui-row-trailing">{trailing}</span>}
  </Button>;
}

type SidebarItem = { id: string; label: string; icon: ReactNode; count?: number };
export function Sidebar({ label, toggleLabel, closeLabel, items, selected, onSelect, expanded, onExpandedChange, children, dir }: {
  label: string; toggleLabel: string; closeLabel: string; items: readonly SidebarItem[]; selected: string;
  onSelect: (id: string) => void; expanded: boolean; onExpandedChange: (expanded: boolean) => void;
  children: ReactNode; dir?: 'ltr' | 'rtl';
}) {
  const root = useRef<HTMLDivElement>(null), toggle = useRef<HTMLButtonElement>(null);
  const id = useId();
  const [dock, setDock] = useState(false);
  const [direction, setDirection] = useState(dir ?? 'ltr');
  useEffect(() => {
    const host = root.current!;
    const update = () => {
      setDock(host.clientWidth >= 1000 && parseFloat(getComputedStyle(document.documentElement).fontSize) <= 24);
      setDirection(getComputedStyle(host).direction === 'rtl' ? 'rtl' : 'ltr');
    };
    const observer = new ResizeObserver(update);
    observer.observe(host); observer.observe(document.documentElement); update();
    const documentRoot = document.documentElement;
    let inlineSize = documentRoot.style.fontSize;
    const directionObserver = new MutationObserver(records => {
      if (records.some(record => record.attributeName === 'dir') || inlineSize !== documentRoot.style.fontSize) {
        inlineSize = documentRoot.style.fontSize; update();
      }
    });
    directionObserver.observe(documentRoot, { attributes:true, attributeFilter:['dir','style'] });
    return () => { observer.disconnect(); directionObserver.disconnect(); };
  }, [dir]);
  const overlay = expanded && !dock;
  const rows = (wide: boolean) => <nav aria-label={label} className="ui-sidebar-rows">
    {items.map(item => <Tooltip key={item.id}>
      <TooltipTrigger asChild>
        <Button type="button" variant="ghost" className="ui-list-row" aria-label={wide ? undefined : item.label}
          aria-current={selected === item.id ? 'page' : undefined} onClick={() => { onSelect(item.id); if (overlay) onExpandedChange(false); }}>
          <span aria-hidden="true">{item.icon}</span>{wide && <><span>{item.label}</span>{item.count != null && <span className="ui-row-trailing">{item.count}</span>}</>}
        </Button>
      </TooltipTrigger>
      {!wide && <TooltipContent side={direction === 'rtl' ? 'left' : 'right'}>{item.label}</TooltipContent>}
    </Tooltip>)}
  </nav>;
  return <TooltipProvider><div className="ui-sidebar-layout" data-expanded={expanded && dock} dir={dir} ref={root}>
    <aside className="ui-sidebar-rail">
      <Button ref={toggle} type="button" size="icon" variant="ghost" aria-label={toggleLabel}
        aria-expanded={expanded} aria-controls={expanded ? id : undefined} onClick={() => onExpandedChange(!expanded)}>
        <Menu aria-hidden="true" />
      </Button>
      <div id={dock && expanded ? id : undefined}>{rows(dock && expanded)}</div>
    </aside>
    <div className="ui-sidebar-body">{children}</div>
    <Sheet open={overlay} onOpenChange={onExpandedChange}>
      <SheetContent id={overlay ? id : undefined} side={direction === 'rtl' ? 'right' : 'left'} closeLabel={closeLabel}
        className="ui-sidebar-sheet" onCloseAutoFocus={event => { event.preventDefault(); toggle.current?.focus(); }}>
        <SheetTitle>{label}</SheetTitle><SheetDescription className="sr-only">{toggleLabel}</SheetDescription>{rows(true)}
      </SheetContent>
    </Sheet>
  </div></TooltipProvider>;
}

export function resizePair(widths: readonly number[], minima: readonly number[], index: number, delta: number): number[] {
  const start = widths[index], end = widths[index + 1];
  if (start == null || end == null || !Number.isFinite(delta)) return [...widths];
  const shift = Math.min(end - (minima[index + 1] ?? 0), Math.max((minima[index] ?? 0) - start, delta));
  return widths.map((width, i) => i === index ? width + shift : i === index + 1 ? width - shift : width);
}

function panelWidths(fractions: readonly number[], minima: readonly number[], space: number) {
  const weights = minima.map((_, i) => Number.isFinite(fractions[i]) ? Math.max(0, fractions[i]!) : 0);
  const sum = weights.reduce((a, b) => a + b, 0);
  const preferred = weights.map(weight => space * (sum ? weight / sum : 1 / weights.length));
  const deficit = preferred.reduce((total, width, i) => total + Math.max(0, minima[i]! - width), 0);
  const surplus = preferred.reduce((total, width, i) => total + Math.max(0, width - minima[i]!), 0);
  return preferred.map((width, i) => width < minima[i]! ? minima[i]! : width - (surplus ? deficit * (width - minima[i]!) / surplus : 0));
}

export function SplitPane({ panes, fractions, onChange, compact }: {
  panes: readonly { id: string; min: number; content: ReactNode; resizeLabel: string }[];
  fractions: readonly number[]; onChange: (fractions: number[]) => void; compact: ReactNode;
}) {
  const instanceId = useId();
  const host = useRef<HTMLDivElement>(null);
  const [width, setWidth] = useState(0), [dragging, setDragging] = useState<number | null>(null);
  const drag = useRef<{ id: number; start: number; widths: number[] } | null>(null);
  useEffect(() => {
    const element = host.current!;
    const observer = new ResizeObserver(() => setWidth(element.clientWidth));
    observer.observe(element);
    return () => observer.disconnect();
  }, []);
  const space = width - (panes.length - 1) * 12;
  const minima = panes.map(pane => Math.max(0, pane.min));
  const wide = panes.length >= 2 && space > 0 && space >= minima.reduce((a, b) => a + b, 0);
  const widths = wide ? panelWidths(fractions, minima, space) : [];
  const resize = (index: number, delta: number, initial = widths) => {
    const rtl = host.current && getComputedStyle(host.current).direction === 'rtl';
    onChange(resizePair(initial, minima, index, rtl ? -delta : delta).map(value => value / space));
  };
  return <div ref={host} className="ui-split">
    {!wide ? compact : <div className="ui-split-panes">{panes.map((pane, i) =>
      <div key={pane.id} className="ui-split-group" style={{ width: widths[i]! + (i < panes.length - 1 ? 12 : 0) }}>
        <div className="ui-split-pane" id={instanceId + '-' + pane.id}>{pane.content}</div>
        {i < panes.length - 1 && <div role="separator" tabIndex={0} aria-label={pane.resizeLabel} aria-orientation="vertical"
          aria-controls={instanceId + '-' + pane.id} aria-valuenow={Math.round(widths[i]!)} aria-valuemin={pane.min}
          aria-valuemax={Math.floor(widths[i]! + widths[i + 1]! - minima[i + 1]!)}
          className="ui-split-handle" data-dragging={dragging === i}
          onKeyDown={event => {
            if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') return;
            event.preventDefault(); resize(i, event.key === 'ArrowLeft' ? -16 : 16);
          }}
          onPointerDown={event => {
            if (event.button !== 0) return;
            drag.current = { id: event.pointerId, start: event.clientX, widths }; setDragging(i);
            event.currentTarget.focus(); event.currentTarget.setPointerCapture(event.pointerId);
          }}
          onPointerMove={event => { const gesture = drag.current; if (gesture?.id === event.pointerId) resize(i, event.clientX - gesture.start, gesture.widths); }}
          onLostPointerCapture={() => { drag.current = null; setDragging(null); }}><span /></div>}
      </div>)}</div>}
  </div>;
}

export function SearchToolbar({ label, value, onChange, actions, filters = [] }: {
  label: string; value: string; onChange: (value: string) => void; actions?: ReactNode;
  filters?: readonly { id: string; label: string; removeLabel: string; onRemove: () => void }[];
}) {
  return <div className="ui-search-toolbar">
    <div className="ui-search-main">
      <Input type="search" aria-label={label} placeholder={label} value={value} onChange={event => onChange(event.currentTarget.value)} />
      {actions && <div className="ui-search-actions">{actions}</div>}
    </div>
    {filters.length > 0 && <div className="ui-search-filters">{filters.map(filter =>
      <Button key={filter.id} type="button" variant="secondary" aria-label={filter.removeLabel} onClick={filter.onRemove}>
        {filter.label}<X size={16} aria-hidden="true" />
      </Button>)}</div>}
  </div>;
}
