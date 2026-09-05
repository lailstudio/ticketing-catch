import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../data/venue_map_helpers.dart';
import '../models/venue_map_config.dart';

class VenueMapRenderer extends StatefulWidget {
  final VenueMapConfig config;
  final void Function(String sectionId)? onSectionTap;
  final bool debugHitAreas;

  const VenueMapRenderer({
    super.key,
    required this.config,
    this.onSectionTap,
    this.debugHitAreas = false,
  });

  @override
  State<VenueMapRenderer> createState() => _VenueMapRendererState();
}

class _VenueMapRendererState extends State<VenueMapRenderer> {
  String? _hoveredId;
  Map<String, Offset>? _labelCenters;
  List<Offset>? _entryCenters;

  void _computeCenters() {
    final labels = <String, Offset>{};
    final entries = <Offset>[];

    for (final section in widget.config.sections) {
      final displayPoly = _insetPolygon(section.polygon, 0.96);
      final vc = _polylabel(displayPoly);
      final center = Offset(
        vc.dx + section.labelDx,
        vc.dy + section.labelDy,
      );
      labels[section.id] = center;
      entries.add(center);
    }
    for (final deco in widget.config.decorations) {
      if (deco.label != null) {
        labels['__deco_${deco.label}'] = _polylabel(deco.polygon);
      }
    }

    _labelCenters = labels;
    _entryCenters = entries;
  }

  Map<String, Offset> _getLabelCenters() {
    if (_labelCenters == null) _computeCenters();
    return _labelCenters!;
  }

  List<Offset> _getEntryCenters() {
    if (_entryCenters == null) _computeCenters();
    return _entryCenters!;
  }

