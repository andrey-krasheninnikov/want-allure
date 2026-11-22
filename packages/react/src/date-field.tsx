import { usePortalHost } from './brand-profile.js';
import { useRef, useState, type KeyboardEvent } from 'react';
import { ChevronLeft, ChevronRight, ChevronsLeft, ChevronsRight } from 'lucide-react';
import { Popover } from 'radix-ui';
import { Button } from './ui/button.js';

export type DateFieldLabels = {
  date: string;
  datetime: string;
  calendar: string;
  year: string;
  previousYear: string;
  previousMonth: string;
  nextMonth: string;
  nextYear: string;
  hours: string;
  minutes: string;
  today: string;
  clear: string;
  apply: string;
};

export type DateFieldProps = {
  mode: 'date' | 'datetime';
  value: string;
  onChange: (value: string) => void;
  onCommit?: (value: string) => void;
  labels: DateFieldLabels;
  locale: string;
  today?: string;
  min?: string;
  max?: string;
  firstDayOfWeek?: 0 | 1 | 2 | 3 | 4 | 5 | 6;
  ariaLabel?: string;
  disabled?: boolean;
  className?: string;
};

function pad(value: number): string {
  return String(value).padStart(2, '0');
}

function calendarDate(year: number, month: number, day: number, hours = 0, minutes = 0): Date {
  const date = new Date(0);
  date.setUTCFullYear(year, month, day);
  date.setUTCHours(hours, minutes, 0, 0);
  return date;
}

function inRange(date: Date): boolean {
  return date.getUTCFullYear() >= 1 && date.getUTCFullYear() <= 9999;
}

function dayKey(date: Date): string {
  return String(date.getUTCFullYear()).padStart(4, '0') + '-' + pad(date.getUTCMonth() + 1) + '-' + pad(date.getUTCDate());
}

function parseStamp(value: string): Date | null {
  const parts = /^(\d{4})-(\d{2})-(\d{2})(?:T(\d{2}):(\d{2}))?$/.exec(value);
  if (!parts) return null;
  const year = Number(parts[1]);
  const month = Number(parts[2]);
  const day = Number(parts[3]);
  const hours = Number(parts[4] ?? 0);
  const minutes = Number(parts[5] ?? 0);
  const date = new Date(0);
  date.setUTCFullYear(year, month - 1, day);
  date.setUTCHours(hours, minutes, 0, 0);
  if (!inRange(date) || date.getUTCFullYear() !== year || date.getUTCMonth() !== month - 1 || date.getUTCDate() !== day
    || date.getUTCHours() !== hours || date.getUTCMinutes() !== minutes) return null;
  return date;
}

function localNow(): Date {
  const date = new Date();
  return calendarDate(date.getFullYear(), date.getMonth(), date.getDate(), date.getHours(), date.getMinutes());
}

function stamp(date: Date, hours: number, minutes: number, mode: DateFieldProps['mode']): string {
  const day = dayKey(date);
  return mode === 'date' ? day : day + 'T' + pad(hours) + ':' + pad(minutes);
}

function monthStart(date: Date): Date {
  return calendarDate(date.getUTCFullYear(), date.getUTCMonth(), 1);
}

function moveMonth(date: Date, delta: number): Date {
  const first = calendarDate(date.getUTCFullYear(), date.getUTCMonth() + delta, 1);
  if (!inRange(first)) return date;
  const lastDay = calendarDate(first.getUTCFullYear(), first.getUTCMonth() + 1, 0).getUTCDate();
  return calendarDate(first.getUTCFullYear(), first.getUTCMonth(), Math.min(date.getUTCDate(), lastDay));
}

function calendarDays(cursor: Date, firstDayOfWeek: number): Date[] {
  const first = monthStart(cursor);
  const offset = (first.getUTCDay() - firstDayOfWeek + 7) % 7;
  const start = calendarDate(first.getUTCFullYear(), first.getUTCMonth(), 1 - offset);
  return Array.from({ length: 42 }, (_, index) =>
    calendarDate(start.getUTCFullYear(), start.getUTCMonth(), start.getUTCDate() + index));
}

