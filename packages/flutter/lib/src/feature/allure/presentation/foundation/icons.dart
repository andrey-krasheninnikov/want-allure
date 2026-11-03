import 'package:flutter/widgets.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

/// Semantic icons shared by Want controls.
@staticIconProvider
abstract final class WantIcons {
  static const arrowDown = PhosphorIconsRegular.arrowDown;
  static const arrowLeft = PhosphorIconsRegular.arrowLeft;
  static const arrowRight = PhosphorIconsRegular.arrowRight;
  static const arrowUp = PhosphorIconsRegular.arrowUp;
  static const arrowUpRight = PhosphorIconsRegular.arrowUpRight;
  static const chevronLeft = PhosphorIconsRegular.caretLeft;
  static const chevronRight = PhosphorIconsRegular.caretRight;
  static const chevronDown = PhosphorIconsRegular.caretDown;
  static const circleCheck = PhosphorIconsRegular.checkCircle;
  static const circleX = PhosphorIconsRegular.xCircle;
  static const download = PhosphorIconsRegular.downloadSimple;
  static const eye = PhosphorIconsRegular.eye;
  static const eyeClosed = PhosphorIconsRegular.eyeClosed;
  static const file = PhosphorIconsRegular.file;
  static const info = PhosphorIconsRegular.info;
  static const question = PhosphorIconsRegular.question;
  static const link = PhosphorIconsRegular.link;
  static const moon = PhosphorIconsRegular.moon;
  static const sun = PhosphorIconsRegular.sun;
  static const triangleAlert = PhosphorIconsRegular.warning;
  static const userRound = PhosphorIconsRegular.userCircle;
  static const x = PhosphorIconsRegular.x;
  static const search = PhosphorIconsRegular.magnifyingGlass;
  static const image = PhosphorIconsRegular.image;
  static const pause = PhosphorIconsRegular.pause;
  static const play = PhosphorIconsRegular.play;
  static const success = PhosphorIconsRegular.check;
  static const error = PhosphorIconsRegular.x;
  static const warning = PhosphorIconsRegular.warning;
  static const information = PhosphorIconsRegular.info;
}

/// Renders regular and duotone Want icons with the surrounding icon theme.
class WantIcon extends StatelessWidget {
  final Object icon;
  final double? size;
  final Color? color;
  final String? semanticLabel;
  const WantIcon(
    this.icon, {
    super.key,
    this.size,
    this.color,
    this.semanticLabel,
  });
  @override
  Widget build(BuildContext context) => PhosphorIcon(
    icon,
    size: size,
    color: color,
    semanticLabel: semanticLabel,
    duotoneSecondaryOpacity: .22,
  );
}
