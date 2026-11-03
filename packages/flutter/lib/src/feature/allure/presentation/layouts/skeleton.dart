import 'package:flutter/widgets.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

class WantSeparator extends StatelessWidget {
  final double space;
  final Axis axis;
  const WantSeparator({
    super.key,
    this.space = 24,
    this.axis = Axis.horizontal,
  });
  @override
  Widget build(BuildContext context) => SizedBox(
    height: axis == Axis.horizontal ? space : null,
    width: axis == Axis.vertical ? space : null,
  );
}

class WantSkeleton extends StatelessWidget {
  final double? width;
  final double height;
  final BorderRadius borderRadius;
  const WantSkeleton({
    super.key,
    this.width,
    this.height = 20,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: WantTheme.of(context).color('secondary'),
        borderRadius: borderRadius,
      ),
    ),
  );
}