  @override
  void didUpdateWidget(covariant VenueMapRenderer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.config != widget.config) {
      _labelCenters = null;
      _entryCenters = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.config.imageAsset != null) {
      return _buildImageMode();
    }
    return _buildPolygonMode();
  }

  // ─── Image-based rendering ───

  Widget _buildImageMode() {
    final vw = widget.config.viewBoxWidth;
    final vh = widget.config.viewBoxHeight;

    return SizedBox(
      width: vw,
      height: vh,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              widget.config.imageAsset!,
              fit: BoxFit.fill,
            ),
          ),
          Positioned.fill(
            child: MouseRegion(
              onHover: (event) => _onPointerMove(event.localPosition, vw, vh),
              onExit: (_) {
                if (_hoveredId != null) setState(() => _hoveredId = null);
              },
              child: GestureDetector(
                onTapUp: (details) {
                  final id = _hitTest(details.localPosition, vw, vh);
                  if (id != null) widget.onSectionTap?.call(id);
                },
                child: CustomPaint(
                  painter: _ImageOverlayPainter(
                    config: widget.config,
                    hoveredId: _hoveredId,
                    debugHitAreas: widget.debugHitAreas,
                    labelCenters: _getLabelCenters(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Polygon-based rendering (existing) ───

  Widget _buildPolygonMode() {
    final vw = widget.config.viewBoxWidth;
    final vh = widget.config.viewBoxHeight;

    return MouseRegion(
      onHover: (event) => _onPointerMove(event.localPosition, vw, vh),
      onExit: (_) {
        if (_hoveredId != null) setState(() => _hoveredId = null);
      },
      child: GestureDetector(
        onTapUp: (details) {
          final id = _hitTest(details.localPosition, vw, vh);
          if (id != null) widget.onSectionTap?.call(id);
        },
        child: CustomPaint(
          painter: _VenueMapPainter(
            config: widget.config,
            hoveredId: _hoveredId,
            labelCenters: _getLabelCenters(),
            entryCenters: _getEntryCenters(),
          ),
          size: Size(vw, vh),
        ),
      ),
    );
  }

  // ─── Shared hit testing ───

  void _onPointerMove(Offset pos, double vw, double vh) {
    final id = _hitTest(pos, vw, vh);
    if (id != _hoveredId) setState(() => _hoveredId = id);
  }

  String? _hitTest(Offset pos, double vw, double vh) {
    final useInset = widget.config.imageAsset == null;
    for (final section in widget.config.sections.reversed) {
      final poly = useInset
          ? _insetPolygon(section.polygon, 0.96)
          : section.polygon;
      final path = _polygonPath(poly);
      if (path.contains(pos)) return section.id;
    }
    return null;
  }
}

// ─── Image overlay painter (hover highlight only) ───

class _ImageOverlayPainter extends CustomPainter {
  final VenueMapConfig config;
  final String? hoveredId;
  final bool debugHitAreas;
  final Map<String, Offset> labelCenters;

  _ImageOverlayPainter({
    required this.config,
    this.hoveredId,
    this.debugHitAreas = false,
    required this.labelCenters,
  });

  static const _debugColors = [
    Color(0x40FF0000),
    Color(0x400000FF),
    Color(0x4000CC00),
    Color(0x40FF8800),
    Color(0x40CC00CC),
    Color(0x4000CCCC),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    if (debugHitAreas) {
      for (int i = 0; i < config.sections.length; i++) {
        final section = config.sections[i];
        final path = _polygonPath(section.polygon);
        final color = _debugColors[i % _debugColors.length];

        canvas.drawPath(path, Paint()
          ..color = color
          ..style = PaintingStyle.fill);
        canvas.drawPath(path, Paint()
          ..color = const Color(0xCC000000)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);

        final center = labelCenters[section.id] ?? _polygonCenter(section.polygon);
        final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
          textAlign: TextAlign.center,
          maxLines: 1,
        ))
          ..pushStyle(ui.TextStyle(
            color: const Color(0xFF000000),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ))
          ..addText(section.id);
        const boxW = 80.0;
        final paragraph = builder.build()
          ..layout(const ui.ParagraphConstraints(width: boxW));
        canvas.drawParagraph(
          paragraph,
          Offset(center.dx - boxW / 2,
              center.dy - paragraph.height / 2),
        );
      }
      return;
    }

    if (hoveredId == null) return;

    MapSection? hovered;
    for (final s in config.sections) {
      if (s.id == hoveredId) {
        hovered = s;
        break;
      }
    }
    if (hovered == null) return;

    final path = _polygonPath(hovered.polygon);

    canvas.drawPath(path, Paint()
      ..color = const Color(0x22000000)
      ..style = PaintingStyle.fill);
    canvas.drawPath(path, Paint()
      ..color = const Color(0x66333333)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5);
  }

  @override
  bool shouldRepaint(covariant _ImageOverlayPainter oldDelegate) =>
      oldDelegate.hoveredId != hoveredId ||
      oldDelegate.debugHitAreas != debugHitAreas;
}

// ─── Shared geometry helpers ───

Path _polygonPath(List<double> points) {
  final path = Path();
  for (int i = 0; i < points.length; i += 2) {
    if (i == 0) {
      path.moveTo(points[i], points[i + 1]);
    } else {
      path.lineTo(points[i], points[i + 1]);
    }
  }
  path.close();
  return path;
}

Offset _polygonCenter(List<double> points) {
  double cx = 0, cy = 0;
  final n = points.length ~/ 2;
  for (int i = 0; i < points.length; i += 2) {
    cx += points[i];
    cy += points[i + 1];
  }
  return Offset(cx / n, cy / n);
}

Offset _geometricCentroid(List<double> points) {
  final n = points.length ~/ 2;
  if (n < 3) return _polygonCenter(points);
  double area = 0, cx = 0, cy = 0;
  for (int i = 0; i < n; i++) {
    final j = (i + 1) % n;
    final xi = points[i * 2], yi = points[i * 2 + 1];
    final xj = points[j * 2], yj = points[j * 2 + 1];
    final cross = xi * yj - xj * yi;
    area += cross;
    cx += (xi + xj) * cross;
    cy += (yi + yj) * cross;
  }
  area *= 0.5;
  if (area.abs() < 1e-10) return _polygonCenter(points);
  return Offset(cx / (6 * area), cy / (6 * area));
}

List<double> _insetPolygon(List<double> points, double factor) {
  final center = _polygonCenter(points);
  final result = <double>[];
  for (int i = 0; i < points.length; i += 2) {
    result.add(center.dx + (points[i] - center.dx) * factor);
    result.add(center.dy + (points[i + 1] - center.dy) * factor);
  }
  return result;
}

// ─── Polylabel: visual center (pole of inaccessibility) ───

Offset _polylabel(List<double> points, {double precision = 2.0}) {
  final n = points.length ~/ 2;
  if (n < 3) return _polygonCenter(points);

  double minX = double.infinity, minY = double.infinity;
  double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
  for (int i = 0; i < n; i++) {
    final x = points[i * 2], y = points[i * 2 + 1];
    minX = math.min(minX, x);
    minY = math.min(minY, y);
    maxX = math.max(maxX, x);
    maxY = math.max(maxY, y);
  }

  final width = maxX - minX;
  final height = maxY - minY;
  final cellSize = math.min(width, height);
  if (cellSize < 1e-6) return Offset((minX + maxX) / 2, (minY + maxY) / 2);

  final h0 = cellSize / 2.0;

  final queue = <_PCell>[];
  for (var x = minX; x < maxX; x += cellSize) {
    for (var y = minY; y < maxY; y += cellSize) {
      queue.add(_PCell(x + h0, y + h0, h0, points));
    }
  }

  final centroid = _geometricCentroid(points);
  var best = _PCell(centroid.dx, centroid.dy, 0, points);

  final bboxCenter = _PCell(
      (minX + maxX) / 2, (minY + maxY) / 2, 0, points);
  if (bboxCenter.dist > best.dist) best = bboxCenter;

  while (queue.isNotEmpty) {
    var maxIdx = 0;
    for (int i = 1; i < queue.length; i++) {
      if (queue[i].potential > queue[maxIdx].potential) maxIdx = i;
    }
    final cell = queue.removeAt(maxIdx);

    if (cell.dist > best.dist) best = cell;
    if (cell.potential - best.dist <= precision) continue;

    final h = cell.h / 2;
    queue.add(_PCell(cell.x - h, cell.y - h, h, points));
    queue.add(_PCell(cell.x + h, cell.y - h, h, points));
    queue.add(_PCell(cell.x - h, cell.y + h, h, points));
    queue.add(_PCell(cell.x + h, cell.y + h, h, points));
  }

  return Offset(best.x, best.y);
}

class _PCell {
  final double x, y, h;
  final double dist;
  final double potential;

  _PCell(this.x, this.y, this.h, List<double> polygon)
      : dist = _signedDist(x, y, polygon),
        potential = _signedDist(x, y, polygon) + h * math.sqrt2;
}

double _signedDist(double px, double py, List<double> polygon) {
  final n = polygon.length ~/ 2;
  bool inside = false;
  double minDistSq = double.infinity;

  for (int i = 0, j = n - 1; i < n; j = i++) {
    final xi = polygon[i * 2], yi = polygon[i * 2 + 1];
    final xj = polygon[j * 2], yj = polygon[j * 2 + 1];

    if ((yi > py) != (yj > py) &&
        px < (xj - xi) * (py - yi) / (yj - yi) + xi) {
      inside = !inside;
    }

    var ax = xi, ay = yi;
    final dx = xj - xi, dy = yj - yi;
    final lenSq = dx * dx + dy * dy;
    if (lenSq > 0) {
      final t = ((px - xi) * dx + (py - yi) * dy) / lenSq;
      if (t > 1) {
        ax = xj;
        ay = yj;
      } else if (t > 0) {
        ax = xi + t * dx;
        ay = yi + t * dy;
      }
    }
    final ddx = px - ax, ddy = py - ay;
    minDistSq = math.min(minDistSq, ddx * ddx + ddy * ddy);
  }

  return (inside ? 1 : -1) * math.sqrt(minDistSq);
}

// ─── Polygon-mode painter ───

class _VenueMapPainter extends CustomPainter {
  final VenueMapConfig config;
  final String? hoveredId;
  final Map<String, Offset> labelCenters;
  final List<Offset> entryCenters;

  _VenueMapPainter({
    required this.config,
    this.hoveredId,
    required this.labelCenters,
    required this.entryCenters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawDecorations(canvas);
    _drawLabelDecorations(canvas);
    _drawSections(canvas);
    _drawGateDecorations(canvas);
  }

  void _drawDecorations(Canvas canvas) {
    for (final deco in config.decorations) {
      final path = _polygonPath(deco.polygon);
      final paint = Paint()
        ..color = deco.color
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, paint);

      if (deco.label != null) {
        final center = labelCenters['__deco_${deco.label}']
            ?? _polygonCenter(deco.polygon);
        _drawLabelAt(canvas, center, deco.label!, deco.fontSize,
            color: const Color(0xFFFFFFFF));
      }
    }
  }

  void _drawLabelDecorations(Canvas canvas) {
    for (final ld in config.labelDecorations) {
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(ld.cx, ld.cy),
          width: ld.width,
          height: ld.height,
        ),
        Radius.circular(ld.borderRadius),
      );
      canvas.drawRRect(rect, Paint()..color = Color(ld.backgroundColorValue));
      _drawLabelAt(
        canvas,
        Offset(ld.cx, ld.cy),
        ld.label,
        ld.fontSize,
        color: Color(ld.textColorValue),
        bold: true,
      );
    }
  }

  void _drawGateDecorations(Canvas canvas) {
    for (final gate in config.gateDecorations) {
      canvas.save();
      canvas.translate(gate.cx, gate.cy);
      canvas.rotate(gate.rotation);

      final rrect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: gate.width,
          height: gate.height,
        ),
        Radius.circular(gate.borderRadius),
      );
      canvas.drawRRect(
        rrect,
        Paint()..color = Color(gate.backgroundColorValue),
      );

      _drawLabelAt(
        canvas,
        Offset.zero,
        gate.label,
        gate.fontSize,
        color: Color(gate.textColorValue),
        bold: true,
      );

      canvas.restore();
    }
  }

  void _drawSections(Canvas canvas) {
    for (int i = 0; i < config.sections.length; i++) {
      final section = config.sections[i];
      final isHovered = section.id == hoveredId;
      final baseColor = section.grade?.color
          ?? Color(colorForRole(section.colorRole));
      final displayPoly = _insetPolygon(section.polygon, 0.96);
      final path = _polygonPath(displayPoly);

      final fillPaint = Paint()
        ..color = isHovered ? _brighten(baseColor, 0.12) : baseColor
        ..style = PaintingStyle.fill;
      canvas.drawPath(path, fillPaint);

      final borderPaint = Paint()
        ..color = isHovered
            ? const Color(0xFF22252A)
            : const Color(0xFFE2E4E7)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isHovered ? 2.5 : 1.2;
      canvas.drawPath(path, borderPaint);

      final center = i < entryCenters.length
          ? entryCenters[i]
          : labelCenters[section.id] ?? _polygonCenter(displayPoly);
      _drawLabelAt(canvas, center, section.label, _labelSize(section),
          color: const Color(0xFF22252A), bold: true);
    }
  }

  static const _sectionLabelScale = 1.12;

  double _labelSize(MapSection section) {
    final bounds = _polygonPath(section.polygon).getBounds();
    final minDim = bounds.width < bounds.height ? bounds.width : bounds.height;
    double base;
    if (minDim < 25) {
      base = 9;
    } else if (minDim < 40) {
      base = 11;
    } else if (minDim < 60) {
      base = 13;
    } else if (minDim < 90) {
      base = 15;
    } else {
      base = 18;
    }
    return base * _sectionLabelScale;
  }

  void _drawLabelAt(
      Canvas canvas, Offset center, String text, double fontSize,
      {Color color = Colors.black, bool bold = false}) {
    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      maxLines: 1,
    ))
      ..pushStyle(ui.TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
      ))
      ..addText(text);
    const boxWidth = 120.0;
    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: boxWidth));
    final ph = paragraph.height;
    canvas.drawParagraph(
      paragraph,
      Offset(center.dx - boxWidth / 2, center.dy - ph / 2),
    );
  }

  Color _brighten(Color c, double amount) {
    final hsl = HSLColor.fromColor(c);
    return hsl
        .withLightness((hsl.lightness + amount).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  bool shouldRepaint(covariant _VenueMapPainter oldDelegate) =>
      oldDelegate.hoveredId != hoveredId || oldDelegate.config != config;
}
