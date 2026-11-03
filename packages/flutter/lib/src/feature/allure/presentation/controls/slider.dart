import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:sprung/sprung.dart';
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantSlider extends StatelessWidget {
  final double value, min, max, step;
  final ValueChanged<double>? onChanged, onChangeEnd;
  final Widget label;
  final String Function(double)? formatValue;
  const WantSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.onChangeEnd,
    this.formatValue,
  }) : assert(min < max),
       assert(step > 0 && step <= max - min),
       assert(value >= min && value <= max);
  double _value(double normalized) =>
      (min + ((normalized * (max - min)) / step).round() * step).clamp(
        min,
        max,
      );
  @override
  Widget build(BuildContext context) => _SliderSurface(
    builder: (style) => FSlider(
      style: style,
      label: WantSelectable(child: label),
      enabled: onChanged != null,
      trackHitRegionCrossExtent: 44,
      control: FSliderControl.liftedContinuous(
        value: FSliderValue(max: (value - min) / (max - min)),
        stepPercentage: step / (max - min),
        onChange: (next) => onChanged?.call(_value(next.max)),
      ),
      onEnd: onChangeEnd == null
          ? null
          : (next) => onChangeEnd!(_value(next.max)),
      semanticFormatterCallback: (next) =>
          formatValue?.call(_value(next.max)) ?? _value(next.max).toString(),
      semanticValueFormatterCallback: (next) =>
          formatValue?.call(_value(next)) ?? _value(next).toString(),
      tooltipBuilder: (_, next) =>
          Text(formatValue?.call(_value(next)) ?? _value(next).toString()),
    ),
  );
}

class WantRangeSlider extends StatelessWidget {
  final ({double start, double end}) value;
  final double min, max, step;
  final ValueChanged<({double start, double end})>? onChanged, onChangeEnd;
  final Widget label;
  final String Function(double)? formatValue;
  WantRangeSlider({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.onChangeEnd,
    this.formatValue,
  }) : assert(min < max),
       assert(step > 0 && step <= max - min),
       assert(
         value.start >= min && value.end <= max && value.start <= value.end,
       );
  double _value(double normalized) =>
      (min + ((normalized * (max - min)) / step).round() * step).clamp(
        min,
        max,
      );
  ({double start, double end}) _range(FSliderValue next) =>
      (start: _value(next.min), end: _value(next.max));
  @override
  Widget build(BuildContext context) => _SliderSurface(
    builder: (style) => FSlider(
      style: style,
      label: WantSelectable(child: label),
      enabled: onChanged != null,
      trackHitRegionCrossExtent: 44,
      control: FSliderControl.liftedContinuousRange(
        value: FSliderValue(
          min: (value.start - min) / (max - min),
          max: (value.end - min) / (max - min),
        ),
        stepPercentage: step / (max - min),
        onChange: (next) => onChanged?.call(_range(next)),
      ),
      onEnd: onChangeEnd == null ? null : (next) => onChangeEnd!(_range(next)),
      semanticFormatterCallback: (next) =>
          '${formatValue?.call(_value(next.min)) ?? _value(next.min)} – ${formatValue?.call(_value(next.max)) ?? _value(next.max)}',
      semanticValueFormatterCallback: (next) =>
          formatValue?.call(_value(next)) ?? _value(next).toString(),
      tooltipBuilder: (_, next) =>
          Text(formatValue?.call(_value(next)) ?? _value(next).toString()),
    ),
  );
}

class _SliderSurface extends StatefulWidget {
  final Widget Function(FSliderStyleDelta) builder;
  const _SliderSurface({required this.builder});
  @override
  State<_SliderSurface> createState() => _SliderSurfaceState();
}

class _SliderSurfaceState extends State<_SliderSurface> {
  bool _hovered = false, _focused = false;
  @override
  Widget build(BuildContext context) => MouseRegion(
    onEnter: (_) => setState(() => _hovered = true),
    onExit: (_) => setState(() => _hovered = false),
    child: Focus(
      canRequestFocus: false,
      onFocusChange: (value) => setState(() => _focused = value),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: _hovered || _focused ? 1.0 : 0.0),
        duration: WantTheme.reducedMotionOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 240),
        curve: Sprung.criticallyDamped,
        builder: (context, amount, _) => widget.builder(
          .delta(
            crossAxisExtent: 8,
            thumbSize: 24,
            borderRadius: BorderRadius.circular(99),
            thumbStyle: .delta(borderWidth: 2 + amount * 1.5),
          ),
        ),
      ),
    ),
  );
}
