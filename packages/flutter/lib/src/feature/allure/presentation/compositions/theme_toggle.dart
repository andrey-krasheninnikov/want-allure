import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantThemeToggle extends StatelessWidget {
  final Brightness brightness;
  final ValueChanged<Brightness> onChanged;
  final String lightLabel, darkLabel;
  const WantThemeToggle({
    super.key,
    required this.brightness,
    required this.onChanged,
    required this.lightLabel,
    required this.darkLabel,
  });
  @override
  Widget build(BuildContext context) => WantButton(
    size: WantButtonSize.icon,
    variant: WantButtonVariant.secondary,
    semanticsLabel: brightness == Brightness.dark ? lightLabel : darkLabel,
    onPressed: () => onChanged(
      brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ),
    child: AnimatedRotation(
      turns: brightness == Brightness.dark ? 0 : 1,
      duration: WantTheme.reducedMotionOf(context)
          ? Duration.zero
          : WantTokens.motion['transitionMs']!,
      curve: const Cubic(.32, .72, 0, 1),
      child: Icon(
        brightness == Brightness.dark ? WantIcons.sun : WantIcons.moon,
      ),
    ),
  );
}
