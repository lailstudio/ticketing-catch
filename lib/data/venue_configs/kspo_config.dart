import '../../models/seat_grade.dart';
import '../../models/venue_map_config.dart';
import '../venue_map_helpers.dart';

// ── KSPO DOME Config ──
// 이미지 기반 렌더링: 기준 좌석배치도 이미지 + 투명 클릭영역
// 좌표: OpenCV contour detection으로 추출 (흑백 실루엣 기준)
// 좌표계: 이미지 원본 크기 1254×1254 (절대 픽셀)

final kspoConfig = VenueMapConfig(
  id: 'kspo',
  name: 'KSPO DOME',
  viewBoxWidth: 1254,
  viewBoxHeight: 1254,
  decorations: [
    MapDecoration(
      polygon: [390,157, 393,272, 864,269, 859,154],
      colorValue: stageColor,
      label: 'STAGE',
      fontSize: 24,
    ),
    MapDecoration(
      polygon: [585,722, 582,788, 584,790, 670,789, 668,723, 665,720, 638,723, 589,720],
      colorValue: consoleColor,
      label: 'CONSOLE',
      fontSize: 11,
    ),
  ],
  labelDecorations: [
    MapLabelDecoration(
      cx: 627,
      cy: 293,
      width: 105,
      height: 26,
      borderRadius: 13,
      backgroundColorValue: 0xFFE8E8E8,
      textColorValue: 0xFF555555,
      label: 'FLOOR',
      fontSize: 12,
    ),
  ],
  gateDecorations: [],
  legendEntries: [
    MapLegendEntry(label: 'VIP석', colorValue: SeatGrade.vip.colorValue),
    MapLegendEntry(label: 'R석',   colorValue: SeatGrade.r.colorValue),
    MapLegendEntry(label: 'S석',   colorValue: SeatGrade.s.colorValue),
    MapLegendEntry(label: 'A석',   colorValue: SeatGrade.a.colorValue),
  ],
  sections: [
    // ━━━ FLOOR A~F (VIP) ━━━
    polygonSection(
        id: 'A', level: 'floor', grade: SeatGrade.vip,
        polygon: [428,311, 400,407, 400,485, 532,487, 532,312]),
    polygonSection(
        id: 'B', level: 'floor', grade: SeatGrade.vip,
        polygon: [554,312, 554,487, 699,487, 699,312]),
    polygonSection(
        id: 'C', level: 'floor', grade: SeatGrade.vip,
        polygon: [723,311, 721,487, 851,487, 853,409, 830,312]),
    polygonSection(
        id: 'D', level: 'floor', grade: SeatGrade.vip,
        polygon: [
          404,508, 402,517, 411,542, 444,593,
          489,635, 515,652, 531,656, 533,510,
          529,507
        ]),
    polygonSection(
        id: 'E', level: 'floor', grade: SeatGrade.vip,
        polygon: [
          555,508, 553,657, 590,678, 614,681,
          665,678, 697,660, 701,623, 700,510
        ]),
    polygonSection(
        id: 'F', level: 'floor', grade: SeatGrade.vip,
        polygon: [
          849,508, 721,509, 722,656, 732,656,
          760,642, 808,600, 841,547, 851,517
        ]),

    // ━━━ 1F 우측 1~4 (R) ━━━
    polygonSection(
        id: '1', level: '1f', grade: SeatGrade.r,
        polygon: [
          1051,290, 907,343,
          918,402, 1071,387, 1066,341
        ]),
    polygonSection(
        id: '2', level: '1f', grade: SeatGrade.r,
        polygon: [1074,397, 1062,395, 920,411, 916,479, 1072,494, 1076,465]),
    polygonSection(
        id: '3', level: '1f', grade: SeatGrade.r,
        polygon: [
          914,488, 900,539, 902,543, 1041,611,
          1045,610, 1065,545, 1072,507, 1070,501
        ]),
    polygonSection(
        id: '4', level: '1f', grade: SeatGrade.r,
        polygon: [
          897,549, 872,596, 873,601, 992,705,
          998,704, 1031,643, 1040,618
        ]),

    // ━━━ 1F 하단 곡선 5~11 (VIP) ━━━
    polygonSection(
        id: '5', level: '1f', grade: SeatGrade.vip,
        polygon: [
          837,626, 797,666, 888,813, 898,821,
          938,785, 969,746, 845,628
        ]),
    polygonSection(
        id: '6', level: '1f', grade: SeatGrade.vip,
        polygon: [
          785,672, 742,696, 738,704, 794,878,
          799,881, 858,850, 884,832, 886,826,
          793,675
        ]),
    polygonSection(
        id: '7', level: '1f', grade: SeatGrade.vip,
        polygon: [726,703, 677,720, 686,911, 725,905, 786,886, 736,723]),
    polygonSection(
        id: '8', level: '1f', grade: SeatGrade.vip,
        polygon: [581,801, 576,911, 603,915, 674,913, 676,899, 671,801]),
    polygonSection(
        id: '9', level: '1f', grade: SeatGrade.vip,
        polygon: [
          525,703, 466,885, 501,898, 563,911,
          567,908, 576,721, 572,716
        ]),
    polygonSection(
        id: '10', level: '1f', grade: SeatGrade.vip,
        polygon: [
          468,672, 458,677, 366,826, 397,851,
          453,880, 458,878, 514,705, 512,697
        ]),
    polygonSection(
        id: '11', level: '1f', grade: SeatGrade.vip,
        polygon: [
          416,626, 409,627, 286,745, 286,750,
          304,772, 355,821, 360,820, 455,667,
          455,663
        ]),

    // ━━━ 1F 좌측 12~15 (R) ━━━
    polygonSection(
        id: '12', level: '1f', grade: SeatGrade.r,
        polygon: [
          356,549, 213,619, 237,673, 258,707,
          266,704, 381,602, 382,598
        ]),
    polygonSection(
        id: '13', level: '1f', grade: SeatGrade.r,
        polygon: [
          339,488, 183,502, 190,553, 208,610,
          212,611, 351,543, 353,539
        ]),
    polygonSection(
        id: '14', level: '1f', grade: SeatGrade.r,
        polygon: [180,396, 177,459, 182,495, 337,479, 332,410]),
    polygonSection(
        id: '15', level: '1f', grade: SeatGrade.r,
        polygon: [
          202,291, 187,344, 182,387, 335,402,
          346,342, 343,336, 208,288
        ]),

    // ━━━ 2F 우측 25~26 (A) ━━━
    polygonSection(
        id: '25', level: '2f', grade: SeatGrade.a,
        polygon: [1200,332, 1090,358, 1098,442, 1211,439, 1209,391]),
    polygonSection(
        id: '26', level: '2f', grade: SeatGrade.a,
        polygon: [1098,452, 1088,534, 1196,560, 1205,520, 1210,452]),

    // ━━━ 2F 우측 27~28 (S) ━━━
    polygonSection(
        id: '27', level: '2f', grade: SeatGrade.s,
        polygon: [1085,547, 1060,628, 1162,677, 1183,623, 1195,572, 1100,548]),
    polygonSection(
        id: '28', level: '2f', grade: SeatGrade.s,
        polygon: [1058,637, 1015,714, 1015,719, 1107,785, 1132,745, 1159,686]),

    // ━━━ 2F 우하단 곡선 29~30 (S) ━━━
    polygonSection(
        id: '29', level: '2f', grade: SeatGrade.s,
        polygon: [1010,725, 952,800, 1022,886, 1026,887, 1076,831, 1101,793]),
    polygonSection(
        id: '30', level: '2f', grade: SeatGrade.s,
        polygon: [
          944,806, 889,853, 886,859, 941,952,
          947,954, 995,917, 1018,893, 951,809
        ]),

    // ━━━ 2F 하단 31~36 (R) ━━━
    polygonSection(
        id: '31', level: '2f', grade: SeatGrade.r,
        polygon: [875,865, 805,902, 845,1006, 895,984, 931,962]),
    polygonSection(
        id: '32', level: '2f', grade: SeatGrade.r,
        polygon: [797,905, 720,929, 739,1038, 787,1028, 837,1010]),
    polygonSection(
        id: '33', level: '2f', grade: SeatGrade.r,
        polygon: [712,931, 631,938, 631,1049, 677,1048, 730,1040]),
    polygonSection(
        id: '34', level: '2f', grade: SeatGrade.r,
        polygon: [542,930, 538,939, 521,1039, 566,1047, 621,1049, 622,939]),
    polygonSection(
        id: '35', level: '2f', grade: SeatGrade.r,
        polygon: [455,905, 414,1008, 453,1024, 512,1038, 533,930]),
    polygonSection(
        id: '36', level: '2f', grade: SeatGrade.r,
        polygon: [377,865, 321,961, 364,987, 407,1005, 447,902]),

    // ━━━ 2F 좌하단 곡선 37~38 (S) ━━━
    polygonSection(
        id: '37', level: '2f', grade: SeatGrade.s,
        polygon: [
          305,806, 239,888, 236,896, 268,925,
          309,955, 365,864, 367,856, 309,806
        ]),
    polygonSection(
        id: '38', level: '2f', grade: SeatGrade.s,
        polygon: [
          243,725, 153,792, 154,798, 184,839,
          227,887, 233,884, 301,801, 298,793
        ]),

    // ━━━ 2F 좌측 39~40 (S) ━━━
    polygonSection(
        id: '39', level: '2f', grade: SeatGrade.s,
        polygon: [196,637, 95,686, 123,747, 147,785, 238,718]),
    polygonSection(
        id: '40', level: '2f', grade: SeatGrade.s,
        polygon: [167,546, 58,572, 71,625, 90,676, 192,629]),

    // ━━━ 2F 좌측 41~42 (A) ━━━
    polygonSection(
        id: '41', level: '2f', grade: SeatGrade.a,
        polygon: [42,453, 47,512, 57,560, 165,534, 155,452]),
    polygonSection(
        id: '42', level: '2f', grade: SeatGrade.a,
        polygon: [55,331, 45,383, 42,439, 155,442, 163,358]),
  ],
);
