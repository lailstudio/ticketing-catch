import '../../models/venue_map_config.dart';
import '../venue_map_helpers.dart';

/// 인스파이어 아레나 — 비대칭 U자형 배치
/// viewBox 1000×850, 기준 이미지에서 직접 추출한 좌표
///
/// 좌측: 3열 (3F 314~311 | 2F 214~211 | 1F 114~111)
/// 우측: 2열 (1F 102~105 | 2F 202~205)
/// 하단 전환: 110·210·310 / 206 / 207~209 / 308~309
final inspireConfig = VenueMapConfig(
  id: 'inspire',
  name: '인스파이어 아레나',
  viewBoxWidth: 1000,
  viewBoxHeight: 850,
  decorations: [
    MapDecoration(
      polygon: [412.4, 112.4, 643.4, 112.4, 643.4, 174.5, 412.4, 174.5],
      colorValue: stageColor,
      label: 'STAGE',
      fontSize: 16,
    ),
    MapDecoration(
      polygon: [447.3, 490.6, 608.5, 490.6, 608.5, 522.7, 447.3, 522.7],
      colorValue: consoleColor,
      label: 'CONSOLE',
      fontSize: 10,
    ),
  ],
  sections: [
    // ━━━ FLOOR F1~F8 ━━━
    polygonSection(id: 'F1', level: 'floor', colorRole: 'coral',
        polygon: [402.7, 202.4, 402.7, 258.2, 505.2, 258.2, 505.2, 201.7]),
    polygonSection(id: 'F2', level: 'floor', colorRole: 'coral',
        polygon: [546.4, 201.7, 546.4, 258.2, 649.0, 258.2, 649.0, 201.7]),
    polygonSection(id: 'F3', level: 'floor', colorRole: 'coral',
        polygon: [402.7, 273.6, 402.7, 329.4, 505.2, 329.4, 505.2, 273.6]),
    polygonSection(id: 'F4', level: 'floor', colorRole: 'coral',
        polygon: [546.4, 273.6, 546.4, 329.4, 649.0, 329.4, 649.0, 273.6]),
    polygonSection(id: 'F5', level: 'floor', colorRole: 'coral',
        polygon: [402.7, 346.1, 402.7, 402.0, 505.2, 402.0, 505.2, 346.1]),
    polygonSection(id: 'F6', level: 'floor', colorRole: 'coral',
        polygon: [546.4, 346.1, 546.4, 402.0, 649.0, 402.0, 649.0, 346.1]),
    polygonSection(id: 'F7', level: 'floor', colorRole: 'coral',
        polygon: [402.7, 417.3, 402.7, 471.8, 505.2, 471.8, 505.2, 417.3]),
    polygonSection(id: 'F8', level: 'floor', colorRole: 'coral',
        polygon: [546.4, 417.3, 546.4, 471.8, 649.0, 471.8, 649.0, 417.3]),

    // ━━━ 좌측 1F 세로 스택 114→110 ━━━
    polygonSection(id: '114', level: '1f', colorRole: 'lavender',
        polygon: [295.2, 157.7, 295.2, 255.4, 362.9, 255.4, 362.9, 157.7]),
    polygonSection(id: '113', level: '1f', colorRole: 'lavender',
        polygon: [295.2, 260.3, 295.2, 350.3, 362.2, 350.3, 362.9, 260.3]),
    polygonSection(id: '112', level: '1f', colorRole: 'lavender',
        polygon: [295.2, 354.5, 295.2, 447.3, 362.9, 447.3, 362.9, 354.5]),
    polygonSection(id: '111', level: '1f', colorRole: 'lavender',
        polygon: [295.2, 512.2, 361.5, 473.2, 362.9, 452.2, 295.2, 452.2]),
    polygonSection(id: '110', level: '1f', colorRole: 'lavender',
        polygon: [363.6, 477.3, 296.6, 516.4, 355.2, 600.9, 404.7, 531.8]),

    // ━━━ 좌측 2F 세로 스택 214→210 ━━━
    polygonSection(id: '214', level: '2f', colorRole: 'mint',
        polygon: [215.6, 157.7, 215.6, 255.4, 281.2, 255.4, 281.2, 157.7]),
    polygonSection(id: '213', level: '2f', colorRole: 'mint',
        polygon: [215.6, 260.3, 215.6, 350.3, 281.2, 350.3, 281.2, 260.3]),
    polygonSection(id: '212', level: '2f', colorRole: 'mint',
        polygon: [215.6, 354.5, 215.6, 447.3, 281.2, 447.3, 281.2, 354.5]),
    polygonSection(id: '211', level: '2f', colorRole: 'mint',
        polygon: [281.2, 452.2, 215.6, 452.2, 215.6, 556.9, 281.2, 515.7]),
    polygonSection(id: '210', level: '2f', colorRole: 'mint',
        polygon: [282.6, 520.6, 215.6, 563.9, 284.0, 665.8, 344.0, 612.0]),

    // ━━━ 2F 하단 가로 줄 209→207 ━━━
    polygonSection(id: '209', level: '2f', colorRole: 'mint',
        polygon: [286.8, 669.9, 460.6, 671.3, 460.6, 607.8, 358.7, 607.8]),
    polygonSection(id: '208', level: '2f', colorRole: 'mint',
        polygon: [465.5, 607.8, 465.5, 671.3, 572.9, 671.3, 572.9, 607.8]),
    polygonSection(id: '207', level: '2f', colorRole: 'mint',
        polygon: [577.1, 607.8, 577.1, 671.3, 711.1, 671.3, 670.6, 607.8]),

    // ━━━ 우측 2F 세로 스택 + 전환 202→206 ━━━
    polygonSection(id: '202', level: '2f', colorRole: 'mint',
        polygon: [770.4, 180.8, 770.4, 275.0, 838.1, 275.0, 838.1, 180.8]),
    polygonSection(id: '203', level: '2f', colorRole: 'mint',
        polygon: [770.4, 279.8, 770.4, 374.1, 838.1, 374.1, 838.1, 279.8]),
    polygonSection(id: '204', level: '2f', colorRole: 'mint',
        polygon: [770.4, 378.2, 770.4, 462.7, 838.1, 462.7, 838.1, 378.2]),
    polygonSection(id: '205', level: '2f', colorRole: 'mint',
        polygon: [770.4, 467.6, 770.4, 526.9, 838.1, 579.2, 838.1, 467.6]),
    polygonSection(id: '206', level: '2f', colorRole: 'mint',
        polygon: [767.6, 531.1, 681.8, 604.3, 726.4, 670.6, 836.7, 584.1]),

    // ━━━ 우측 1F 세로 스택 102→105 ━━━
    polygonSection(id: '102', level: '1f', colorRole: 'lavender',
        polygon: [688.8, 180.8, 688.8, 275.0, 756.5, 275.0, 756.5, 180.8]),
    polygonSection(id: '103', level: '1f', colorRole: 'lavender',
        polygon: [688.8, 279.8, 688.8, 374.1, 756.5, 374.1, 756.5, 279.8]),
    polygonSection(id: '104', level: '1f', colorRole: 'lavender',
        polygon: [688.8, 378.2, 688.8, 462.7, 756.5, 462.7, 756.5, 378.2]),
    polygonSection(id: '105', level: '1f', colorRole: 'lavender',
        polygon: [688.8, 467.6, 688.8, 501.1, 756.5, 523.4, 756.5, 467.6]),

    // ━━━ 좌측 3F 세로 스택 314→310 ━━━
    polygonSection(id: '314', level: '3f', colorRole: 'sky',
        polygon: [140.3, 157.7, 140.3, 255.4, 201.7, 255.4, 201.7, 157.7]),
    polygonSection(id: '313', level: '3f', colorRole: 'sky',
        polygon: [140.3, 260.3, 140.3, 350.3, 201.7, 350.3, 201.7, 260.3]),
    polygonSection(id: '312', level: '3f', colorRole: 'sky',
        polygon: [141.0, 354.5, 140.3, 448.0, 201.7, 448.0, 201.7, 354.5]),
    polygonSection(id: '311', level: '3f', colorRole: 'sky',
        polygon: [201.7, 452.2, 140.3, 452.2, 140.3, 616.2, 201.7, 567.4]),
    polygonSection(id: '310', level: '3f', colorRole: 'sky',
        polygon: [203.1, 572.2, 141.7, 623.2, 216.3, 735.5, 272.2, 675.5]),

    // ━━━ 3F 하단 가로 줄 309→308 ━━━
    polygonSection(id: '309', level: '3f', colorRole: 'sky',
        polygon: [277.0, 676.2, 421.5, 676.2, 421.5, 738.3, 215.6, 738.3]),
    polygonSection(id: '308', level: '3f', colorRole: 'sky',
        polygon: [422.2, 676.2, 422.2, 737.6, 572.9, 737.6, 572.9, 675.5]),
  ],
);
