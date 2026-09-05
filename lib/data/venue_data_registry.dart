import 'dart:math';

import '../models/venue.dart';
import '../models/venue_map_config.dart';
import '../services/seat_block_generator.dart';
import 'venue_configs/gocheok_block_map.dart';
import 'venue_configs/inspire_block_map.dart';
import 'venue_configs/jamsil_block_map.dart';
import 'venue_configs/kspo_block_map.dart';
import 'venue_configs/olympic_block_map.dart';
import 'venue_configs/venue_configs.dart';
import 'venue_layout.dart';

VenueData venueDataFor(String? venueId) {
  if (venueId == null) return sampleVenue;
  return _cache.putIfAbsent(venueId, () => _buildFromConfig(venueId));
}

final _cache = <String, VenueData>{};

VenueData _buildFromConfig(String venueId) {
  final config = venueMapConfigFor(venueId);
  if (config == null) return sampleVenue;

  final levelGrades = <String, GradeInfo>{};
  final gradePrices = {
    'vip': 176000,
    'fr': 154000,
    'floor': 165000,
    '1f': 143000,
    'r': 132000,
    '2f': 132000,
    's': 110000,
    '3f': 110000,
    'a': 88000,
    '4f': 88000,
    'etc': 66000,
  };
  final gradeColors = {
    'vip': 0xFF9B59B6,
    'fr': 0xFF27AE60,
    'floor': 0xFF7B1FA2,
    '1f': 0xFF388E3C,
    'r': 0xFF2980B9,
    '2f': 0xFF1976D2,
    's': 0xFFE67E22,
    '3f': 0xFFE64A19,
    'a': 0xFF7CB342,
    '4f': 0xFF5D4037,
    'etc': 0xFF95A5A6,
  };
  final gradeLabels = {
    'vip': 'VIP석',
    'fr': 'FR석',
    'floor': 'FLOOR석',
    '1f': '1층석',
    'r': 'R석',
    '2f': '2층석',
    's': 'S석',
    '3f': '3층석',
    'a': 'A석',
    '4f': '4층석',
    'etc': '일반석',
  };

  for (final section in config.sections) {
    levelGrades.putIfAbsent(section.level, () {
      return GradeInfo(
        id: section.level,
        label: gradeLabels[section.level] ?? section.level,
        colorValue: gradeColors[section.level] ?? 0xFF666666,
        price: gradePrices[section.level] ?? 100000,
      );
    });
  }

  final scaleX = 1000.0 / config.viewBoxWidth;
  final scaleY = 850.0 / config.viewBoxHeight;
  final (rawStageCX, rawStageCY) = _stageCenterFromConfig(config);
  final stageCX = rawStageCX * scaleX;
  final stageCY = rawStageCY * scaleY;

  final sections = config.sections.map((s) {
    final normalizedPoly = <double>[];
    for (int i = 0; i < s.polygon.length; i += 2) {
      normalizedPoly.add(s.polygon[i] * scaleX);
      normalizedPoly.add(s.polygon[i + 1] * scaleY);
    }
    List<SectionRowDef> rows;
    final blockMap = switch (venueId) {
      'kspo' => kspoBlockMap,
      'olympic' => olympicBlockMap,
      'inspire' => inspireBlockMap,
      'gocheok' => gocheokBlockMap,
      'jamsil' => jamsilBlockMap,
      _ => null,
    };
    final blockConfig = blockMap?[s.id];
    if (blockConfig != null) {
      rows = generateBlockRows(blockConfig);
    } else {
      rows = _rowsFromShape(normalizedPoly, stageCX, stageCY);
    }

    return VenueSection(
      id: s.id,
      number: s.label,
      gradeId: s.level,
      floor: s.level.toUpperCase(),
      x: 0,
      y: 0,
      w: 0.05,
      h: 0.03,
      rows: rows,
    );
  }).toList();

  final orderedGrades = [
    'vip', 'fr', 'floor', '1f', 'r', '2f', 's', '3f', 'a', '4f', 'etc',
  ].where((l) => levelGrades.containsKey(l))
      .map((l) => levelGrades[l]!)
      .toList();

  return VenueData(
    id: venueId,
    name: config.name,
    grades: orderedGrades,
    sections: sections,
  );
}

