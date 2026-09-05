import '../../services/seat_block_generator.dart';

// ━━━ Floor VIP Presets ━━━

const _floorVipSmall = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 8,
  frontSeats: 8,
  rearSeats: 8,
  alignment: SeatAlignment.centered,
  targetSeats: 64,
);

const _floorVipWide = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 8,
  frontSeats: 10,
  rearSeats: 10,
  alignment: SeatAlignment.centered,
  targetSeats: 80,
);

const _floorVipSide = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 10,
  frontSeats: 5,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 60,
);

const _floorVipCenter = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 10,
  frontSeats: 7,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 70,
);

// ━━━ Floor FR Presets ━━━

const _floorFrRect = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 12,
  frontSeats: 7,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 84,
);

const _floorFrSide = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 12,
  frontSeats: 5,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 72,
);

const _floorFrShort = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 6,
  frontSeats: 7,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 42,
);

// ━━━ Floor etc Preset ━━━

const _floorEtc = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 10,
  frontSeats: 7,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 70,
);

// ━━━ 1F Wing Presets (100s — narrow wedge) ━━━

const _wedgeL = SectionSeatConfig(
  shape: SeatShape.oneSideTaper,
  rows: 10,
  frontSeats: 6,
  rearSeats: 10,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 80,
);

const _wedgeR = SectionSeatConfig(
  shape: SeatShape.oneSideTaper,
  rows: 10,
  frontSeats: 6,
  rearSeats: 10,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 80,
);

// ━━━ 2F Wing Presets (200s — side fan) ━━━

const _sideFanL = SectionSeatConfig(
  shape: SeatShape.oneSideTaper,
  rows: 10,
  frontSeats: 5,
  rearSeats: 9,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 70,
);

const _sideFanR = SectionSeatConfig(
  shape: SeatShape.oneSideTaper,
  rows: 10,
  frontSeats: 5,
  rearSeats: 9,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 70,
);

// ━━━ T Section Presets (table) ━━━

const _tableL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 8,
  frontSeats: 5,
  rearSeats: 8,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 52,
);

const _tableR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 8,
  frontSeats: 5,
  rearSeats: 8,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 52,
);

const _tableWide = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 6,
  frontSeats: 8,
  rearSeats: 8,
  alignment: SeatAlignment.centered,
  targetSeats: 48,
);

const _tableCenter = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 4,
  frontSeats: 10,
  rearSeats: 10,
  alignment: SeatAlignment.centered,
  targetSeats: 40,
);

// ━━━ 3F Ring Presets (300s — narrow ring) ━━━

const _ringSide = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 6,
  frontSeats: 5,
  rearSeats: 7,
  alignment: SeatAlignment.centered,
  targetSeats: 36,
);

const _ringWide = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 6,
  frontSeats: 7,
  rearSeats: 9,
  alignment: SeatAlignment.centered,
  targetSeats: 48,
);

const _ringBottom = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 4,
  frontSeats: 8,
  rearSeats: 8,
  alignment: SeatAlignment.centered,
  targetSeats: 32,
);

const _ringNarrow = SectionSeatConfig(
  shape: SeatShape.rectangle,
  rows: 4,
  frontSeats: 6,
  rearSeats: 6,
  alignment: SeatAlignment.centered,
  targetSeats: 24,
);

// ━━━ 4F Outer Ring Presets (400s — large fan) ━━━

const _outerSideL = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 16,
  frontSeats: 7,
  rearSeats: 11,
  alignment: SeatAlignment.rightFixed,
  slant: SlantDirection.left,
  slantAmount: SlantAmount.small,
  targetSeats: 144,
);

const _outerSideR = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 16,
  frontSeats: 7,
  rearSeats: 11,
  alignment: SeatAlignment.leftFixed,
  slant: SlantDirection.right,
  slantAmount: SlantAmount.small,
  targetSeats: 144,
);

const _outerBottom = SectionSeatConfig(
  shape: SeatShape.trapezoid,
  rows: 16,
  frontSeats: 7,
  rearSeats: 11,
  alignment: SeatAlignment.centered,
  targetSeats: 144,
);

// ━━━ Section → Preset mapping (113 sections) ━━━

