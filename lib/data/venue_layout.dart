import 'dart:math';

import '../models/venue.dart';

final sampleVenue = _buildSampleVenue();

VenueData _buildSampleVenue() {
  return VenueData(
    id: 'goyang',
    name: '고양종합운동장',
    grades: const [
      GradeInfo(
          id: 'VIP',
          label: 'VIP석(들꽃석)',
          colorValue: 0xFF7B1FA2,
          price: 165000),
      GradeInfo(
          id: 'R',
          label: 'R석(무지개석)',
          colorValue: 0xFF388E3C,
          price: 143000),
      GradeInfo(
          id: 'S',
          label: 'S석(별빛석)',
          colorValue: 0xFF1976D2,
          price: 132000),
    ],
    sections: [
      ..._floorSections(),
      ..._leftSideSections(),
      ..._leftESections(),
      ..._centerESections(),
      ..._centerLowerESections(),
      ..._rightESections(),
      ..._rightSideSections(),
      ..._fourFRow1Sections(),
      ..._fourFRow2Sections(),
      ..._fourFRow3Sections(),
    ],
  );
}

// ─── Row templates ───

List<SectionRowDef> _floorRowDefs() {
  return List.generate(20, (i) {
    final n = i + 1;
    final count = n <= 5 ? 28 : (n <= 12 ? 30 : 32);
    return SectionRowDef(rowNumber: n, seatCount: count);
  });
}

List<SectionRowDef> _sideRowDefs() {
  return List.generate(15, (i) {
    final n = i + 1;
    final count = n <= 5 ? 20 : (n <= 10 ? 22 : 24);
    return SectionRowDef(rowNumber: n, seatCount: count);
  });
}

List<SectionRowDef> _twoFERowDefs() {
  return List.generate(18, (i) {
    final n = i + 1;
    final count = n <= 4 ? 25 : (n <= 12 ? 28 : 30);
    return SectionRowDef(rowNumber: n, seatCount: count);
  });
}

List<SectionRowDef> _fourFRowDefs() {
  return List.generate(22, (i) {
    final n = i + 1;
    final count = n <= 6 ? 30 : (n <= 14 ? 34 : 36);
    return SectionRowDef(rowNumber: n, seatCount: count);
  });
}

// ─── FLOOR (F1-F20, R grade, green) ───

List<VenueSection> _floorSections() {
  const blockW = 0.048;
  const blockH = 0.028;
  const stride = 0.056;
  const startX = 0.224;
  final rows = _floorRowDefs();

  return List.generate(20, (i) {
    final row = i ~/ 10;
    final col = i % 10;
    return VenueSection(
      id: 'F${i + 1}',
      number: (i + 1).toString().padLeft(3, '0'),
      gradeId: 'R',
      floor: 'FLOOR',
      x: startX + col * stride,
      y: 0.105 + row * 0.035,
      w: blockW,
      h: blockH,
      rows: rows,
    );
  });
}

// ─── 2F LEFT SIDE (S sections, VIP grade, rotated -90°) ───

List<VenueSection> _leftSideSections() {
  const ids = ['S5', 'S14', 'S13', 'S12', 'S11', 'S10', 'S9', 'S8'];
  const numbers = ['203', '204', '260', '259', '258', '257', '256', '206'];
  final rows = _sideRowDefs();

  return List.generate(ids.length, (i) {
    return VenueSection(
      id: ids[i],
      number: numbers[i],
      gradeId: 'VIP',
      floor: '2F',
      x: 0.015,
      y: 0.27 + i * 0.047,
      w: 0.028,
      h: 0.040,
      rotation: -pi / 2,
      rows: rows,
    );
  });
}

// ─── 2F LEFT E (E1,E2,E31,E30,E29,E28 — R grade, descending column) ───

List<VenueSection> _leftESections() {
  const data = [
    ('E1', '201', 0.075, 0.270),
    ('E2', '208', 0.072, 0.315),
    ('E31', '252', 0.068, 0.360),
    ('E30', '250', 0.065, 0.405),
    ('E29', '249', 0.063, 0.450),
    ('E28', '248', 0.062, 0.495),
  ];
  final rows = _twoFERowDefs();

  return data.map((d) {
    return VenueSection(
      id: d.$1,
      number: d.$2,
      gradeId: 'R',
      floor: '2F',
      x: d.$3,
      y: d.$4,
      w: 0.042,
      h: 0.032,
      rows: rows,
    );
  }).toList();
}

