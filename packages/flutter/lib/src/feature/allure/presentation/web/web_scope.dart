import 'package:find_in_page/find_in_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart' show SelectionRegistrar;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:material_ui/material_ui.dart' show SelectionArea;
import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantFindLabels {
  final String search, previous, next, close;
  final String Function(int activeIndex, int count) matchStatus;
  const WantFindLabels({
    required this.search,
    required this.previous,
    required this.next,
    required this.close,
    required this.matchStatus,
  });
}

/// Adds selection and an application find bar. Native apps opt in with enabled.
class WantWebScope extends StatelessWidget {
  final Widget child;
  final WantFindLabels labels;
  final bool enabled;
  final bool enableFind;
  const WantWebScope({
    super.key,
    required this.child,
    required this.labels,
    this.enabled = kIsWeb,
    this.enableFind = false,
  });

  static bool enabledOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WebScope>() != null;
  static bool findEnabledOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FindScope>() != null;
  static bool openFind(BuildContext context) {
    final state = context.getInheritedWidgetOfExactType<_FindScope>()?.state;
    if (state == null) return false;
    state._controller.open();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    final selection = SelectionArea(child: child);
    return _WebScope(
      child: Overlay.wrap(
        child: enableFind
            ? _WantFindScope(labels: labels, child: selection)
            : selection,
      ),
    );
  }
}

class _WantFindScope extends StatefulWidget {
  final Widget child;
  final WantFindLabels labels;
  const _WantFindScope({required this.child, required this.labels});
  @override
  State<_WantFindScope> createState() => _WantFindScopeState();
}

class _WantFindScopeState extends State<_WantFindScope> {
  final _controller = FindInPageController();
  final _portal = OverlayPortalController();
  final _query = TextEditingController();
  final _focus = FocusNode();
  FocusNode? _previousFocus;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_changed);
  }

  void _show() {
    if (_open) {
      _focus.requestFocus();
      return;
    }
    _previousFocus = FocusManager.instance.primaryFocus;
    setState(() => _open = true);
    _portal.show();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _open) _focus.requestFocus();
    });
  }

  void _changed() {
    if (!_controller.isOpen && _open) {
      _portal.hide();
      _query.clear();
      setState(() => _open = false);
      final previous = _previousFocus;
      if (previous?.context != null && previous!.canRequestFocus) {
        previous.requestFocus();
      }
      _previousFocus = null;
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_changed);
    _controller.dispose();
    _query.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = WantTheme.of(context);
    return _FindScope(
      state: this,
      child: FindInPageScope(
        controller: _controller,
        showBar: false,
        onOpenRequested: _show,
        highlightColor: theme.color('warning').withValues(alpha: .36),
        activeHighlightColor: theme.color('info').withValues(alpha: .60),
        child: OverlayPortal(
          controller: _portal,
          overlayChildBuilder: (context) => SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topEnd,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: ExcludeFromFind(
                    child: CallbackShortcuts(
                      bindings: {
                        const SingleActivator(LogicalKeyboardKey.escape):
                            _controller.close,
                        const SingleActivator(LogicalKeyboardKey.enter):
                            _controller.next,
                        const SingleActivator(
                          LogicalKeyboardKey.enter,
                          shift: true,
                        ): _controller.previous,
                      },
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: theme.color('popover'),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: theme
                                  .color('foreground')
                                  .withValues(alpha: .16),
                              blurRadius: 28,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            spacing: 8,
                            children: [
                              WantInput(
                                label: Text(widget.labels.search),
                                controller: _query,
                                focusNode: _focus,
                                onChanged: (value) => _controller.search(value),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListenableBuilder(
                                      listenable: _controller,
                                      builder: (context, _) => Semantics(
                                        liveRegion: true,
                                        child: Text(
                                          widget.labels.matchStatus(
                                            _controller.activeMatchIndex ?? -1,
                                            _controller.matchCount,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  WantButton(
                                    size: WantButtonSize.icon,
                                    variant: WantButtonVariant.ghost,
                                    semanticsLabel: widget.labels.previous,
                                    onPressed: _controller.previous,
                                    child: const WantIcon(
                                      WantIcons.chevronLeft,
                                    ),
                                  ),
                                  WantButton(
                                    size: WantButtonSize.icon,
                                    variant: WantButtonVariant.ghost,
                                    semanticsLabel: widget.labels.next,
                                    onPressed: _controller.next,
                                    child: const WantIcon(
                                      WantIcons.chevronRight,
                                    ),
                                  ),
                                  WantButton(
                                    size: WantButtonSize.icon,
                                    variant: WantButtonVariant.ghost,
                                    semanticsLabel: widget.labels.close,
                                    onPressed: _controller.close,
                                    child: const WantIcon(WantIcons.x),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class _WebScope extends InheritedWidget {
  const _WebScope({required super.child});
  @override
  bool updateShouldNotify(_WebScope oldWidget) => false;
}

class _FindScope extends InheritedWidget {
  final _WantFindScopeState state;
  const _FindScope({required this.state, required super.child});
  @override
  bool updateShouldNotify(_FindScope oldWidget) => state != oldWidget.state;
}

/// Restores selection for labels inside controls that disable parent selection.
class WantSelectable extends StatelessWidget {
  final Widget child;
  final bool enabled;
  const WantSelectable({super.key, required this.child, this.enabled = true});
  @override
  Widget build(BuildContext context) {
    if (!WantWebScope.enabledOf(context)) return child;
    SelectionRegistrar? registrar;
    context.visitAncestorElements((element) {
      if (element.widget case SelectionRegistrarScope(
        registrar: final selection?,
      )) {
        registrar = selection;
        context.dependOnInheritedElement(element as InheritedElement);
        return false;
      }
      return true;
    });
    if (registrar == null) return child;
    // Keep the surrounding scroll selection and its gestures; skip disabled labels.
    return SelectionRegistrarScope(
      registrar: registrar!,
      child: DefaultSelectionStyle.merge(
        mouseCursor: enabled
            ? SystemMouseCursors.click
            : SystemMouseCursors.basic,
        child: child,
      ),
    );
  }
}
