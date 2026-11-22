import type { ReactNode } from 'react';
import { Check, ChevronDown, Monitor, Moon, Sun } from 'lucide-react';
import { Button } from './ui/button.js';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from './ui/dropdown-menu.js';
import { ThemeIcon } from './theme-icon.js';

export type ThemeMode = 'system' | 'light' | 'dark';
export type LanguageOption<Value extends string> = { value: Value; name: string; code: string; flag: string };

export function LanguagePicker<Value extends string>({ label, value, options, onChange }: {
  label: string; value: Value; options: readonly LanguageOption<Value>[]; onChange: (value: Value) => void;
}) {
  const current = options.find(option => option.value === value);
  return <DropdownMenu>
    <DropdownMenuTrigger asChild>
      <Button aria-label={label} type="button" variant="ghost" className="ui-language-picker">
        <span aria-hidden="true">{current?.flag}</span><span lang={value}>{current?.code ?? value}</span>
        <ThemeIcon icon={ChevronDown} size={16} />
      </Button>
    </DropdownMenuTrigger>
    <DropdownMenuContent align="end" className="ui-language-menu">
      {options.map(option => <DropdownMenuItem key={option.value} textValue={option.name} aria-current={option.value === value}
        onSelect={() => onChange(option.value)}>
        <span aria-hidden="true">{option.flag}</span><span lang={option.value} dir="auto">{option.name}</span>
        {option.value === value && <ThemeIcon icon={Check} size={16} />}
      </DropdownMenuItem>)}
    </DropdownMenuContent>
  </DropdownMenu>;
}

const themeIcons = { system: Monitor, light: Sun, dark: Moon };
export function ThemePicker({ label, value, resolved, labels, onChange }: {
  label: string; value: ThemeMode; resolved: 'light' | 'dark'; labels: Record<ThemeMode, ReactNode>; onChange: (value: ThemeMode) => void;
}) {
  return <DropdownMenu>
    <DropdownMenuTrigger asChild>
      <Button aria-label={label} type="button" variant="ghost" size="icon">
        <ThemeIcon icon={themeIcons[resolved]} key={resolved} className="ui-theme-picker-icon" size={20} />
      </Button>
    </DropdownMenuTrigger>
    <DropdownMenuContent align="end">
      {(Object.keys(themeIcons) as ThemeMode[]).map(mode => <DropdownMenuItem key={mode} aria-current={value === mode}
        onSelect={() => onChange(mode)}>
        <ThemeIcon icon={themeIcons[mode]} size={18} /><span>{labels[mode]}</span>
        {value === mode && <ThemeIcon icon={Check} size={16} />}
      </DropdownMenuItem>)}
    </DropdownMenuContent>
  </DropdownMenu>;
}
