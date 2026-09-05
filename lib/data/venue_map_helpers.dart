import 'dart:math';

import '../models/seat_grade.dart';
import '../models/venue_map_config.dart';

// ─── Color palette ───

const stageColor = 0xFF152746;
const consoleColor = 0xFF666666;
const gateColor = 0xFFE5607A;

const coralColor = 0xFFF38F8C;
const mintColor = 0xFF9ED9C9;
const skyColor = 0xFF9FCBE8;
const lavenderColor = 0xFFB9A7D9;
const sageColor = 0xFFAEC9A6;
const peachColor = 0xFFF2C18E;
const honeyColor = 0xFFF5DFA0;

// KSPO DOME 전용 색상 (기준 이미지 원본)
const kspoPinkColor = 0xFFFB9CAF;
const kspoLavenderColor = 0xFFBEAAEC;
const kspoGreenColor = 0xFF93DDA7;
const kspoYellowColor = 0xFFFEE681;

// 고척스카이돔 전용 색상 (원본 등급 컬러의 파스텔 톤)
const gocheokVipColor = 0xFFCBB8E8;
const gocheokFrColor = 0xFF93D4A8;
const gocheokRColor = 0xFF9FCBE8;
const gocheokSColor = 0xFFF2C18E;
const gocheokAColor = 0xFFC5E0A0;
const gocheokGrayColor = 0xFFCFCFD4;

const colorRoleMap = <String, int>{
  'coral': coralColor,
  'mint': mintColor,
  'sky': skyColor,
  'lavender': lavenderColor,
  'sage': sageColor,
  'peach': peachColor,
  'honey': honeyColor,
  'kspo-pink': kspoPinkColor,
  'kspo-lavender': kspoLavenderColor,
  'kspo-green': kspoGreenColor,
  'kspo-yellow': kspoYellowColor,
  'gocheok-vip': gocheokVipColor,
  'gocheok-fr': gocheokFrColor,
  'gocheok-r': gocheokRColor,
  'gocheok-s': gocheokSColor,
  'gocheok-a': gocheokAColor,
  'gocheok-gray': gocheokGrayColor,
};

int colorForRole(String role) => colorRoleMap[role] ?? 0xFFCCCCCC;

// ─── Geometry helpers ───

List<double> rect(double x, double y, double w, double h) {
  return [x, y, x + w, y, x + w, y + h, x, y + h];
}

List<double> trapezoid(
    double x, double y, double topW, double bottomW, double h) {
  final cx = x + max(topW, bottomW) / 2;
  return [
    cx - topW / 2, y,
    cx + topW / 2, y,
    cx + bottomW / 2, y + h,
    cx - bottomW / 2, y + h,
  ];
}

MapDecoration stageRect(double x, double y, double w, double h,
    {String label = 'STAGE', double fontSize = 14}) {
  return MapDecoration(
    polygon: rect(x, y, w, h),
    colorValue: stageColor,
    label: label,
    fontSize: fontSize,
  );
}

MapDecoration consoleRect(double x, double y, double w, double h,
    {String label = 'CONSOLE', double fontSize = 9}) {
  return MapDecoration(
    polygon: rect(x, y, w, h),
    colorValue: consoleColor,
    label: label,
    fontSize: fontSize,
  );
}

List<MapSection> arcSections({
  required double cx,
  required double cy,
  required double innerR,
  required double outerR,
  required double startDeg,
  required double endDeg,
  required List<String> ids,
  required String level,
  required List<String> colorRoles,
  List<String>? labels,
  int arcSegments = 4,
}) {
  final count = ids.length;
  final startRad = startDeg * pi / 180;
  final endRad = endDeg * pi / 180;
  final sections = <MapSection>[];

  for (int i = 0; i < count; i++) {
    final a1 = startRad + (endRad - startRad) * i / count;
    final a2 = startRad + (endRad - startRad) * (i + 1) / count;
    final points = <double>[];

    for (int j = 0; j <= arcSegments; j++) {
      final a = a1 + (a2 - a1) * j / arcSegments;
      points.add(cx + innerR * cos(a));
      points.add(cy + innerR * sin(a));
    }
    for (int j = arcSegments; j >= 0; j--) {
      final a = a1 + (a2 - a1) * j / arcSegments;
      points.add(cx + outerR * cos(a));
      points.add(cy + outerR * sin(a));
    }

    sections.add(MapSection(
      id: ids[i],
      label: labels?[i] ?? ids[i],
      level: level,
      colorRole: colorRoles[i % colorRoles.length],
      polygon: points,
    ));
  }
  return sections;
}

MapSection rectSection({
  required String id,
  required double x,
  required double y,
  required double w,
  required double h,
  required String level,
  required String colorRole,
  String? label,
}) {
  return MapSection(
    id: id,
    label: label ?? id,
    level: level,
    colorRole: colorRole,
    polygon: rect(x, y, w, h),
  );
}

MapSection polygonSection({
  required String id,
  required List<double> polygon,
  required String level,
  String colorRole = '',
  SeatGrade? grade,
  String? label,
  double labelDx = 0,
  double labelDy = 0,
}) {
  return MapSection(
    id: id,
    label: label ?? id,
    level: level,
    colorRole: colorRole,
    grade: grade,
    polygon: polygon,
    labelDx: labelDx,
    labelDy: labelDy,
  );
}