export function DateField({ mode, value, onChange, onCommit, labels, locale, today, min, max, firstDayOfWeek = 1, ariaLabel, disabled, className }: DateFieldProps) {
  const [open, setOpen] = useState(false);
  const selected = parseStamp(value);
  const now = parseStamp(today ?? '') ?? localNow();
  const lower = parseStamp(min ?? ''), upper = parseStamp(max ?? '');
  if (lower && upper && dayKey(lower) > dayKey(upper)) throw new RangeError('min must precede max');
  const clampDay = (day: Date) => lower && dayKey(day) < dayKey(lower) ? lower : upper && dayKey(day) > dayKey(upper) ? upper : day;
  const allowed = (day: Date) => inRange(day) && clampDay(day) === day;
  const initial = clampDay(selected ?? now);
  const [cursor, setCursor] = useState(() => monthStart(initial));
  const [focusedDay, setFocusedDay] = useState(() => initial);
  const contentRef = useRef<HTMLDivElement>(null);
  const latest = useRef(value);
  const committed = useRef(value);
  latest.current = value;

  function change(next: string) {
    latest.current = next;
    onChange(next);
  }

  function commit(next: string) {
    if (next !== value) change(next);
    if (next !== committed.current) onCommit?.(next);
    committed.current = next;
    setOpen(false);
  }

  function onOpenChange(next: boolean) {
    if (next) {
      latest.current = value;
      committed.current = value;
      const date = clampDay(parseStamp(value) ?? now);
      setCursor(monthStart(date));
      setFocusedDay(date);
    } else if (latest.current !== committed.current) {
      onCommit?.(latest.current);
      committed.current = latest.current;
    }
    setOpen(next);
  }

  function moveFocus(day: Date, key: string, event: KeyboardEvent<HTMLButtonElement>) {
    const rtl = getComputedStyle(event.currentTarget).direction === 'rtl';
    const weekDay = (day.getUTCDay() - firstDayOfWeek + 7) % 7;
    let next: Date;
    switch (key) {
      case 'ArrowLeft': next = calendarDate(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate() + (rtl ? 1 : -1)); break;
      case 'ArrowRight': next = calendarDate(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate() + (rtl ? -1 : 1)); break;
      case 'ArrowUp': next = calendarDate(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate() - 7); break;
      case 'ArrowDown': next = calendarDate(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate() + 7); break;
      case 'Home': next = calendarDate(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate() - weekDay); break;
      case 'End': next = calendarDate(day.getUTCFullYear(), day.getUTCMonth(), day.getUTCDate() + 6 - weekDay); break;
      case 'PageUp': next = moveMonth(day, -1); break;
      case 'PageDown': next = moveMonth(day, 1); break;
      default: return;
    }
    event.preventDefault();
    if (!inRange(next)) return;
    next = clampDay(next);
    setCursor(monthStart(next));
    setFocusedDay(next);
    requestAnimationFrame(() => {
      contentRef.current?.querySelector<HTMLButtonElement>('[data-day="' + dayKey(next) + '"]')?.focus();
    });
  }

  function navigateMonth(delta: number) {
    const next = clampDay(moveMonth(focusedDay, delta));
    setCursor(monthStart(next));
    setFocusedDay(next);
  }

  const canNavigate = (delta: number) => monthStart(clampDay(moveMonth(focusedDay, delta))).getTime() !== monthStart(cursor).getTime();
  const hours = selected?.getUTCHours() ?? now.getUTCHours();
  const minutes = selected?.getUTCMinutes() ?? now.getUTCMinutes();
  const formatter = new Intl.DateTimeFormat(locale, mode === 'date'
    ? { dateStyle: 'medium', timeZone: 'UTC' }
    : { dateStyle: 'medium', timeStyle: 'short', timeZone: 'UTC' });
  const dayFormatter = new Intl.DateTimeFormat(locale, { dateStyle: 'full', timeZone: 'UTC' });
  const weekdays = Array.from({ length: 7 }, (_, index) =>
    new Intl.DateTimeFormat(locale, { weekday: 'short', timeZone: 'UTC' }).format(new Date(Date.UTC(2026, 0, 4 + firstDayOfWeek + index))));
  const days = calendarDays(cursor, firstDayOfWeek);
  const chosen = selected ? dayKey(selected) : '';
  const firstYear = lower?.getUTCFullYear() ?? Math.min(1920, cursor.getUTCFullYear());
  const lastYear = upper?.getUTCFullYear() ?? Math.min(9999, Math.max(now.getUTCFullYear() + 2, cursor.getUTCFullYear()));

  const portalHost = usePortalHost();
  return <Popover.Root open={open} onOpenChange={onOpenChange}>
    <div data-slot="date-field" className={className ? 'ui-date-field ' + className : 'ui-date-field'}>
      <Popover.Trigger asChild>
        <Button type="button" variant="outline" className="ui-date-trigger" disabled={disabled} aria-label={(ariaLabel ?? labels[mode]) + (selected ? ': ' + formatter.format(selected) : '')}>
          {selected ? formatter.format(selected) : labels[mode]}
        </Button>
      </Popover.Trigger>
      <Popover.Portal container={portalHost}>
        <Popover.Content ref={contentRef} data-slot="date-popover" className="ui-date-popover" sideOffset={8} collisionPadding={8} aria-label={labels.calendar}
          onOpenAutoFocus={(event) => {
            event.preventDefault();
            contentRef.current?.querySelector<HTMLButtonElement>('[data-day="' + dayKey(focusedDay) + '"]')?.focus();
          }}>
          <div className="ui-date-heading" aria-live="polite">
            {new Intl.DateTimeFormat(locale, { month: 'long', year: 'numeric', timeZone: 'UTC' }).format(cursor)}
          </div>
          <div className="ui-date-nav">
            <Button type="button" variant="ghost" size="icon" aria-label={labels.previousYear} disabled={!canNavigate(-12)} onClick={() => navigateMonth(-12)}><ChevronsLeft aria-hidden="true" /></Button>
            <Button type="button" variant="ghost" size="icon" aria-label={labels.previousMonth} disabled={!canNavigate(-1)} onClick={() => navigateMonth(-1)}><ChevronLeft aria-hidden="true" /></Button>
            <select className="ui-date-year" aria-label={labels.year} value={cursor.getUTCFullYear()} onChange={(event) => navigateMonth((Number(event.currentTarget.value) - cursor.getUTCFullYear()) * 12)}>
              {Array.from({ length: lastYear - firstYear + 1 }, (_, index) => firstYear + index).map((year) => <option key={year} value={year}>{year}</option>)}
            </select>
            <Button type="button" variant="ghost" size="icon" aria-label={labels.nextMonth} disabled={!canNavigate(1)} onClick={() => navigateMonth(1)}><ChevronRight aria-hidden="true" /></Button>
            <Button type="button" variant="ghost" size="icon" aria-label={labels.nextYear} disabled={!canNavigate(12)} onClick={() => navigateMonth(12)}><ChevronsRight aria-hidden="true" /></Button>
          </div>
          <table className="ui-date-grid">
            <thead><tr>{weekdays.map((day, index) => <th key={index} scope="col">{day}</th>)}</tr></thead>
            <tbody>{Array.from({ length: 6 }, (_, row) =>
              <tr key={row}>{days.slice(row * 7, row * 7 + 7).map((day, index) => {
                if (!inRange(day)) return <td key={index} />;
                const key = dayKey(day);
                return <td key={key}>
                  <button type="button" data-slot="date-day" data-day={key} className="ui-date-day"
                    data-outside={day.getUTCMonth() !== cursor.getUTCMonth() || undefined}
                    disabled={!allowed(day)} aria-label={dayFormatter.format(day)} aria-pressed={key === chosen}
                    aria-current={key === dayKey(now) ? 'date' : undefined}
                    tabIndex={key === dayKey(focusedDay) ? 0 : -1}
                    onKeyDown={(event) => moveFocus(day, event.key, event)}
                    onClick={() => {
                      const next = stamp(day, hours, minutes, mode);
                      if (mode === 'date') commit(next);
                      else {
                        change(next);
                        setCursor(monthStart(day));
                        setFocusedDay(day);
                      }
                    }}>{day.getUTCDate()}</button>
                </td>;
              })}</tr>)}</tbody>
          </table>
          {mode === 'datetime' ? <div className="ui-date-time">
            <label>{labels.hours}<input type="number" min="0" max="23" value={hours} onChange={(event) => {
              const nextHours = Math.min(23, Math.max(0, Number(event.currentTarget.value) || 0));
              change(stamp(clampDay(selected ?? focusedDay), nextHours, minutes, mode));
            }} /></label>
            <label>{labels.minutes}<input type="number" min="0" max="59" value={minutes} onChange={(event) => {
              const nextMinutes = Math.min(59, Math.max(0, Number(event.currentTarget.value) || 0));
              change(stamp(clampDay(selected ?? focusedDay), hours, nextMinutes, mode));
            }} /></label>
          </div> : null}
          <div className="ui-date-actions">
            <Button type="button" variant="ghost" onClick={() => commit('')}>{labels.clear}</Button>
            <Button type="button" variant="ghost" disabled={!allowed(now)} onClick={() => {
              const next = stamp(now, now.getUTCHours(), now.getUTCMinutes(), mode);
              if (mode === 'date') commit(next);
              else change(next);
            }}>{labels.today}</Button>
            {mode === 'datetime' ? <Button type="button" disabled={!!selected && !allowed(selected)} onClick={() => commit(latest.current)}>{labels.apply}</Button> : null}
          </div>
        </Popover.Content>
      </Popover.Portal>
    </div>
  </Popover.Root>;
}
