import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:sprung/sprung.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
        duration: const Duration(milliseconds: 380),
        curve: Sprung.criticallyDamped,
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
              physics: _CommentPagePhysics(step: _step),
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
                                    WantIcons.userRound,
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
                child: Icon(WantIcons.arrowLeft),
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
                child: Icon(WantIcons.arrowRight),
              ),
            ],
          ),
        ],
      );
    },
  );
}

class _CommentPagePhysics extends ScrollPhysics {
  final double step;
  const _CommentPagePhysics({required this.step, super.parent});
  @override
  _CommentPagePhysics applyTo(ScrollPhysics? ancestor) =>
      _CommentPagePhysics(step: step, parent: buildParent(ancestor));
  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    if ((velocity <= 0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }
    final tolerance = toleranceFor(position);
    var page = position.pixels / step;
    if (velocity.abs() > tolerance.velocity) page += velocity.sign * .5;
    final target = (page.round() * step).clamp(
      position.minScrollExtent,
      position.maxScrollExtent,
    );
    if (target == position.pixels) return null;
    return ScrollSpringSimulation(
      spring,
      position.pixels,
      target,
      velocity,
      tolerance: tolerance,
    );
  }
}
