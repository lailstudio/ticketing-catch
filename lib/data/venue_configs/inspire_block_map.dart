import '../../services/seat_block_generator.dart';

// ━━━ Preset definitions ━━━

const _floorRect = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 20,
  frontSeats: 11,
  rearSeats: 11,
  alignment: SeatAlignment.centered,
  targetSeats: 220,
);

const _vertBlock = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 20,
  frontSeats: 9,
  rearSeats: 11,
  alignment: SeatAlignment.centered,
  targetSeats: 200,
);

const _vertSmall = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 14,
  frontSeats: 8,
  rearSeats: 10,
  alignment: SeatAlignment.centered,
  targetSeats: 130,
);

const _vertMedium = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 18,
  frontSeats: 9,
  rearSeats: 11,
  alignment: SeatAlignment.centered,
  targetSeats: 180,
);

const _vertTall = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 26,
  frontSeats: 9,
  rearSeats: 11,
  alignment: SeatAlignment.centered,
  targetSeats: 260,
);

const _diagRight = SectionSeatConfig(
  shape: SeatShape.oneSideTaper,
  rows: 18,
  frontSeats: 7,
  rearSeats: 12,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.medium,
  targetSeats: 180,
);

const _diagLeft = SectionSeatConfig(
  shape: SeatShape.oneSideTaper,
  rows: 18,
  frontSeats: 7,
  rearSeats: 12,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.medium,
  targetSeats: 180,
);

const _horizCenter = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 16,
  frontSeats: 11,
  rearSeats: 12,
  alignment: SeatAlignment.centered,
  targetSeats: 184,
);

const _horizTrapRight = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 16,
  frontSeats: 10,
  rearSeats: 13,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 184,
);

const _horizTrapLeft = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 16,
  frontSeats: 10,
  rearSeats: 13,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 184,
);

// ━━━ Section → Preset mapping ━━━

const inspireBlockMap = <String, SectionSeatConfig>{
  // FLOOR F1~F8 — floorRect
  'F1': _floorRect,
  'F2': _floorRect,
  'F3': _floorRect,
  'F4': _floorRect,
  'F5': _floorRect,
  'F6': _floorRect,
  'F7': _floorRect,
  'F8': _floorRect,

  // 좌측 1F 세로형 (114~112) — vertBlock
  '114': _vertBlock,
  '113': _vertBlock,
  '112': _vertBlock,
  '111': _vertSmall,
  '110': _diagRight,

  // 좌측 2F 세로형 (214~210)
  '214': _vertBlock,
  '213': _vertBlock,
  '212': _vertBlock,
  '211': _vertMedium,
  '210': _diagRight,

  // 좌측 3F 세로형 (314~310)
  '314': _vertBlock,
  '313': _vertBlock,
  '312': _vertBlock,
  '311': _vertTall,
  '310': _diagRight,

  // 우측 1F 세로형 (102~105) — vertBlock mirror
  '102': _vertBlock,
  '103': _vertBlock,
  '104': _vertBlock,
  '105': _vertSmall,

  // 우측 2F 세로형 (202~206)
  '202': _vertBlock,
  '203': _vertBlock,
  '204': _vertBlock,
  '205': _vertMedium,
  '206': _diagLeft,

  // 하단 2F 가로형 (207~209)
  '209': _horizTrapRight,
  '208': _horizCenter,
  '207': _horizTrapLeft,

  // 하단 3F 가로형 (308~309)
  '309': _horizTrapRight,
  '308': _horizCenter,
};
