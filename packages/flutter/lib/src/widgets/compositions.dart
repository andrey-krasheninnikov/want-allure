import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:forui/forui.dart';

import '../foundation/theme.dart';
import 'controls.dart';
import 'layout.dart';
import 'typography.dart';

class WantBrandLogo extends StatelessWidget {
  final Widget image;
  final String label;
  final double size;
  const WantBrandLogo({
    super.key,
    required this.image,
    required this.label,
    this.size = 32,
  });
  WantBrandLogo.asset(
    String asset, {
    super.key,
    required this.label,
    this.size = 32,
    String? package,
  }) : image = asset.toLowerCase().endsWith('.svg')
           ? SvgPicture.asset(asset, package: package, fit: BoxFit.contain)
           : Image.asset(asset, package: package, fit: BoxFit.contain);
  @override
  Widget build(BuildContext context) => Semantics(
    image: true,
    label: label,
    excludeSemantics: true,
    child: SizedBox.square(dimension: size, child: image),
  );
}

class WantBrandLockup extends StatelessWidget {
  final String name;
  final String? subtitle;
  final Widget logo;
  final VoidCallback? onPressed;
  const WantBrandLockup({
    super.key,
    required this.name,
    required this.logo,
    this.subtitle,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) => FTappable(
    onPress: onPressed,
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          ExcludeSemantics(child: logo),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 14,
                      color: WantTheme.of(context).color('muted-foreground'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class WantMediaCard extends StatelessWidget {
  final Widget image;
  final String title, imageLabel;
  final String? caption;
  final int? index;
  final double aspectRatio;
  final VoidCallback? onPressed;
  const WantMediaCard({
    super.key,
    required this.image,
    required this.title,
    required this.imageLabel,
    this.caption,
    this.index,
    this.aspectRatio = 16 / 9,
    this.onPressed,
  });
  @override
  Widget build(BuildContext context) => FTappable(
    onPress: onPressed,
    child: WantCard(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(24)),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Semantics(
                label: imageLabel,
                image: true,
                excludeSemantics: true,
                child: image,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      WantTypography(title, variant: WantTypographyVariant.h3),
                      if (caption != null)
                        WantTypography(
                          caption!,
                          variant: WantTypographyVariant.caption,
                          colorRole: 'muted-foreground',
                        ),
                    ],
                  ),
                ),
                if (index != null)
                  ExcludeSemantics(
                    child: Text(index.toString().padLeft(2, '0')),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class WantContactAction {
  final String title;
  final String? detail, semanticsLabel;
  final Widget? icon;
  final VoidCallback onPressed;
  const WantContactAction({
    required this.title,
    required this.onPressed,
    this.detail,
    this.semanticsLabel,
    this.icon,
  });
}

class WantContactCard extends StatelessWidget {
  final String name;
  final String? subtitle;
  final List<WantContactAction> actions;
  const WantContactCard({
    super.key,
    required this.name,
    required this.actions,
    this.subtitle,
  });
  @override
  Widget build(BuildContext context) => WantCard(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 16,
      children: [
        Row(
          spacing: 12,
          children: [
            ExcludeSemantics(
              child: Container(
                width: 48,
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: WantTheme.of(context).color('secondary'),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  name
                      .trim()
                      .split(RegExp(r'\s+'))
                      .where((part) => part.isNotEmpty)
                      .take(2)
                      .map((part) => String.fromCharCode(part.runes.first))
                      .join()
                      .toUpperCase(),
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  if (subtitle != null)
                    WantTypography(
                      subtitle!,
                      variant: WantTypographyVariant.small,
                      colorRole: 'muted-foreground',
                    ),
                ],
              ),
            ),
          ],
        ),
        for (final action in actions)
          WantButton(
            variant: WantButtonVariant.secondary,
            semanticsLabel: action.semanticsLabel,
            onPressed: action.onPressed,
            child: Row(
              spacing: 12,
              children: [
                action.icon ?? const Icon(FLucideIcons.link),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(action.title),
                      if (action.detail != null)
                        Text(
                          action.detail!,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(fontSize: 14),
                        ),
                    ],
                  ),
                ),
                const Icon(FLucideIcons.arrowUpRight, size: 18),
              ],
            ),
          ),
      ],
    ),
  );
}

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
    child: Icon(
      brightness == Brightness.dark ? FLucideIcons.sun : FLucideIcons.moon,
    ),
  );
}

class WantCommentAction {
  final String id, label;
  final Widget? icon;
  final bool disabled;
  const WantCommentAction({
    required this.id,
    required this.label,
    this.icon,
    this.disabled = false,
  });
}

class WantComment {
  final String id, author, text;
  final String? dateLabel;
  final DateTime? dateTime;
  final bool own;
  final List<WantCommentAction> actions;
  const WantComment({
    required this.id,
    required this.author,
    required this.text,
    this.dateLabel,
    this.dateTime,
    this.own = false,
    this.actions = const [],
  });
}