const gocheokBlockMap = <String, SectionSeatConfig>{
  // VIP Floor — F1~F13
  'F1': _floorVipSmall,
  'F2': _floorVipSmall,
  'F3': _floorVipWide,
  'F4': _floorVipWide,
  'F5': _floorVipSide,
  'F6': _floorVipSide,
  'F7': _floorVipSide,
  'F8': _floorVipCenter,
  'F9': _floorVipCenter,
  'F10': _floorVipCenter,
  'F11': _floorVipSide,
  'F12': _floorVipSide,
  'F13': _floorVipSide,

  // FR Floor — F14~F17, F19~F22
  'F14': _floorFrSide,
  'F15': _floorFrSide,
  'F16': _floorFrRect,
  'F17': _floorFrRect,
  'F19': _floorFrRect,
  'F20': _floorFrRect,
  'F21': _floorFrSide,
  'F22': _floorFrSide,

  // FR Floor bottom — F23~F28
  'F23': _floorFrRect,
  'F24': _floorFrRect,
  'F25': _floorFrShort,
  'F26': _floorFrShort,
  'F27': _floorFrRect,
  'F28': _floorFrRect,

  // etc Floor — F18 (FOH), F29, F30
  'F18': _floorFrShort,
  'F29': _floorEtc,
  'F30': _floorEtc,

  // 1F 좌측 날개 114→108
  '114': _wedgeL,
  '113': _wedgeL,
  '112': _wedgeL,
  '111': _wedgeL,
  '110': _wedgeL,
  '109': _wedgeL,
  '108': _wedgeL,

  // 1F 우측 날개 101→107
  '101': _wedgeR,
  '102': _wedgeR,
  '103': _wedgeR,
  '104': _wedgeR,
  '105': _wedgeR,
  '106': _wedgeR,
  '107': _wedgeR,

  // 2F 좌측 날개 210→206
  '210': _sideFanL,
  '209': _sideFanL,
  '208': _sideFanL,
  '207': _sideFanL,
  '206': _sideFanL,

  // 2F 우측 날개 201→205
  '201': _sideFanR,
  '202': _sideFanR,
  '203': _sideFanR,
  '204': _sideFanR,
  '205': _sideFanR,

  // T 테이블석 좌측
  'T07': _tableL,
  'T17': _tableL,
  'T06': _tableL,
  'T16': _tableL,
  'T05': _tableWide,
  'T15': _tableWide,

  // T 테이블석 중앙
  'T04': _tableCenter,

  // T 테이블석 우측
  'T03': _tableWide,
  'T13': _tableWide,
  'T02': _tableR,
  'T12': _tableR,
  'T01': _tableR,
  'T11': _tableR,

  // 3F 좌측 링 322→315
  '322': _ringSide,
  '321': _ringSide,
  '320': _ringSide,
  '319': _ringSide,
  '318': _ringSide,
  '317': _ringSide,
  '316': _ringSide,
  '315': _ringSide,

  // 3F 하단 314→310
  '314': _ringWide,
  '313': _ringBottom,
  '312': _ringNarrow,
  '311': _ringNarrow,
  '310': _ringBottom,
  '309': _ringWide,

  // 3F 우측 링 308→301
  '308': _ringSide,
  '307': _ringSide,
  '306': _ringSide,
  '305': _ringSide,
  '304': _ringSide,
  '303': _ringSide,
  '302': _ringSide,
  '301': _ringSide,

  // 4F 좌측 외곽 424→417
  '424': _outerSideL,
  '423': _outerSideL,
  '422': _outerSideL,
  '421': _outerSideL,
  '420': _outerSideL,
  '419': _outerSideL,
  '418': _outerSideL,
  '417': _outerSideL,

  // 4F 하단 외곽 416→409
  '416': _outerBottom,
  '415': _outerBottom,
  '414': _outerBottom,
  '413': _outerBottom,
  '412': _outerBottom,
  '411': _outerBottom,
  '410': _outerBottom,
  '409': _outerBottom,

  // 4F 우측 외곽 408→401
  '408': _outerSideR,
  '407': _outerSideR,
  '406': _outerSideR,
  '405': _outerSideR,
  '404': _outerSideR,
  '403': _outerSideR,
  '402': _outerSideR,
  '401': _outerSideR,
};
