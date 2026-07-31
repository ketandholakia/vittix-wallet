import 'package:flutter/material.dart';

class BrandLogo extends StatelessWidget {
  final double size;
  final bool showWordmark;
  final Color? backgroundColor;

  const BrandLogo({
    super.key,
    this.size = 96,
    this.showWordmark = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outline.withValues(alpha: 0.2);
    final bg = backgroundColor ?? Theme.of(context).colorScheme.surface.withValues(alpha: 0.04);

    if (showWordmark) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LogoTile(size: size, backgroundColor: bg, borderColor: borderColor),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'VITTIX',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.2,
                    ),
              ),
              Text(
                'WALLET',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 6,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        ],
      );
    }

    return _LogoTile(size: size, backgroundColor: bg, borderColor: borderColor);
  }
}

class _LogoTile extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final Color borderColor;

  const _LogoTile({
    required this.size,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.18),
        child: Image.asset(
          'assets/branding/vittix_logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
