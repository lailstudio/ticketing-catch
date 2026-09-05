import '../models/venue_preset.dart';

const venuePresets = <VenuePreset>[
  VenuePreset(
    id: 'gocheok',
    slug: 'gocheok-sky-dome',
    name: '고척스카이돔',
    shortName: '고척돔',
    description: '서울 구로구 소재 다목적 돔 경기장. 약 18,000석 규모.',
    tagline: '국내 최초 돔 경기장에서 연습하기',
    pageTitle: '고척스카이돔 티켓팅 연습 | 티켓팅캐치',
    heading: '고척스카이돔 티켓팅 연습',
    shortDescription: '고척스카이돔의 좌석 구조를 참고한 배치에서\n티켓팅 과정을 연습해보세요.',
    representativeLayoutLabel: '콘서트 기본배치',
    imageAsset: 'assets/venues/gocheok_sky_dome.png',
    capacity: '약 18,000석',
    difficulty: 4,
    altText: '고척스카이돔 공연장 외관',
  ),
  VenuePreset(
    id: 'kspo',
    slug: 'kspo-dome',
    name: 'KSPO DOME',
    shortName: 'KSPO',
    description: '서울 송파구 올림픽공원 내 체조경기장. 약 15,000석 규모.',
    tagline: '올림픽공원 체조경기장에서 연습하기',
    pageTitle: 'KSPO DOME 티켓팅 연습 | 티켓팅캐치',
    heading: 'KSPO DOME 티켓팅 연습',
    shortDescription: 'KSPO DOME의 좌석 구조를 참고한 배치에서\n티켓팅 과정을 연습해보세요.',
    representativeLayoutLabel: '콘서트 기본배치',
    imageAsset: 'assets/venues/kspo_dome.png',
    capacity: '약 15,000석',
    difficulty: 4,
    alias: '올림픽체조경기장',
    altText: 'KSPO DOME 공연장 외관',
  ),
  VenuePreset(
    id: 'jamsil',
    slug: 'jamsil-indoor-stadium',
    name: '잠실실내체육관',
    shortName: '잠실',
    description: '서울 송파구 잠실종합운동장 내 실내체육관. 약 11,000석 규모.',
    tagline: '잠실실내체육관에서 연습하기',
    pageTitle: '잠실실내체육관 티켓팅 연습 | 티켓팅캐치',
    heading: '잠실실내체육관 티켓팅 연습',
    shortDescription: '잠실실내체육관의 좌석 구조를 참고한 배치에서\n티켓팅 과정을 연습해보세요.',
    representativeLayoutLabel: '콘서트 기본배치',
    imageAsset: 'assets/venues/jamsil_indoor_gymnasium.png',
    capacity: '약 11,000석',
    difficulty: 3,
    altText: '잠실실내체육관 공연장 외관',
  ),
  VenuePreset(
    id: 'inspire',
    slug: 'inspire-arena',
    name: '인스파이어 아레나',
    shortName: '인스파이어',
    description: '인천 영종도 인스파이어 리조트 내 공연장. 약 15,000석 규모.',
    tagline: '인스파이어 아레나에서 연습하기',
    pageTitle: '인스파이어 아레나 티켓팅 연습 | 티켓팅캐치',
    heading: '인스파이어 아레나 티켓팅 연습',
    shortDescription: '인스파이어 아레나의 좌석 구조를 참고한 배치에서\n티켓팅 과정을 연습해보세요.',
    representativeLayoutLabel: '콘서트 기본배치',
    imageAsset: 'assets/venues/inspire_arena.png',
    capacity: '약 15,000석',
    difficulty: 3,
    altText: '인스파이어 아레나 공연장 외관',
  ),
  VenuePreset(
    id: 'olympic',
    slug: 'olympic-hall',
    name: '올림픽홀',
    shortName: '올림픽홀',
    description: '서울 송파구 올림픽공원 내 공연장. 약 5,000석 규모.',
    tagline: '올림픽홀에서 연습하기',
    pageTitle: '올림픽홀 티켓팅 연습 | 티켓팅캐치',
    heading: '올림픽홀 티켓팅 연습',
    shortDescription: '올림픽홀의 좌석 구조를 참고한 배치에서\n티켓팅 과정을 연습해보세요.',
    representativeLayoutLabel: '콘서트 기본배치',
    imageAsset: 'assets/venues/olympic_hall.png',
    capacity: '약 5,000석',
    difficulty: 2,
    altText: '올림픽홀 공연장 외관',
  ),
];

VenuePreset? findPresetBySlug(String slug) {
  for (final preset in venuePresets) {
    if (preset.slug == slug) return preset;
  }
  return null;
}

VenuePreset? findPresetById(String id) {
  for (final preset in venuePresets) {
    if (preset.id == id) return preset;
  }
  return null;
}
