import 'package:flutter/widgets.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

/// Semantic icons shared by Want controls.
@staticIconProvider
abstract final class WantIcons {
  static const lock = PhosphorIconsRegular.lock;
  static const list = PhosphorIconsRegular.list;
  static const copy = PhosphorIconsRegular.copy;
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
  static const monitor = PhosphorIconsRegular.monitor;
  static const moon = PhosphorIconsRegular.moon;
  static const sun = PhosphorIconsRegular.sun;
  static const triangleAlert = PhosphorIconsRegular.warning;
  static const userRound = PhosphorIconsRegular.userCircle;
  static const x = PhosphorIconsRegular.x;
  static const search = PhosphorIconsRegular.magnifyingGlass;
  static const image = PhosphorIconsRegular.image;
  static const pause = PhosphorIconsRegular.pause;
  static const play = PhosphorIconsRegular.play;
  static const star = PhosphorIconsRegular.star;
  static const heart = PhosphorIconsRegular.heart;
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
    this.role,
  });
  final String? role;
  static final _roles = <IconData, String>{
    WantIcons.lock: 'lock',
    WantIcons.list: 'list',
    WantIcons.copy: 'copy',
    WantIcons.arrowDown: 'arrowDown',
    WantIcons.arrowLeft: 'arrowLeft',
    WantIcons.arrowRight: 'arrowRight',
    WantIcons.arrowUp: 'arrowUp',
    WantIcons.arrowUpRight: 'arrowUpRight',
    WantIcons.chevronLeft: 'chevronLeft',
    WantIcons.chevronRight: 'chevronRight',
    WantIcons.chevronDown: 'chevronDown',
    WantIcons.circleCheck: 'circleCheck',
    WantIcons.circleX: 'circleX',
    WantIcons.download: 'download',
    WantIcons.eye: 'eye',
    WantIcons.eyeClosed: 'eyeClosed',
    WantIcons.file: 'file',
    WantIcons.info: 'info',
    WantIcons.question: 'question',
    WantIcons.link: 'link',
    WantIcons.monitor: 'monitor',
    WantIcons.moon: 'moon',
    WantIcons.sun: 'sun',
    WantIcons.triangleAlert: 'triangleAlert',
    WantIcons.userRound: 'userRound',
    WantIcons.x: 'x',
    WantIcons.search: 'search',
    WantIcons.image: 'image',
    WantIcons.pause: 'pause',
    WantIcons.play: 'play',
    WantIcons.success: 'confirm',
    WantIcons.star: 'star',
    WantIcons.heart: 'heart',
  };
  static final _families = <IconData, List<Object>>{
    WantIcons.arrowDown: const [
      PhosphorIconsBold.arrowDown,
      PhosphorIconsThin.arrowDown,
      PhosphorIconsLight.arrowDown,
      PhosphorIconsDuotone.arrowDown,
      PhosphorIconsBold.arrowFatDown,
    ],
    WantIcons.arrowUp: const [
      PhosphorIconsBold.arrowUp,
      PhosphorIconsThin.arrowUp,
      PhosphorIconsLight.arrowUp,
      PhosphorIconsDuotone.arrowUp,
      PhosphorIconsBold.arrowFatUp,
    ],
    WantIcons.arrowLeft: const [
      PhosphorIconsBold.arrowLeft,
      PhosphorIconsThin.arrowLeft,
      PhosphorIconsLight.arrowLeft,
      PhosphorIconsDuotone.arrowLeft,
      PhosphorIconsBold.arrowFatLeft,
    ],
    WantIcons.arrowRight: const [
      PhosphorIconsBold.arrowRight,
      PhosphorIconsThin.arrowRight,
      PhosphorIconsLight.arrowRight,
      PhosphorIconsDuotone.arrowRight,
      PhosphorIconsBold.arrowFatRight,
    ],
    WantIcons.chevronLeft: const [
      PhosphorIconsBold.caretLeft,
      PhosphorIconsThin.caretLeft,
      PhosphorIconsLight.caretLeft,
      PhosphorIconsDuotone.caretLeft,
      PhosphorIconsBold.caretLeft,
    ],
    WantIcons.chevronRight: const [
      PhosphorIconsBold.caretRight,
      PhosphorIconsThin.caretRight,
      PhosphorIconsLight.caretRight,
      PhosphorIconsDuotone.caretRight,
      PhosphorIconsBold.caretRight,
    ],
    WantIcons.chevronDown: const [
      PhosphorIconsBold.caretDown,
      PhosphorIconsThin.caretDown,
      PhosphorIconsLight.caretDown,
      PhosphorIconsDuotone.caretDown,
      PhosphorIconsBold.caretDown,
    ],
    WantIcons.circleCheck: const [
      PhosphorIconsBold.checkCircle,
      PhosphorIconsThin.checkCircle,
      PhosphorIconsLight.checkCircle,
      PhosphorIconsDuotone.checkCircle,
      PhosphorIconsBold.checkSquare,
    ],
    WantIcons.success: const [
      PhosphorIconsBold.check,
      PhosphorIconsThin.check,
      PhosphorIconsLight.check,
      PhosphorIconsDuotone.check,
      PhosphorIconsBold.checkSquare,
    ],
    WantIcons.x: const [
      PhosphorIconsBold.x,
      PhosphorIconsThin.x,
      PhosphorIconsLight.x,
      PhosphorIconsDuotone.x,
      PhosphorIconsBold.xSquare,
    ],
    WantIcons.warning: const [
      PhosphorIconsBold.warning,
      PhosphorIconsThin.warning,
      PhosphorIconsLight.warning,
      PhosphorIconsDuotone.warning,
      PhosphorIconsBold.warningOctagon,
    ],
    WantIcons.info: const [
      PhosphorIconsBold.info,
      PhosphorIconsThin.info,
      PhosphorIconsLight.info,
      PhosphorIconsDuotone.info,
      PhosphorIconsBold.info,
    ],
    WantIcons.sun: const [
      PhosphorIconsBold.sun,
      PhosphorIconsThin.sun,
      PhosphorIconsLight.sun,
      PhosphorIconsDuotone.sun,
      PhosphorIconsBold.sun,
    ],
    WantIcons.moon: const [
      PhosphorIconsBold.moon,
      PhosphorIconsThin.moon,
      PhosphorIconsLight.moon,
      PhosphorIconsDuotone.moon,
      PhosphorIconsBold.moon,
    ],
    WantIcons.monitor: const [
      PhosphorIconsBold.monitor,
      PhosphorIconsThin.monitor,
      PhosphorIconsLight.monitor,
      PhosphorIconsDuotone.monitor,
      PhosphorIconsBold.monitor,
    ],
    WantIcons.search: const [
      PhosphorIconsBold.magnifyingGlass,
      PhosphorIconsThin.magnifyingGlass,
      PhosphorIconsLight.magnifyingGlass,
      PhosphorIconsDuotone.magnifyingGlass,
      PhosphorIconsBold.magnifyingGlass,
    ],
  };

  @override
  Widget build(BuildContext context) {
    final preset =
        WantTheme.maybeOf(context)?.typographyPreset ??
        WantTypographyPreset.brand;
    final theme = WantTheme.maybeOf(context);
    final alias = theme?.profile.icons[role ?? _roles[icon]];
    final override = theme?.resources.icons[alias];
    final family = _families[icon];
    return PhosphorIcon(
      override ??
          (family == null || preset == WantTypographyPreset.brand
              ? icon
              : family[preset.index - 1]),
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      duotoneSecondaryOpacity: .22,
    );
  }
}
