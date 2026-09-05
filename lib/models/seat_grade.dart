import 'dart:ui';

enum SeatGrade {
  vip(0xFFF99AAF),
  r(0xFFBDA9EA),
  s(0xFFFDE685),
  a(0xFF94DCA8);

  final int colorValue;
  const SeatGrade(this.colorValue);
  Color get color => Color(colorValue);
}