(double, double) _stageCenterFromConfig(VenueMapConfig config) {
  for (final d in config.decorations) {
    if (d.label == 'STAGE') {
      final poly = d.polygon;
      final n = poly.length ~/ 2;
      double cx = 0, cy = 0;
      for (int i = 0; i < n; i++) {
        cx += poly[i * 2];
        cy += poly[i * 2 + 1];
      }
      return (cx / n, cy / n);
    }
  }
  return (config.viewBoxWidth / 2, 0);
}

List<SectionRowDef> _rowsFromShape(
    List<double> polygon, double stageCX, double stageCY) {
  final n = polygon.length ~/ 2;
  if (n < 3) return [];

  // 1. Centroid
  double cx = 0, cy = 0;
  for (int i = 0; i < n; i++) {
    cx += polygon[i * 2];
    cy += polygon[i * 2 + 1];
  }
  cx /= n;
  cy /= n;

  // 2. Depth axis: centroid → away from stage
  final awayX = cx - stageCX;
  final awayY = cy - stageCY;
  final dist = sqrt(awayX * awayX + awayY * awayY);
  if (dist < 0.1) return [];
  final depthX = awayX / dist;
  final depthY = awayY / dist;
  final widthX = -depthY;
  final widthY = depthX;

  // 3. Project polygon onto depth/width axes
  final dProj = List<double>.filled(n, 0);
  final wProj = List<double>.filled(n, 0);
  for (int i = 0; i < n; i++) {
    final px = polygon[i * 2] - cx;
    final py = polygon[i * 2 + 1] - cy;
    dProj[i] = px * depthX + py * depthY;
    wProj[i] = px * widthX + py * widthY;
  }

  final minD = dProj.reduce(min);
  final maxD = dProj.reduce(max);
  final depth = maxD - minD;
  if (depth < 1) return [];

  // 4. Scanline width at a given depth fraction (0=front/stage, 1=back)
  double widthAt(double fraction) {
    final d = minD + depth * fraction;
    final ws = <double>[];
    for (int i = 0; i < n; i++) {
      final j = (i + 1) % n;
      final d1 = dProj[i], d2 = dProj[j];
      if ((d1 <= d && d2 > d) || (d2 <= d && d1 > d)) {
        final t = (d - d1) / (d2 - d1);
        ws.add(wProj[i] + t * (wProj[j] - wProj[i]));
      }
    }
    if (ws.length < 2) return 0;
    ws.sort();
    return ws.last - ws.first;
  }

  final frontW = widthAt(0.15);
  final backW = widthAt(0.85);
  final maxW = max(frontW, backW);
  if (maxW < 1) return [];

  // 5. Row count from depth
  int rowCount;
  if (depth < 50) {
    rowCount = 6;
  } else if (depth < 70) {
    rowCount = 8;
  } else if (depth < 95) {
    rowCount = 12;
  } else if (depth < 130) {
    rowCount = 16;
  } else {
    rowCount = 20;
  }

  // 6. Max seat count from max width
  int maxSeats;
  if (maxW < 40) {
    maxSeats = 8;
  } else if (maxW < 55) {
    maxSeats = 12;
  } else if (maxW < 70) {
    maxSeats = 16;
  } else if (maxW < 90) {
    maxSeats = 20;
  } else if (maxW < 120) {
    maxSeats = 26;
  } else {
    maxSeats = 32;
  }

  // 7. Front/back seat count from width ratio
  final frontSeats = max(4, (maxSeats * (frontW / maxW)).round());
  final backSeats = max(4, (maxSeats * (backW / maxW)).round());

  // 8. Linear interpolation + center alignment
  return List.generate(rowCount, (i) {
    final t = rowCount > 1 ? i / (rowCount - 1) : 0.5;
    final seats = max(4, (frontSeats + (backSeats - frontSeats) * t).round());
    final offset = ((maxSeats - seats) / 2).round();
    return SectionRowDef(
      rowNumber: i + 1,
      seatCount: seats,
      startOffset: max(0, offset),
    );
  });
}

