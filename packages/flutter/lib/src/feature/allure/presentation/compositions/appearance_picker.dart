import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantThemeMode { system, light, dark }

typedef WantLanguageOption<T> = ({
  T value,
  String name,
  String code,
  String flag,
});

class WantLanguagePicker<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<WantLanguageOption<T>> options;
  final ValueChanged<T> onChanged;

  const WantLanguagePicker({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final current = options
        .where((option) => option.value == value)
        .firstOrNull;
    return Semantics(
      label: label,
      child: WantDropdownMenu(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            if (current != null) ExcludeSemantics(child: Text(current.flag)),
            Text(current?.code ?? label),
            const WantIcon(WantIcons.chevronDown, size: 16),
          ],
        ),
        items: [
          for (final option in options)
            WantMenuItem(
              label: Semantics(
                selected: option.value == value,
                child: Row(
                  spacing: 8,
                  children: [
                    ExcludeSemantics(child: Text(option.flag)),
                    Flexible(child: Text(option.name)),
                  ],
                ),
              ),
              onPressed: () => onChanged(option.value),
            ),
        ],
      ),
    );
  }
}

class WantThemePicker extends StatelessWidget {
  final WantThemeMode value;
  final Brightness brightness;
  final String label;
  final Map<WantThemeMode, String> labels;
  final ValueChanged<WantThemeMode> onChanged;

  const WantThemePicker({
    super.key,
    required this.value,
    required this.brightness,
    required this.label,
    required this.labels,
    required this.onChanged,
  });

  static const _icons = {
    WantThemeMode.system: WantIcons.monitor,
    WantThemeMode.light: WantIcons.sun,
    WantThemeMode.dark: WantIcons.moon,
  };

  @override
  Widget build(BuildContext context) {
    final resolved = brightness == Brightness.dark
        ? WantThemeMode.dark
        : WantThemeMode.light;
    return Semantics(
      label: label,
      child: WantDropdownMenu(
        label: SizedBox.square(
          dimension: 24,
          child: AnimatedSwitcher(
            duration: WantTheme.reducedMotionOf(context)
                ? Duration.zero
                : const Duration(milliseconds: 180),
            child: WantIcon(_icons[resolved]!, key: ValueKey(resolved)),
          ),
        ),
        items: [
          for (final mode in WantThemeMode.values)
            WantMenuItem(
              label: Semantics(
                selected: value == mode,
                child: Text(labels[mode] ?? mode.name),
              ),
              icon: WantIcon(_icons[mode]!),
              onPressed: () => onChanged(mode),
            ),
        ],
      ),
    );
  }
}
