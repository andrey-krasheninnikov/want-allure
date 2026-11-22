import 'package:flutter/widgets.dart';
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantContentStatus { empty, loading, error }

/// Inline feedback for a collection or region. The application supplies its copy and actions.
class WantContentState extends StatelessWidget {
  final WantContentStatus status;
  final Widget title;
  final Widget? description, action, icon;
  const WantContentState({
    super.key,
    required this.status,
    required this.title,
    this.description,
    this.action,
    this.icon,
  });
  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    final glyph = switch (status) {
      WantContentStatus.empty => WantIcons.file,
      WantContentStatus.error => WantIcons.warning,
      WantContentStatus.loading => WantIcons.info,
    };
    return Semantics(
      container: true,
      liveRegion: true,
      child: Padding(
        padding: EdgeInsets.all(theme.compact ? 12 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            ExcludeSemantics(
              child:
                  icon ??
                  (status == WantContentStatus.loading
                      ? const WantLoader(label: '')
                      : WantIcon(
                          glyph,
                          color: theme.color(
                            status == WantContentStatus.error
                                ? 'error-text'
                                : 'muted-foreground',
                          ),
                        )),
            ),
            DefaultTextStyle.merge(
              style: theme.forui.typography.display.sm,
              textAlign: TextAlign.center,
              child: title,
            ),
            if (description != null)
              DefaultTextStyle.merge(
                style: TextStyle(color: theme.color('muted-foreground')),
                textAlign: TextAlign.center,
                child: description!,
              ),
            ?action,
          ],
        ),
      ),
    );
  }
}