class WantCommentFeedLabels {
  final String title, empty, previous, next, readMore, collapse;
  const WantCommentFeedLabels({
    required this.title,
    required this.empty,
    required this.previous,
    required this.next,
    required this.readMore,
    required this.collapse,
  });
}

class WantCommentFeed extends StatefulWidget {
  final List<WantComment> comments;
  final WantCommentFeedLabels labels;
  final void Function(String commentId, String actionId) onAction;
  final bool busy;
  const WantCommentFeed({
    super.key,
    required this.comments,
    required this.labels,
    required this.onAction,
    this.busy = false,
  });
  @override
  State<WantCommentFeed> createState() => _WantCommentFeedState();
}

class _WantCommentFeedState extends State<WantCommentFeed> {
  final _scroll = ScrollController();
  final _expanded = <String>{};
  int _page = 1;
  double _step = 1;
  int _count = 1;
  @override
  void initState() {
    super.initState();
    _scroll.addListener(_update);
  }

  void _update() {
    final current = (_scroll.offset / _step).round().clamp(0, _count - 1) + 1;
    if (_page != current) setState(() => _page = current);
  }

  void _move(int delta) {
    if (!_scroll.hasClients) return;
    final offset = ((_page - 1 + delta) * _step).clamp(
      0.0,
      _scroll.position.maxScrollExtent,
    );
    if (WantTheme.reducedMotionOf(context)) {
      _scroll.jumpTo(offset);
    } else {
      _scroll.animateTo(
        offset,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      if (widget.comments.isEmpty) return Text(widget.labels.empty);
      final visible = constraints.maxWidth >= 700 ? 2 : 1;
      final width = math.max(
        1.0,
        (constraints.maxWidth - (visible - 1) * 16) / visible,
      );
      _step = (width + 16) * visible;
      _count = math.max(1, (widget.comments.length / visible).ceil());
      final page = _page.clamp(1, _count);
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          Semantics(
            container: true,
            label: widget.labels.title,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scroll,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 16,
                children: [
                  for (final comment in widget.comments)
                    SizedBox(
                      width: width,
                      child: WantCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          spacing: 12,
                          children: [
                            Row(
                              spacing: 12,
                              children: [
                                ExcludeSemantics(
                                  child: Icon(
                                    FLucideIcons.userRound,
                                    color: WantTheme.of(context).color(
                                      comment.own
                                          ? 'primary'
                                          : 'muted-foreground',
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        comment.author,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      if (comment.dateLabel != null)
                                        WantTypography(
                                          comment.dateLabel!,
                                          variant:
                                              WantTypographyVariant.caption,
                                          colorRole: 'muted-foreground',
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              comment.text,
                              maxLines: _expanded.contains(comment.id)
                                  ? null
                                  : 6,
                              overflow: _expanded.contains(comment.id)
                                  ? TextOverflow.visible
                                  : TextOverflow.ellipsis,
                            ),
                            if (comment.text.length > 240 ||
                                comment.text.split('\n').length > 6)
                              WantButton(
                                variant: WantButtonVariant.secondary,
                                onPressed: () => setState(() {
                                  if (!_expanded.add(comment.id)) {
                                    _expanded.remove(comment.id);
                                  }
                                }),
                                child: Text(
                                  _expanded.contains(comment.id)
                                      ? widget.labels.collapse
                                      : widget.labels.readMore,
                                ),
                              ),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final action in comment.actions)
                                  WantButton(
                                    variant: WantButtonVariant.secondary,
                                    onPressed: widget.busy || action.disabled
                                        ? null
                                        : () => widget.onAction(
                                            comment.id,
                                            action.id,
                                          ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 8,
                                      children: [
                                        if (action.icon != null) action.icon!,
                                        Text(action.label),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 16,
            children: [
              WantButton(
                size: WantButtonSize.icon,
                variant: WantButtonVariant.secondary,
                semanticsLabel: widget.labels.previous,
                onPressed: page <= 1 ? null : () => _move(-1),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? FLucideIcons.arrowRight
                      : FLucideIcons.arrowLeft,
                ),
              ),
              Semantics(
                liveRegion: true,
                child: Text(
                  '$page / $_count',
                  textDirection: TextDirection.ltr,
                ),
              ),
              WantButton(
                size: WantButtonSize.icon,
                variant: WantButtonVariant.secondary,
                semanticsLabel: widget.labels.next,
                onPressed: page >= _count ? null : () => _move(1),
                child: Icon(
                  Directionality.of(context) == TextDirection.rtl
                      ? FLucideIcons.arrowLeft
                      : FLucideIcons.arrowRight,
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}
