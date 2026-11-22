import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

typedef WantPickerIcon = ({String id, String label, Widget glyph});
typedef WantPickerColor = ({String id, String label, Color color});

class WantIconColorPicker extends StatelessWidget {
  final String label, iconLabel, colorLabel, icon, color;
  final List<WantPickerIcon> icons;
  final List<WantPickerColor> colors;
  final ValueChanged<(String, String)> onChanged;
  final Widget? upload;
  const WantIconColorPicker({
    super.key,
    required this.label,
    required this.iconLabel,
    required this.colorLabel,
    required this.icon,
    required this.color,
    required this.icons,
    required this.colors,
    required this.onChanged,
    this.upload,
  });

  @override
  Widget build(BuildContext context) => WantPopover(
    child: IconTheme.merge(
      data: IconThemeData(
        color: colors.where((option) => option.id == color).firstOrNull?.color,
      ),
      child:
          icons.where((option) => option.id == icon).firstOrNull?.glyph ??
          const WantIcon(WantIcons.image),
    ),
    triggerBuilder: (context, toggle, child) => WantButton(
      semanticsLabel: label,
      size: WantButtonSize.icon,
      onPressed: toggle,
      variant: WantButtonVariant.secondary,
      child: child,
    ),
    contentBuilder: (context, close) => ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          ?upload,
          Semantics(
            label: iconLabel,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              children: [
                for (final option in icons)
                  Semantics(
                    selected: option.id == icon,
                    child: WantButton(
                      size: WantButtonSize.icon,
                      semanticsLabel: option.label,
                      variant: option.id == icon
                          ? WantButtonVariant.secondary
                          : WantButtonVariant.ghost,
                      onPressed: () => onChanged((option.id, color)),
                      child: option.glyph,
                    ),
                  ),
              ],
            ),
          ),
          Semantics(
            label: colorLabel,
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: WantTheme.of(context).color('border')),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    for (final option in colors)
                      Semantics(
                        selected: option.id == color,
                        child: WantButton(
                          pill: false,
                          variant: option.id == color
                              ? WantButtonVariant.secondary
                              : WantButtonVariant.ghost,
                          onPressed: () => onChanged((icon, option.id)),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            spacing: 6,
                            children: [
                              SizedBox.square(
                                dimension: 12,
                                child: DecoratedBox(
                                  decoration: BoxDecoration(
                                    color: option.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                              Text(option.label),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class WantStepIndicator extends StatelessWidget {
  final int current, total;
  final Widget title;
  final String countLabel;
  const WantStepIndicator({
    super.key,
    required this.current,
    required this.total,
    required this.title,
    required this.countLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final reduced = WantTheme.reducedMotionOf(context);
    return Column(
      spacing: 8,
      children: [
        ExcludeSemantics(
          child: Row(
            spacing: 4,
            children: [
              for (var i = 0; i < total; i++)
                Expanded(
                  child: AnimatedContainer(
                    duration: reduced
                        ? Duration.zero
                        : const Duration(milliseconds: 180),
                    height: 6,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      color: theme.color(
                        i < current ? 'primary-edge' : 'secondary',
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        Semantics(
          liveRegion: true,
          child: Row(
            spacing: 8,
            children: [
              Expanded(child: title),
              WantAnimatedText(countLabel, effect: WantTextEffect.slide),
            ],
          ),
        ),
      ],
    );
  }
}

class WantScreenTransition extends StatelessWidget {
  final Object step;
  final Widget child;
  const WantScreenTransition({
    super.key,
    required this.step,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (WantTheme.reducedMotionOf(context)) {
      return KeyedSubtree(key: ValueKey(step), child: child);
    }
    return TweenAnimationBuilder<double>(
      key: ValueKey(step),
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      child: child,
      builder: (context, t, content) => Opacity(
        opacity: t,
        child: Transform.translate(
          offset: Offset(0, 5 * (1 - t)),
          child: content,
        ),
      ),
    );
  }
}

class WantStateGlow extends StatelessWidget {
  final bool active;
  final Widget child;
  final BorderRadius radius;
  const WantStateGlow({
    super.key,
    required this.active,
    required this.child,
    this.radius = const BorderRadius.all(Radius.circular(100)),
  });

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.highContrastOf(context)) return child;
    return AnimatedContainer(
      duration: WantTheme.reducedMotionOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: WantTheme.of(context)
                .color('primary')
                .withValues(alpha: active ? .25 : 0),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        ],
      ),
      child: child,
    );
  }
}
