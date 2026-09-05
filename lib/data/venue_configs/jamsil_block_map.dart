import '../../services/seat_block_generator.dart';

// ━━━ Floor Presets ━━━

// F1/F2: L자형 폴리곤 (89×197), 스테이지 쪽 넓고 뒤로 좁아짐
const _floorTaper = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 16,
  frontSeats: 10,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 136,
);

// ━━━ 2F Inner Ring — Center Presets ━━━

// 14/13: 중앙 하단, 부채꼴 (96~98×110), 스테이지에서 멀어질수록 넓어짐
const _centerSmallFan = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 12,
  frontSeats: 7,
  rearSeats: 10,
  alignment: SeatAlignment.centered,
  targetSeats: 102,
);

// ━━━ 2F Inner Ring — Angled Presets ━━━

// 15: 좌측 경사 부채꼴 (122×129)
const _angledSmallFanL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 12,
  frontSeats: 8,
  rearSeats: 12,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 117,
);

// 12: 우측 경사 부채꼴 (125×129) — 15의 미러
const _angledSmallFanR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 12,
  frontSeats: 8,
  rearSeats: 12,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 117,
);

// ━━━ 2F Inner Ring — Side-Angled Presets ━━━

// 16: 좌측 넓은 경사 (143×154)
const _sideAngledFanL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 14,
  frontSeats: 9,
  rearSeats: 13,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 152,
);

// 11: 우측 넓은 경사 (145×154) — 16의 미러
const _sideAngledFanR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 14,
  frontSeats: 9,
  rearSeats: 13,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 152,
);

// ━━━ 2F Inner Ring — Far Side Presets ━━━

// 17: 좌측 측면 (119×134)
const _sideSmallFanL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 12,
  frontSeats: 8,
  rearSeats: 11,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.medium,
  targetSeats: 114,
);

// 10: 우측 측면 (117×134) — 17의 미러
const _sideSmallFanR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 12,
  frontSeats: 8,
  rearSeats: 11,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.medium,
  targetSeats: 114,
);

// ━━━ 3F Outer Ring — Center Presets ━━━

// 32/31: 중앙 하단 대형 (160~161×185)
const _centerLargeFan = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 18,
  frontSeats: 9,
  rearSeats: 14,
  alignment: SeatAlignment.centered,
  targetSeats: 207,
);

// ━━━ 3F Outer Ring — Angled Presets ━━━

// 33: 좌측 경사 대형 (192×209)
const _angledLargeFanL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 18,
  frontSeats: 10,
  rearSeats: 15,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 225,
);

// 30: 우측 경사 대형 (198×212) — 33의 미러
const _angledLargeFanR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 18,
  frontSeats: 10,
  rearSeats: 15,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 225,
);

// ━━━ 3F Outer Ring — Far Side Presets ━━━

// 34: 좌측 측면 대형 (214×235)
const _sideLargeFanL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 20,
  frontSeats: 10,
  rearSeats: 15,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.medium,
  targetSeats: 246,
);

// 29: 우측 측면 대형 (214×233) — 34의 미러
const _sideLargeFanR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 20,
  frontSeats: 10,
  rearSeats: 15,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.medium,
  targetSeats: 246,
);

// ━━━ Section → Preset mapping (16 sections) ━━━

const jamsilBlockMap = <String, SectionSeatConfig>{
  // FLOOR
  'F1': _floorTaper,
  'F2': _floorTaper,

  // 2F 중앙
  '14': _centerSmallFan,
  '13': _centerSmallFan,

  // 2F 경사 (12↔15 미러)
  '15': _angledSmallFanL,
  '12': _angledSmallFanR,

  // 2F 넓은 경사 (11↔16 미러)
  '16': _sideAngledFanL,
  '11': _sideAngledFanR,

  // 2F 측면 (10↔17 미러)
  '17': _sideSmallFanL,
  '10': _sideSmallFanR,

  // 3F 중앙
  '32': _centerLargeFan,
  '31': _centerLargeFan,

  // 3F 경사 (30↔33 미러)
  '33': _angledLargeFanL,
  '30': _angledLargeFanR,

  // 3F 측면 (29↔34 미러)
  '34': _sideLargeFanL,
  '29': _sideLargeFanR,
};
