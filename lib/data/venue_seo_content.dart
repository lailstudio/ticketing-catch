class VenueSeoContent {
  final String intro;
  final String seatPracticeDescription;
  final String practiceListIntro;
  final String metaDescription;

  const VenueSeoContent({
    required this.intro,
    required this.seatPracticeDescription,
    required this.practiceListIntro,
    required this.metaDescription,
  });
}

const venueSeoContents = <String, VenueSeoContent>{
  'kspo': VenueSeoContent(
    intro: 'KSPO DOME(올림픽체조경기장)은 서울 송파구 올림픽공원 내에 위치한 '
        '국내 대표 공연장입니다. 약 15,000석 규모의 좌석 구조를 참고해 '
        '구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
    seatPracticeDescription: '1층과 2층으로 나뉜 전체 좌석 배치도에서 '
        '원하는 구역을 선택한 뒤, 해당 구역 내 개별 좌석을 빠르게 '
        '선택하는 과정을 반복해서 연습할 수 있습니다.',
    practiceListIntro: 'KSPO DOME에서는 대기열부터 좌석 선택까지 '
        '전체 과정을 연습하는 실전 모드와, 좌석 선택에 집중하는 '
        '집중 연습 모드를 선택할 수 있습니다.',
    metaDescription: 'KSPO DOME(올림픽체조경기장) 티켓팅 연습. '
        '약 15,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 '
        '좌석 선택을 연습하세요.',
  ),
  'gocheok': VenueSeoContent(
    intro: '고척스카이돔은 서울 구로구에 위치한 국내 유일의 돔 경기장입니다. '
        '약 18,000석 규모의 넓은 좌석 구조를 참고해 '
        '구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
    seatPracticeDescription: '돔 형태의 넓은 경기장 특성상 구역이 많고 '
        '좌석 수가 많습니다. 전체 배치도에서 원하는 구역의 위치를 먼저 '
        '파악한 뒤, 해당 구역의 좌석을 빠르게 선택하는 연습을 할 수 있습니다.',
    practiceListIntro: '고척스카이돔에서는 대기열부터 좌석 선택까지 '
        '전체 과정을 연습하는 실전 모드와, 좌석 선택에 집중하는 '
        '집중 연습 모드를 선택할 수 있습니다.',
    metaDescription: '고척스카이돔 티켓팅 연습. '
        '약 18,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 '
        '좌석 선택을 연습하세요.',
  ),
  'jamsil': VenueSeoContent(
    intro: '잠실실내체육관은 서울 송파구 잠실종합운동장 내에 위치한 '
        '실내 공연장입니다. 약 11,000석 규모의 좌석 구조를 참고해 '
        '구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
    seatPracticeDescription: '아레나 형태의 실내체육관으로, 플로어석과 '
        '스탠드석으로 구성됩니다. 전체 배치도에서 원하는 구역을 선택한 뒤, '
        '해당 구역의 좌석을 빠르게 선택하는 연습을 할 수 있습니다.',
    practiceListIntro: '잠실실내체육관에서는 대기열부터 좌석 선택까지 '
        '전체 과정을 연습하는 실전 모드와, 좌석 선택에 집중하는 '
        '집중 연습 모드를 선택할 수 있습니다.',
    metaDescription: '잠실실내체육관 티켓팅 연습. '
        '약 11,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 '
        '좌석 선택을 연습하세요.',
  ),
  'inspire': VenueSeoContent(
    intro: '인스파이어 아레나는 인천 영종도 인스파이어 리조트 내에 위치한 '
        '대규모 공연장입니다. 약 15,000석 규모의 좌석 구조를 참고해 '
        '구역 선택과 좌석 선택 과정을 연습할 수 있습니다.',
    seatPracticeDescription: '최신 시설의 대형 아레나로, 다양한 구역이 '
        '배치되어 있습니다. 전체 배치도에서 원하는 구역을 선택한 뒤, '
        '해당 구역의 좌석을 빠르게 선택하는 연습을 할 수 있습니다.',
    practiceListIntro: '인스파이어 아레나에서는 대기열부터 좌석 선택까지 '
        '전체 과정을 연습하는 실전 모드와, 좌석 선택에 집중하는 '
        '집중 연습 모드를 선택할 수 있습니다.',
    metaDescription: '인스파이어 아레나 티켓팅 연습. '
        '약 15,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 '
        '좌석 선택을 연습하세요.',
  ),
  'olympic': VenueSeoContent(
    intro: '올림픽홀은 서울 송파구 올림픽공원 내에 위치한 중규모 공연장입니다. '
        '약 5,000석 규모로 비교적 아늑한 구조이며, '
        '좌석 간 거리가 가까워 빠른 선택이 중요합니다.',
    seatPracticeDescription: '상대적으로 적은 좌석 수이지만, 인기 공연의 경우 '
        '좌석 선택 경쟁이 치열합니다. 전체 배치도에서 원하는 구역을 선택한 뒤, '
        '해당 구역의 좌석을 빠르게 선택하는 연습을 할 수 있습니다.',
    practiceListIntro: '올림픽홀에서는 대기열부터 좌석 선택까지 '
        '전체 과정을 연습하는 실전 모드와, 좌석 선택에 집중하는 '
        '집중 연습 모드를 선택할 수 있습니다.',
    metaDescription: '올림픽홀 티켓팅 연습. '
        '약 5,000석 규모의 좌석 구조를 참고한 배치에서 구역 선택과 '
        '좌석 선택을 연습하세요.',
  ),
};
