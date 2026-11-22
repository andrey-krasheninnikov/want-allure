import { useId, type ReactNode } from 'react';
import { Button } from './ui/button.js';
import { Popover, PopoverContent, PopoverTrigger } from './ui/popover.js';
import { RadioGroup, RadioGroupItem } from './ui/radio-group.js';

export function IconColorPicker({ label, iconLabel, colorLabel, value, icons, colors, onChange, upload }: {
  label: string; iconLabel: string; colorLabel: string;
  value: { icon: string; color: string };
  icons: readonly { id: string; label: string; glyph: ReactNode }[];
  colors: readonly { id: string; label: string; color: string }[];
  onChange: (value: { icon: string; color: string }) => void;
  upload?: ReactNode;
}) {
  const id = useId();
  return <Popover>
    <PopoverTrigger asChild><Button type="button" variant="secondary" size="icon" aria-label={label}
      style={{ color: colors.find(color => color.id === value.color)?.color }}>{icons.find(icon => icon.id === value.icon)?.glyph}</Button></PopoverTrigger>
    <PopoverContent align="start" className="ui-icon-picker">
      {upload}
      <RadioGroup aria-label={iconLabel} value={value.icon} onValueChange={icon => onChange({ ...value, icon })}>
        {icons.map((option, i) => <label key={option.id} htmlFor={id + '-icon-' + i} className="ui-picker-option">
          <RadioGroupItem value={option.id} id={id + '-icon-' + i} aria-label={option.label} /> <span aria-hidden="true">{option.glyph}</span>
        </label>)}
      </RadioGroup>
      <RadioGroup aria-label={colorLabel} value={value.color} onValueChange={color => onChange({ ...value, color })} className="ui-picker-colors">
        {colors.map((option, i) => <label key={option.id} htmlFor={id + '-color-' + i} className="ui-picker-option">
          <RadioGroupItem value={option.id} id={id + '-color-' + i} aria-label={option.label} />
          <span className="ui-picker-swatch" style={{ background: option.color }} aria-hidden="true" />{option.label}
        </label>)}
      </RadioGroup>
    </PopoverContent>
  </Popover>;
}

export function StepIndicator({ current, total, title, countLabel }: {
  current: number; total: number; title: ReactNode; countLabel: string;
}) {
  return <div className="ui-step-indicator" aria-label={countLabel} role="group">
    <div className="ui-step-segments" aria-hidden="true">{Array.from({ length: total }, (_, index) =>
      <span key={index} data-complete={index < current} />)}</div>
    <div className="ui-step-info" aria-live="polite"><span>{title}</span><span>{countLabel}</span></div>
  </div>;
}

export function ScreenTransition({ step, children }: { step: string | number; children: ReactNode }) {
  return <div key={step} className="ui-screen-transition">{children}</div>;
}

export function StateGlow({ active, children }: { active: boolean; children: ReactNode }) {
  return <span className="ui-state-glow" data-active={active}>{children}</span>;
}
