import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
