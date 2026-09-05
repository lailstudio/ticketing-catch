import 'dart:ui';

class VenueData {
  final String id;
  final String name;
  final List<GradeInfo> grades;
  final List<VenueSection> sections;

  const VenueData({
    required this.id,
    required this.name,
    required this.grades,
    required this.sections,
  });

  GradeInfo gradeById(String id) =>
      grades.firstWhere((g) => g.id == id);

  List<VenueSection> sectionsByFloor(String floor) =>
      sections.where((s) => s.floor == floor).toList();

  List<String> get floors =>
      sections.map((s) => s.floor).toSet().toList();
}

class GradeInfo {
  final String id;
  final String label;
  final int colorValue;
  final int price;

  const GradeInfo({
    required this.id,
    required this.label,
    required this.colorValue,
    required this.price,
  });

  Color get color => Color(colorValue);
}

class VenueSection {
  final String id;
  final String number;
  final String gradeId;
  final String floor;
  final double x;
  final double y;
  final double w;
  final double h;
  final double rotation;
  final List<SectionRowDef> rows;

  const VenueSection({
    required this.id,
    required this.number,
    required this.gradeId,
    required this.floor,
    required this.x,
    required this.y,
    required this.w,
    required this.h,
    this.rotation = 0,
    required this.rows,
  });
}

class SectionRowDef {
  final int rowNumber;
  final int seatCount;
  final int startOffset;

  const SectionRowDef({
    required this.rowNumber,
    required this.seatCount,
    this.startOffset = 0,
  });
}
