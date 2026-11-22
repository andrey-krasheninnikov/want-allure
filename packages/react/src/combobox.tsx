import { useEffect, useId, useRef, useState, type ReactNode } from 'react';
import { Check } from 'lucide-react';
import { Button } from './ui/button.js';
import { Input } from './ui/input.js';
import { Popover, PopoverAnchor, PopoverContent } from './ui/popover.js';
import { cn } from './utils.js';

export type ComboboxOption = { value: string; label: string; disabled?: boolean };
export type ComboboxProps = {
  label: ReactNode;
  options: ComboboxOption[];
  value: string;
  onValueChange: (value: string) => void;
  emptyLabel: string;
  query?: string;
  onQueryChange?: (query: string) => void;
  filterMode?: 'local' | 'external';
  loading?: boolean;
  loadingLabel?: string;
  errorLabel?: string;
  onRetry?: () => void;
  retryLabel?: string;
  placeholder?: string;
  selectedLabel?: string;
  id?: string;
  name?: string;
  disabled?: boolean;
  required?: boolean;
  className?: string;
};

export function Combobox({ label, options, value, onValueChange, emptyLabel, placeholder, id, name, disabled, required, className,
  selectedLabel, query: controlledQuery, onQueryChange, filterMode = 'local', loading, loadingLabel, errorLabel, onRetry, retryLabel }: ComboboxProps) {
  const generatedId = useId();
  const inputId = id ?? generatedId;
  const listId = inputId + '-options';
  const labelId = inputId + '-label';
  const [open, setOpen] = useState(false);
  const [localQuery, setLocalQuery] = useState('');
  const query = controlledQuery ?? localQuery;
  function editQuery(next: string) {
    if (controlledQuery === undefined) setLocalQuery(next);
    onQueryChange?.(next);
  }
  const [activeValue, setActiveValue] = useState<string | null>(null);
  const activeElement = useRef<HTMLDivElement>(null);
  const input = useRef<HTMLInputElement>(null);
  const retryButton = useRef<HTMLButtonElement>(null);
  const [lastSelection, setLastSelection] = useState<ComboboxOption>();
  const selected = options.find(option => option.value === value) ?? (lastSelection?.value === value ? lastSelection : undefined);
  const display = selectedLabel ?? selected?.label ?? '';
  const filter = query === display ? '' : query.trim().toLocaleLowerCase();
  const filtered = loading || errorLabel ? [] : filterMode === 'external' ? options : options.filter(option => option.label.toLocaleLowerCase().includes(filter));
  const enabled = filtered.filter(option => !option.disabled);
  const active = enabled.find(option => option.value === activeValue) ?? enabled[0];
  const activeIndex = active ? filtered.indexOf(active) : -1;

  useEffect(() => { if (open) activeElement.current?.scrollIntoView({ block: 'nearest' }); }, [open, active?.value]);

  function changeOpen(next: boolean) {
    setOpen(next && !disabled);
    if (controlledQuery === undefined) setLocalQuery(filterMode === 'external' ? '' : display);
    setActiveValue(value);
  }
  function choose(option: ComboboxOption) {
    if (disabled || option.disabled) return;
    setLastSelection(option);
    onValueChange(option.value);
    setOpen(false);
  }

  return <div data-slot="combobox" className={cn('ui-combobox', className)}>
    <label id={labelId} htmlFor={inputId}>{label}</label>
    {name && <input type="hidden" name={name} value={value} disabled={disabled} />}
    <Popover open={open && !disabled} onOpenChange={changeOpen}>
      <PopoverAnchor asChild><Input ref={input} id={inputId} role="combobox" autoComplete="off" aria-autocomplete="list" aria-haspopup="listbox"
        aria-expanded={open && !disabled} aria-controls={open && !disabled ? listId : undefined}
        aria-activedescendant={open && !disabled && activeIndex >= 0 ? listId + '-' + activeIndex : undefined}
        value={open && !disabled ? query : display} placeholder={placeholder} disabled={disabled} required={required}
        onFocus={() => changeOpen(true)} onClick={() => { if (!open) changeOpen(true); }}
        onChange={event => { editQuery(event.currentTarget.value); setActiveValue(null); setOpen(true); }}
        onKeyDown={event => {
          if (event.nativeEvent.isComposing) return;
          if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
            event.preventDefault();
            if (!open) { changeOpen(true); return; }
            if (enabled.length) {
              const index = active ? enabled.indexOf(active) : -1;
              setActiveValue(enabled[(index + (event.key === 'ArrowDown' ? 1 : -1) + enabled.length) % enabled.length]!.value);
            }
          } else if (event.key === 'Enter' && open) {
            event.preventDefault();
            if (active) choose(active);
          } else if (event.key === 'Escape' && open) {
            event.preventDefault(); changeOpen(false);
          } else if (event.key === 'Tab' && open) {
            if (!event.shiftKey && retryButton.current) { event.preventDefault(); retryButton.current.focus(); }
            else changeOpen(false);
          }
        }} /></PopoverAnchor>
      <PopoverContent role="presentation" className="ui-combobox-popup" onOpenAutoFocus={event => event.preventDefault()} onCloseAutoFocus={event => event.preventDefault()} onInteractOutside={event => { if (event.target === input.current) event.preventDefault(); }}>
        <div id={listId} role="listbox" aria-busy={loading || undefined} aria-labelledby={labelId}>
          {filtered.map((option, index) => <div key={option.value} id={listId + '-' + index} role="option" aria-selected={option.value === value} aria-disabled={option.disabled || undefined}
            ref={option === active ? activeElement : undefined} className="ui-combobox-option" data-highlighted={option === active || undefined}
            onPointerMove={() => { if (!option.disabled) setActiveValue(option.value); }} onPointerDown={event => event.preventDefault()} onClick={() => choose(option)}>
            <Check aria-hidden="true" style={{ visibility: option.value === value ? 'visible' : 'hidden' }} />{option.label}
          </div>)}
        </div>
        {loading && loadingLabel && <p role="status" className="ui-combobox-empty">{loadingLabel}</p>}
        {!loading && errorLabel && <div className="ui-combobox-empty"><p role="alert">{errorLabel}</p>
          {onRetry && retryLabel && <Button ref={retryButton} type="button" variant="secondary" onClick={() => { input.current?.focus(); onRetry(); }}>{retryLabel}</Button>}
        </div>}
        {!loading && !errorLabel && filtered.length === 0 && <p role="status" className="ui-combobox-empty">{emptyLabel}</p>}
      </PopoverContent>
    </Popover>
  </div>;
}
