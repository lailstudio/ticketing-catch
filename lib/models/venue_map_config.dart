import 'dart:ui';

import 'seat_grade.dart';

class VenueMapConfig {
  final String id;
  final String name;
  final double viewBoxWidth;
  final double viewBoxHeight;
  final String? imageAsset;
  final List<MapDecoration> decorations;
  final List<MapLabelDecoration> labelDecorations;
  final List<MapGateDecoration> gateDecorations;
  final List<MapLegendEntry> legendEntries;
  final List<MapSection> sections;

  const VenueMapConfig({
    required this.id,
    required this.name,
    required this.viewBoxWidth,
    required this.viewBoxHeight,
    this.imageAsset,
    this.decorations = const [],
    this.labelDecorations = const [],
    this.gateDecorations = const [],
    this.legendEntries = const [],
    this.sections = const [],
  });
}

class MapDecoration {
  final List<double> polygon;
  final int colorValue;
  final String? label;
  final double fontSize;

  const MapDecoration({
    required this.polygon,
    required this.colorValue,
    this.label,
    this.fontSize = 12,
  });

  Color get color => Color(colorValue);
}

class MapLabelDecoration {
  final double cx;
  final double cy;
  final double width;
  final double height;
  final double borderRadius;
  final int backgroundColorValue;
  final int textColorValue;
  final String label;
  final double fontSize;

  const MapLabelDecoration({
    required this.cx,
    required this.cy,
    required this.width,
    required this.height,
    this.borderRadius = 12,
    required this.backgroundColorValue,
    required this.textColorValue,
    required this.label,
    this.fontSize = 12,
  });
}

class MapGateDecoration {
  final double cx;
  final double cy;
  final double width;
  final double height;
  final double borderRadius;
  final double rotation;
  final int backgroundColorValue;
  final int textColorValue;
  final String label;
  final double fontSize;

  const MapGateDecoration({
    required this.cx,
    required this.cy,
    required this.width,
    required this.height,
    this.borderRadius = 13,
    this.rotation = 0,
    required this.backgroundColorValue,
    required this.textColorValue,
    required this.label,
    this.fontSize = 11,
  });
}

class MapLegendEntry {
  final String label;
  final int colorValue;

  const MapLegendEntry({
    required this.label,
    required this.colorValue,
  });
}

class MapSection {
  final String id;
  final String label;
  final String level;
  final String colorRole;
  final SeatGrade? grade;
  final List<double> polygon;
  final double labelDx;
  final double labelDy;

  const MapSection({
    required this.id,
    required this.label,
    required this.level,
    this.colorRole = '',
    this.grade,
    required this.polygon,
    this.labelDx = 0,
    this.labelDy = 0,
  });
}
