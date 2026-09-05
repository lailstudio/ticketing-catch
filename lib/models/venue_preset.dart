class VenuePreset {
  final String id;
  final String slug;
  final String name;
  final String shortName;
  final String description;
  final String tagline;
  final bool enabled;
  final String? seatLayoutId;
  final String pageTitle;
  final String heading;
  final String shortDescription;
  final String representativeLayoutLabel;
  final String disclaimer;
  final String? imageAsset;
  final String? capacity;
  final int? difficulty;
  final String? alias;
  final String altText;

  const VenuePreset({
    required this.id,
    required this.slug,
    required this.name,
    required this.shortName,
    required this.description,
    required this.tagline,
    this.enabled = true,
    this.seatLayoutId,
    required this.pageTitle,
    required this.heading,
    required this.shortDescription,
    required this.representativeLayoutLabel,
    this.disclaimer = '실제 공연의 무대 및 좌석 배치는 공연마다 달라질 수 있으며, '
        '본 연습은 공연장 좌석 구조를 참고한 연습용 배치입니다.',
    this.imageAsset,
    this.capacity,
    this.difficulty,
    this.alias,
    this.altText = '',
  });
}
