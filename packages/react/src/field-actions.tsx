import { useImperativeHandle, useLayoutEffect, useEffect, useRef, useState, type ComponentProps, type ReactNode } from 'react';
import { Check, Copy, Eye, EyeOff } from 'lucide-react';
import { Button } from './ui/button.js';
import { Input } from './ui/input.js';
import { ThemeIcon } from './theme-icon.js';
import { cn } from './utils.js';

export function IconButton({ label, className, ...props }: Omit<ComponentProps<typeof Button>, 'variant' | 'size'> & { label: string }) {
  return <Button type="button" {...props} aria-label={label} size="icon" variant="ghost" className={cn('ui-icon-button', className)} />;
}

type PasswordProps = Omit<ComponentProps<typeof Input>, 'type'> & {
  showLabel: string; hideLabel: string; obscured?: boolean; onObscuredChange?: (value: boolean) => void;
  actions?: ReactNode; invalid?: boolean; showVisibilityToggle?: boolean;
};
export function PasswordInput({ showLabel, hideLabel, obscured, onObscuredChange, actions, invalid,
  showVisibilityToggle = true, disabled, autoComplete = 'off', className, ref: externalRef, ...input }: PasswordProps) {
  const [hidden, setHidden] = useState(true);
  const concealed = obscured ?? hidden;
  const ref = useRef<HTMLInputElement>(null);
  useImperativeHandle(externalRef, () => ref.current!, []);
  const selection = useRef<[number, number, 'forward' | 'backward' | 'none'] | null>(null);
  function rememberSelection() {
    const element = ref.current;
    if (element && element.selectionStart !== null && element.selectionEnd !== null) {
      selection.current = [element.selectionStart, element.selectionEnd, element.selectionDirection ?? 'none'];
    }
  }
  useLayoutEffect(() => {
    if (!selection.current) return;
    const element = ref.current, range = selection.current;
    selection.current = null;
    if (!element) return;
    element.setSelectionRange(...range);
    // Chromium may reset the caret during the next layout after a password type change.
    const frame = requestAnimationFrame(() => {
      if (element.selectionStart === 0 && element.selectionEnd === 0) element.setSelectionRange(...range);
    });
    return () => cancelAnimationFrame(frame);
  }, [concealed]);
  const toggle = () => {
    if (!selection.current) rememberSelection();
    if (obscured === undefined) setHidden(!concealed);
    onObscuredChange?.(!concealed);
  };
  return <div className={cn('ui-password-field', className)} data-invalid={invalid || input['aria-invalid'] || undefined} data-disabled={disabled || undefined}>
    <Input autoCapitalize="none" autoCorrect="off" spellCheck={false} {...input} ref={ref}
      disabled={disabled} autoComplete={autoComplete} type={concealed ? 'password' : 'text'} aria-invalid={input['aria-invalid'] ?? (invalid || undefined)} />
    {(showVisibilityToggle || actions) && <div className="ui-field-actions">{actions}
      {showVisibilityToggle && <IconButton disabled={disabled} label={concealed ? showLabel : hideLabel}
        onPointerDown={event => { rememberSelection(); if (document.activeElement === ref.current) event.preventDefault(); }}
        onClick={toggle}><ThemeIcon iconRole={concealed ? 'show' : 'hide'} icon={concealed ? Eye : EyeOff}/></IconButton>}
    </div>}
  </div>;
}

export function CopyAction({ label, copiedLabel, errorLabel, onCopy, children }: {
  label: string; copiedLabel: string; errorLabel: string; onCopy: () => Promise<void>; children?: ReactNode;
}) {
  const [state, setState] = useState<'idle' | 'pending' | 'copied' | 'error'>('idle');
  const timer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined), alive = useRef(false), pending = useRef(false);
  useEffect(() => {
    alive.current = true;
    return () => { alive.current = false; clearTimeout(timer.current); };
  }, []);
  async function copy() {
    if (pending.current) return;
    pending.current = true;
    clearTimeout(timer.current);
    setState('pending');
    try {
      await onCopy();
      if (!alive.current) return;
      setState('copied');
      timer.current = setTimeout(() => setState('idle'), 3000);
    } catch {
      if (alive.current) setState('error');
    } finally { pending.current = false; }
  }
  const glyph = <span className="ui-copy-glyph" data-state={state} aria-hidden="true">
    <ThemeIcon iconRole="copy" icon={Copy} /><ThemeIcon iconRole="check" icon={Check} />
  </span>;
  return <div className="ui-copy-action">
    {children ? <Button type="button" variant="ghost" className="ui-copy-row" aria-label={label}
      aria-disabled={state === 'pending'} onClick={copy}><span>{children}</span>{glyph}</Button> :
      <IconButton label={label} aria-disabled={state === 'pending'} onClick={copy}>{glyph}</IconButton>}
    <span role="status" className={state === 'error' ? 'ui-copy-error' : 'sr-only'}>{state === 'error' ? errorLabel : state === 'copied' ? copiedLabel : ''}</span>
  </div>;
}
