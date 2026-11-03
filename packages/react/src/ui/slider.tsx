import React, { useState } from 'react';
import { Slider as Primitive } from 'radix-ui';
import { cn } from '../utils.js';

type Common = {
  min?: number; max?: number; step?: number; disabled?: boolean;
  label: string; className?: string; id?: string;
  formatValue?: (value: number) => string;
};
export type SliderProps = Common & { value: number; onValueChange: (value: number) => void; onValueCommit?: (value: number) => void };
export type RangeSliderProps = Common & { value: readonly [number, number]; onValueChange: (value: [number, number]) => void; onValueCommit?: (value: [number, number]) => void; thumbLabels: readonly [string, string] };
function SliderControl({ value, onValueChange, onValueCommit, thumbLabels, min = 0, max = 100, step = 1, disabled, label, className, id, formatValue }: Common & { value: number[]; onValueChange: (value: number[]) => void; onValueCommit?: (value: number[]) => void; thumbLabels: readonly string[] }) {
  const [dragging, setDragging] = useState(false);
  return <Primitive.Root role="group" id={id} aria-label={label} value={value} onValueChange={onValueChange} onValueCommit={onValueCommit}
    min={min} max={max} step={step} disabled={disabled} data-slot="slider" data-dragging={dragging || undefined}
    onPointerDownCapture={() => setDragging(true)} onPointerUpCapture={() => setDragging(false)} onLostPointerCapture={() => setDragging(false)}
    className={cn('ui-slider', className)}>
    <Primitive.Track className="ui-slider-track"><Primitive.Range className="ui-slider-range" /></Primitive.Track>
    {value.map((current, index) => <Primitive.Thumb key={index} className="ui-slider-thumb" aria-label={thumbLabels[index]} aria-valuetext={formatValue?.(current)} />)}
  </Primitive.Root>;
}
export function Slider({ value, onValueChange, onValueCommit, ...props }: SliderProps) {
  return <SliderControl {...props} value={[value]} thumbLabels={[props.label]} onValueChange={next => onValueChange(next[0])} onValueCommit={onValueCommit && (next => onValueCommit(next[0]))} />;
}
export function RangeSlider({ value, onValueChange, onValueCommit, ...props }: RangeSliderProps) {
  return <SliderControl {...props} value={[...value]} onValueChange={next => onValueChange([next[0], next[1]])} onValueCommit={onValueCommit && (next => onValueCommit([next[0], next[1]]))} />;
}
