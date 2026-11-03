import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';

import 'package:want_allure/src/feature/allure/presentation/_barrel.dart';

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
