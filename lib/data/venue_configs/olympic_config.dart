import '../../models/venue_map_config.dart';
import '../venue_map_helpers.dart';

/// 올림픽홀 — 1000×850 viewBox, 사용자 제공 좌표 기반
final olympicConfig = VenueMapConfig(
  id: 'olympic',
  name: '올림픽홀',
  viewBoxWidth: 1000,
  viewBoxHeight: 850,
  decorations: [
    // STAGE polygon (label은 labelDecorations에서 별도 배치)
    MapDecoration(
      polygon: [
        389.0,119.5, 389.0,176.1, 479.2,177.5,
        479.2,287.8, 449.9,289.3, 449.9,372.3,
        550.1,372.3, 550.1,289.3, 524.4,287.8,
        525.1,176.8, 612.5,176.1, 612.5,118.8,
      ],
      colorValue: stageColor,
    ),
    // CONSOLE
    MapDecoration(
      polygon: [
        384.0,498.4, 384.7,540.0, 616.8,540.0, 616.8,496.3,
      ],
      colorValue: consoleColor,
      label: 'CONSOLE',
      fontSize: 12,
    ),
    // 왼쪽 inner transition
    MapDecoration(
      polygon: [
        355.3,560.0, 315.2,599.4, 329.5,615.2, 369.6,575.8,
      ],
      colorValue: 0xFF5A6577,
    ),
    // 오른쪽 inner transition
    MapDecoration(
      polygon: [
        644.7,560.0, 629.7,575.1, 669.8,615.2, 684.8,599.4,
      ],
      colorValue: 0xFF5A6577,
    ),
    // 왼쪽 outer transition
    MapDecoration(
      polygon: [
        290.1,637.4, 230.7,696.1, 254.3,721.2,
        289.4,721.2, 289.4,678.9, 310.2,658.2,
      ],
      colorValue: 0xFF5A6577,
    ),
    // 오른쪽 outer transition
    MapDecoration(
      polygon: [
        709.2,637.4, 689.1,658.2, 709.9,678.9,
        709.9,721.2, 745.7,721.2, 768.6,696.8,
      ],
      colorValue: 0xFF5A6577,
    ),
  ],
  labelDecorations: [
    // STAGE 텍스트 — 상단 가로 바 중앙에 배치
    MapLabelDecoration(
      cx: 500.75,
      cy: 147.6,
      width: 0,
      height: 0,
      borderRadius: 0,
      backgroundColorValue: 0x00000000,
      textColorValue: 0xFFFFFFFF,
      label: 'STAGE',
      fontSize: 18,
    ),
  ],
  sections: [
    // ─── FLOOR (F1~F4) — coral ───

    polygonSection(
      id: 'F1', level: 'floor', colorRole: 'coral',
      polygon: [
        384.7,213.3, 384.7,375.2, 434.8,375.2,
        434.8,275.6, 462.8,274.2, 463.5,213.3,
      ],
    ),
    polygonSection(
      id: 'F2', level: 'floor', colorRole: 'coral',
      polygon: [
        539.4,213.3, 539.4,274.2, 565.9,274.9,
        565.9,375.2, 617.5,375.2, 617.5,213.3,
      ],
    ),
    polygonSection(
      id: 'F3', level: 'floor', colorRole: 'coral',
      polygon: [
        384.0,394.6, 384.0,478.4, 491.4,478.4, 491.4,393.8,
      ],
    ),
    polygonSection(
      id: 'F4', level: 'floor', colorRole: 'coral',
      polygon: [
        509.3,393.8, 509.3,478.4, 616.8,478.4, 616.8,393.8,
      ],
    ),

    // ─── LEFT 1F — G, B1, B2 ───

    polygonSection(
      id: 'G', level: '1f', colorRole: 'lavender',
      polygon: [
        327.4,185.4, 259.3,186.1, 259.3,288.5,
        278.7,288.5, 278.7,251.3, 327.4,202.6,
      ],
    ),

    // B1 — 두 polygon 모두 lavender, 모두 라벨 표시
    polygonSection(
      id: 'B1', level: '1f', colorRole: 'lavender',
      polygon: [
        348.1,354.4, 295.8,404.6, 348.1,459.7,
      ],
    ),
    polygonSection(
      id: 'B1', level: '1f', colorRole: 'lavender',
      polygon: [
        320.9,277.1, 277.9,319.3, 277.9,383.1,
        288.7,393.8, 348.1,337.2, 348.1,304.3,
      ],
    ),

    // B2 — 두 polygon 모두 lavender, 모두 라벨 표시
    polygonSection(
      id: 'B2', level: '1f', colorRole: 'lavender',
      polygon: [
        277.9,403.2, 277.2,507.0, 328.1,456.2,
      ],
    ),
    polygonSection(
      id: 'B2', level: '1f', colorRole: 'lavender',
      polygon: [
        336.0,467.6, 277.9,524.9, 277.9,562.2,
        304.4,589.4, 347.4,547.9, 347.4,479.8,
      ],
    ),

    // ─── RIGHT 1F — H, D1, D2 ───

    polygonSection(
      id: 'H', level: '1f', colorRole: 'lavender',
      polygon: [
        674.8,185.4, 674.8,203.3, 722.8,251.3,
        722.8,288.5, 740.0,288.5, 740.0,185.4,
      ],
    ),

    // D1 — 두 polygon 모두 lavender, 모두 라벨 표시
    polygonSection(
      id: 'D1', level: '1f', colorRole: 'lavender',
      polygon: [
        651.9,354.4, 651.9,459.7, 703.4,404.6,
      ],
    ),
    polygonSection(
      id: 'D1', level: '1f', colorRole: 'lavender',
      polygon: [
        678.4,277.8, 651.9,304.3, 651.9,338.0,
        711.3,393.8, 722.1,383.1, 722.1,318.6,
      ],
    ),

    // D2 — 두 polygon 모두 lavender, 모두 라벨 표시
    polygonSection(
      id: 'D2', level: '1f', colorRole: 'lavender',
      polygon: [
        722.1,403.2, 671.9,456.2, 722.1,506.3,
      ],
    ),
    polygonSection(
      id: 'D2', level: '1f', colorRole: 'lavender',
      polygon: [
        664.0,467.6, 651.9,479.8, 651.9,547.9,
        695.6,589.4, 722.1,561.5, 722.1,524.9,
      ],
    ),

    // ─── LEFT 2F — A1~A4 ───

    // A1 — 두 polygon 모두 mint, 모두 라벨 표시
    polygonSection(
      id: 'A1', level: '2f', colorRole: 'mint',
      polygon: [
        95.3,212.6, 80.9,226.2, 80.9,274.2, 124.6,274.2, 124.6,212.6,
      ],
    ),
    polygonSection(
      id: 'A1', level: '2f', colorRole: 'mint',
      polygon: [
        136.8,212.6, 136.8,274.2, 214.9,274.2, 214.9,212.6,
      ],
    ),

    // A2
    polygonSection(
      id: 'A2', level: '2f', colorRole: 'mint',
      polygon: [
        70.9,287.1, 70.2,368.1, 124.6,368.1, 124.6,287.1,
      ],
    ),
    polygonSection(
      id: 'A2', level: '2f', colorRole: 'mint',
      polygon: [
        137.5,287.1, 136.8,368.1, 214.9,368.1, 214.9,287.1,
      ],
    ),

    // A3
    polygonSection(
      id: 'A3', level: '2f', colorRole: 'mint',
      polygon: [
        70.2,380.9, 70.2,459.7, 124.6,459.7, 124.6,380.9,
      ],
    ),
    polygonSection(
      id: 'A3', level: '2f', colorRole: 'mint',
      polygon: [
        136.8,380.9, 136.8,459.7, 214.9,459.7, 214.9,380.9,
      ],
    ),

    // A4
    polygonSection(
      id: 'A4', level: '2f', colorRole: 'mint',
      polygon: [
        86.7,472.6, 86.0,519.2, 106.7,540.0, 124.6,540.0, 124.6,472.6,
      ],
    ),
    polygonSection(
      id: 'A4', level: '2f', colorRole: 'mint',
      polygon: [
        137.5,472.6, 136.8,554.3, 214.9,554.3, 214.9,472.6,
      ],
    ),

    // ─── RIGHT 2F — E1~E4 ───

    // E1 — 두 polygon 모두 mint, 모두 라벨 표시
    polygonSection(
      id: 'E1', level: '2f', colorRole: 'mint',
      polygon: [
        874.6,212.6, 874.6,274.2, 918.3,274.2, 919.1,226.9, 904.0,212.6,
      ],
    ),
    polygonSection(
      id: 'E1', level: '2f', colorRole: 'mint',
      polygon: [
        782.2,212.6, 782.2,274.2, 861.7,274.2, 861.7,212.6,
      ],
    ),

    // E2
    polygonSection(
      id: 'E2', level: '2f', colorRole: 'mint',
      polygon: [
        875.4,287.1, 874.6,368.1, 929.8,368.1, 929.8,287.8,
      ],
    ),
    polygonSection(
      id: 'E2', level: '2f', colorRole: 'mint',
      polygon: [
        782.2,287.1, 782.2,368.1, 861.7,368.1, 861.7,287.1,
      ],
    ),

    // E3
    polygonSection(
      id: 'E3', level: '2f', colorRole: 'mint',
      polygon: [
        874.6,380.9, 874.6,459.7, 929.8,459.7, 929.8,380.9,
      ],
    ),
    polygonSection(
      id: 'E3', level: '2f', colorRole: 'mint',
      polygon: [
        782.2,380.9, 782.2,459.7, 861.7,459.7, 861.7,380.9,
      ],
    ),

    // E4
    polygonSection(
      id: 'E4', level: '2f', colorRole: 'mint',
      polygon: [
        914.0,472.6, 874.6,473.4, 875.4,540.0, 894.0,540.0, 914.0,519.2,
      ],
    ),
    polygonSection(
      id: 'E4', level: '2f', colorRole: 'mint',
      polygon: [
        782.2,473.4, 782.2,554.3, 861.7,554.3, 861.7,472.6,
      ],
    ),

    // ─── CENTER C1~C3 — inner(1F lavender) + outer(2F mint) ───

    // C1 — inner(lavender), outer(mint), 모두 라벨 표시
    polygonSection(
      id: 'C1', level: '1f', colorRole: 'lavender',
      polygon: [
        339.5,623.8, 438.4,623.8, 438.4,579.4, 382.5,579.4,
      ],
    ),
    polygonSection(
      id: 'C1', level: '2f', colorRole: 'mint',
      polygon: [
        303.7,686.1, 303.7,721.9, 429.1,721.9, 429.1,662.5, 328.1,662.5,
      ],
    ),

    // C2
    polygonSection(
      id: 'C2', level: '1f', colorRole: 'lavender',
      polygon: [
        450.6,579.4, 449.9,623.8, 548.0,623.8, 548.0,579.4,
      ],
    ),
    polygonSection(
      id: 'C2', level: '2f', colorRole: 'mint',
      polygon: [
        442.7,662.5, 442.7,721.9, 556.6,721.9, 556.6,662.5,
      ],
    ),

    // C3
    polygonSection(
      id: 'C3', level: '1f', colorRole: 'lavender',
      polygon: [
        560.9,579.4, 560.9,623.8, 659.7,623.8, 616.8,579.4,
      ],
    ),
    polygonSection(
      id: 'C3', level: '2f', colorRole: 'mint',
      polygon: [
        570.2,662.5, 570.2,721.9, 695.6,721.9, 695.6,686.1, 671.9,662.5,
      ],
    ),
  ],
);