// ─── 2F CENTER E (E3-E13, R grade, gentle arc) ───

List<VenueSection> _centerESections() {
  final rows = _twoFERowDefs();

  return List.generate(11, (i) {
    final t = (i - 5) / 5.0;
    return VenueSection(
      id: 'E${i + 3}',
      number: '${209 + i}',
      gradeId: 'R',
      floor: '2F',
      x: 0.50 + t * 0.30 - 0.021,
      y: 0.37 + (1 - t * t) * 0.07,
      w: 0.042,
      h: 0.032,
      rows: rows,
    );
  });
}

// ─── 2F CENTER LOWER E (E23-E14, R grade, wider arc) ───

List<VenueSection> _centerLowerESections() {
  final rows = _twoFERowDefs();

  return List.generate(10, (i) {
    final t = (i - 4.5) / 4.5;
    final sectionId = 23 - i;
    return VenueSection(
      id: 'E$sectionId',
      number: '${220 + i}',
      gradeId: 'R',
      floor: '2F',
      x: 0.50 + t * 0.34 - 0.021,
      y: 0.47 + (1 - t * t) * 0.06,
      w: 0.042,
      h: 0.032,
      rows: rows,
    );
  });
}

// ─── 2F RIGHT E (E24-E27, R grade, ascending column — mirror of left) ───

List<VenueSection> _rightESections() {
  const data = [
    ('E24', '240', 0.270),
    ('E25', '241', 0.315),
    ('E26', '242', 0.360),
    ('E27', '243', 0.405),
  ];
  final rows = _twoFERowDefs();

  return data.map((d) {
    return VenueSection(
      id: d.$1,
      number: d.$2,
      gradeId: 'R',
      floor: '2F',
      x: 1.0 - 0.075 - 0.042,
      y: d.$3,
      w: 0.042,
      h: 0.032,
      rows: rows,
    );
  }).toList();
}

// ─── 2F RIGHT SIDE (N sections, S grade, rotated +90°) ───

List<VenueSection> _rightSideSections() {
  const ids = ['N1', 'N19', 'N20', 'N21', 'N22', 'N23', 'N24', 'N25'];
  const numbers = ['230', '231', '232', '233', '234', '235', '236', '237'];
  final rows = _sideRowDefs();

  return List.generate(ids.length, (i) {
    return VenueSection(
      id: ids[i],
      number: numbers[i],
      gradeId: 'S',
      floor: '2F',
      x: 0.957,
      y: 0.27 + i * 0.047,
      w: 0.028,
      h: 0.040,
      rotation: pi / 2,
      rows: rows,
    );
  });
}

// ─── 4F ROW 1 (E33-E42, S grade) ───

List<VenueSection> _fourFRow1Sections() {
  final rows = _fourFRowDefs();

  return List.generate(10, (i) {
    return VenueSection(
      id: 'E${33 + i}',
      number: '${401 + i}',
      gradeId: 'S',
      floor: '4F',
      x: 0.05 + i * 0.092,
      y: 0.62,
      w: 0.050,
      h: 0.032,
      rows: rows,
    );
  });
}

// ─── 4F ROW 2 (E43-E52, S grade) ───

List<VenueSection> _fourFRow2Sections() {
  final rows = _fourFRowDefs();

  return List.generate(10, (i) {
    return VenueSection(
      id: 'E${43 + i}',
      number: '${411 + i}',
      gradeId: 'S',
      floor: '4F',
      x: 0.03 + i * 0.096,
      y: 0.67,
      w: 0.050,
      h: 0.032,
      rows: rows,
    );
  });
}

// ─── 4F ROW 3 (E53-E60, S grade) ───

List<VenueSection> _fourFRow3Sections() {
  final rows = _fourFRowDefs();

  return List.generate(8, (i) {
    return VenueSection(
      id: 'E${53 + i}',
      number: '${421 + i}',
      gradeId: 'S',
      floor: '4F',
      x: 0.10 + i * 0.103,
      y: 0.72,
      w: 0.050,
      h: 0.032,
      rows: rows,
    );
  });
}
