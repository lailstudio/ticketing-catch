import '../../services/seat_block_generator.dart';

const olympicBlockMap = <String, SectionSeatConfig>{
  // ━━━ LEFT 1F — B1, B2 ━━━
  'B1': SectionSeatConfig(
    shape: SeatShape.innerBentUpper,
    rows: 21,
    frontSeats: 8,
    rearSeats: 14,
    alignment: SeatAlignment.rightFixed,
    targetSeats: 224,
  ),
  'B2': SectionSeatConfig(
    shape: SeatShape.innerBentLower,
    rows: 22,
    frontSeats: 7,
    rearSeats: 13,
    alignment: SeatAlignment.rightFixed,
    targetSeats: 212,
  ),

  // ━━━ RIGHT 1F — D1, D2 (mirror of B1, B2) ━━━
  'D1': SectionSeatConfig(
    shape: SeatShape.innerBentUpper,
    rows: 21,
    frontSeats: 8,
    rearSeats: 14,
    alignment: SeatAlignment.leftFixed,
    targetSeats: 224,
  ),
  'D2': SectionSeatConfig(
    shape: SeatShape.innerBentLower,
    rows: 22,
    frontSeats: 7,
    rearSeats: 13,
    alignment: SeatAlignment.leftFixed,
    targetSeats: 212,
  ),
};
