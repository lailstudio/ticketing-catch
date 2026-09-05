import 'package:flutter/material.dart';

class VenueImage extends StatelessWidget {
  final String venueId;
  final String? imageAsset;
  final String? semanticLabel;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const VenueImage({
    super.key,
    required this.venueId,
    this.imageAsset,
    this.semanticLabel,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  static const _gradientColors = <String, List<Color>>{
    'gocheok': [Color(0xFF3F51B5), Color(0xFF283593)],
    'kspo': [Color(0xFF1E88E5), Color(0xFF1565C0)],
    'jamsil': [Color(0xFF00897B), Color(0xFF00695C)],
    'inspire': [Color(0xFF7B1FA2), Color(0xFF4A148C)],
    'olympic': [Color(0xFF5C6BC0), Color(0xFF3949AB)],
  };

  static const _defaultGradient = [Color(0xFF9575CD), Color(0xFF7E57C2)];

  static const _venueIcons = <String, IconData>{
    'gocheok': Icons.stadium,
    'kspo': Icons.sports_gymnastics,
    'jamsil': Icons.sports_basketball,
    'inspire': Icons.auto_awesome,
    'olympic': Icons.music_note,
  };

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (imageAsset != null) {
      child = Image.asset(
        imageAsset!,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      child = Semantics(
        image: true,
        label: semanticLabel,
        excludeSemantics: true,
        child: _buildPlaceholder(),
      );
    }

    if (borderRadius != null) {
      child = ClipRRect(
        borderRadius: borderRadius!,
        child: child,
      );
    }

    return child;
  }

  Widget _buildPlaceholder() {
    final colors = _gradientColors[venueId] ?? _defaultGradient;
    final icon = _venueIcons[venueId] ?? Icons.location_city;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        ),
      ),
      child: Center(
        child: Icon(
          icon,
          size: (height ?? 200) * 0.3,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
