import '../../models/venue_map_config.dart';
import '../venue_map_helpers.dart';

/// 잠실실내체육관 — SVG polygon 기반 배치도
/// viewBox 1000×850, 모든 좌표는 이 기준에서 직접 제공된 값
///
/// 2F (10~17): 스테이지를 감싸는 내측 반원 링
/// 3F (29~34): 외측 반원 링
/// FLOOR (F1, F2): 스테이지 양옆 플로어석
final jamsilConfig = VenueMapConfig(
  id: 'jamsil',
  name: '잠실실내체육관',
  viewBoxWidth: 1000,
  viewBoxHeight: 850,
  decorations: [
    // STAGE — 상단 바 + 세로 기둥 + 하단 바 (3파트, 1px 겹침으로 이음새 방지)
    MapDecoration(
      polygon: [340, 75, 660, 75, 660, 141, 340, 141],
      colorValue: stageColor,
      label: 'STAGE',
      fontSize: 16,
    ),
    MapDecoration(
      polygon: [459, 140, 545, 140, 545, 239, 459, 239],
      colorValue: stageColor,
    ),
    MapDecoration(
      polygon: [437, 238, 568, 238, 568, 390, 437, 390],
      colorValue: stageColor,
    ),
    // CONSOLE — 중앙 콘솔 영역, 클릭 불가
    MapDecoration(
      polygon: [433, 395, 434, 429, 561, 429, 561, 395],
      colorValue: consoleColor,
      label: 'CONSOLE',
      fontSize: 9,
    ),
  ],
  sections: [
    // ━━━ FLOOR ━━━
    polygonSection(id: 'F1', level: 'floor', colorRole: 'coral',
        polygon: [365, 171, 365, 367, 425, 368, 425, 239, 453, 238, 454, 172]),
    polygonSection(id: 'F2', level: 'floor', colorRole: 'coral',
        polygon: [550, 171, 550, 238, 579, 239, 579, 367, 639, 368, 639, 171]),

    // ━━━ 2F — 내측 반원 링 (17→10, 좌→우) ━━━
    polygonSection(id: '17', level: '2f', colorRole: 'lavender',
        polygon: [241, 198, 143, 219, 177, 332, 262, 280]),
    polygonSection(id: '16', level: '2f', colorRole: 'lavender',
        polygon: [275, 305, 191, 359, 224, 411, 268, 459, 334, 383]),
    polygonSection(id: '15', level: '2f', colorRole: 'lavender',
        polygon: [348, 398, 285, 473, 328, 505, 372, 527, 407, 436]),
    polygonSection(id: '14', level: '2f', colorRole: 'lavender',
        polygon: [425, 443, 392, 535, 438, 548, 488, 553, 488, 456]),
    polygonSection(id: '13', level: '2f', colorRole: 'lavender',
        polygon: [572, 443, 507, 456, 508, 553, 553, 549, 605, 536]),
    polygonSection(id: '12', level: '2f', colorRole: 'lavender',
        polygon: [651, 398, 590, 437, 625, 527, 666, 508, 715, 473]),
    polygonSection(id: '11', level: '2f', colorRole: 'lavender',
        polygon: [725, 305, 665, 383, 732, 459, 810, 360]),
    polygonSection(id: '10', level: '2f', colorRole: 'lavender',
        polygon: [761, 200, 739, 281, 824, 334, 856, 220]),

    // ━━━ 3F — 외측 반원 링 (34→29, 좌→우) ━━━
    polygonSection(id: '34', level: '3f', colorRole: 'sky',
        polygon: [165, 367, 38, 450, 88, 531, 152, 602, 252, 479]),
    polygonSection(id: '33', level: '3f', colorRole: 'sky',
        polygon: [268, 494, 170, 618, 241, 669, 306, 703, 362, 551]),
    polygonSection(id: '32', level: '3f', colorRole: 'sky',
        polygon: [382, 560, 328, 713, 414, 738, 488, 745, 488, 580]),
    polygonSection(id: '31', level: '3f', colorRole: 'sky',
        polygon: [615, 560, 508, 580, 508, 745, 591, 738, 669, 714]),
    polygonSection(id: '30', level: '3f', colorRole: 'sky',
        polygon: [732, 493, 635, 551, 691, 705, 765, 666, 833, 617]),
    polygonSection(id: '29', level: '3f', colorRole: 'sky',
        polygon: [834, 367, 748, 478, 851, 600, 916, 527, 962, 451]),
  ],
);
