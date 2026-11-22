import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:smooth_sheets/smooth_sheets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

enum WantSheetSide { top, right, bottom, left }

class WantSheet extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? actions;
  const WantSheet({
    super.key,
    required this.title,
    required this.child,
    this.actions,
  });
  @override
  Widget build(BuildContext context) => Semantics(
    namesRoute: true,
    label: title,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: WantTheme.of(context).color('popover'),
        borderRadius: BorderRadius.circular(WantTheme.of(context).panelRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 20,
            children: [
              WantTypography(title, variant: WantTypographyVariant.h3),
              child,
              ?actions,
            ],
          ),
        ),
      ),
    ),
  );
}

Future<T?> showWantSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  WantSheetSide side = WantSheetSide.bottom,
  String? barrierLabel,
}) {
  final navigator = Navigator.of(context);
  final focus = FocusManager.instance.primaryFocus;
  final environment = captureWantOverlayEnvironment(context, navigator.context);
  final themes = InheritedTheme.capture(from: context, to: navigator.context);
  final label = barrierLabel ?? FLocalizations.of(context)?.barrierLabel;
  final vertical = side == WantSheetSide.bottom || side == WantSheetSide.top;
  Widget surface(BuildContext context) {
    final media = MediaQuery.of(context);
    final corner = Radius.circular(WantTheme.of(context).panelRadius);
    final radius = switch (side) {
      WantSheetSide.bottom => BorderRadius.vertical(top: corner),
      WantSheetSide.top => BorderRadius.vertical(bottom: corner),
      WantSheetSide.left => BorderRadius.horizontal(right: corner),
      WantSheetSide.right => BorderRadius.horizontal(left: corner),
    };
    return Padding(
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight:
              (media.size.height -
                      media.viewInsets.bottom -
                      media.padding.vertical -
                      24)
                  .clamp(0, double.infinity),
          maxWidth: vertical ? 640 : 400,
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: ColoredBox(
            color: WantTheme.of(context).color('popover'),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: vertical ? media.size.width : 400,
                child: builder(context),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final Future<T?> result;
  if (side == WantSheetSide.bottom) {
    final forui = FTheme.capture(from: context, to: navigator.context);
    result = navigator.push<T>(
      ModalSheetRoute<T>(
        barrierLabel: label,
        barrierColor: WantTheme.of(context).forui.colors.barrier,
        swipeDismissible: !WantTheme.reducedMotionOf(context),
        transitionDuration: WantTheme.reducedMotionOf(context)
            ? Duration.zero
            : const Duration(milliseconds: 360),
        transitionCurve: const Cubic(.16, 1, .3, 1),
        viewportBuilder: (context, child) => SheetViewport(
          padding: EdgeInsets.symmetric(
            horizontal: ((MediaQuery.sizeOf(context).width - 640) / 2).clamp(
              0.0,
              double.infinity,
            ),
          ),
          child: child,
        ),
        builder: (context) => forui.wrap(
          themes.wrap(
            Sheet(
              scrollConfiguration: const SheetScrollConfiguration(
                scrollSyncMode: SheetScrollHandlingBehavior.onlyFromTop,
              ),
              decoration: const SheetDecorationBuilder(
                size: SheetSize.fit,
                builder: _sheetDecoration,
              ),
              child: environment(Builder(builder: surface)),
            ),
          ),
        ),
      ),
    );
  } else {
    result = showFSheet<T>(
      context: context,
      builder: (context) => themes.wrap(environment(Builder(builder: surface))),
      useSafeArea: true,
      constraints: BoxConstraints(maxWidth: vertical ? 640 : 400),
      barrierLabel: label,
      side: switch (side) {
        WantSheetSide.top => FLayout.ttb,
        WantSheetSide.left => FLayout.ltr,
        WantSheetSide.right => FLayout.rtl,
        WantSheetSide.bottom => FLayout.btt,
      },
    );
  }
  return result.whenComplete(() {
    if (context.mounted && focus?.context != null && focus!.canRequestFocus) {
      focus.requestFocus();
    }
  });
}

Widget _sheetDecoration(BuildContext context, Widget child) => child;
