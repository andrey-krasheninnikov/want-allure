import 'package:flutter/widgets.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Mutes descendant tickers when their bounds leave the visible viewport.
class WantViewportMotion extends StatefulWidget {
  final Widget child;
  const WantViewportMotion({super.key, required this.child});
  @override
  State<WantViewportMotion> createState() => _WantViewportMotionState();
}

class _WantViewportMotionState extends State<WantViewportMotion> {
  final _key = UniqueKey();
  bool _visible = false;
  @override
  void dispose() {
    VisibilityDetectorController.instance.forget(_key);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => VisibilityDetector(
    key: _key,
    onVisibilityChanged: (info) {
      final visible = info.visibleFraction > 0;
      if (mounted && visible != _visible) setState(() => _visible = visible);
    },
    child: TickerMode(enabled: _visible, child: widget.child),
  );
}
