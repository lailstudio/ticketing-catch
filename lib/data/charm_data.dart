class CharmItem {
  final String id;
  final String name;
  final String altText;
  final String thumbnailAsset;
  final String? kakaoAsset;
  final String? photocardAsset;

  const CharmItem({
    required this.id,
    required this.name,
    required this.altText,
    required this.thumbnailAsset,
    this.kakaoAsset,
    this.photocardAsset,
  });

  bool get hasVariants => kakaoAsset != null && photocardAsset != null;
}

class CharmSeries {
  final String id;
  final String title;
  final String subtitle;
  final List<CharmItem> items;
  final double imageAspectRatio;

  const CharmSeries({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.items,
    required this.imageAspectRatio,
  });
}

const charmSeriesList = <CharmSeries>[
  CharmSeries(
    id: 'ghost',
    title: '유령 부적',
    subtitle: '귀여운 유령 캐릭터로 만든 티켓팅 행운 부적',
    imageAspectRatio: 241 / 242,
    items: [
      CharmItem(
        id: 'ghost_01',
        name: '유령 티켓팅 성공 부적',
        altText: '유령 티켓팅 성공 부적 - 콘서트 티켓팅 성공 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/ghost/01_ticketing_success_kakao.png',
        kakaoAsset: 'assets/charms/ghost/01_ticketing_success_kakao.png',
        photocardAsset: 'assets/charms/ghost/01_ticketing_success_photocard.png',
      ),
      CharmItem(
        id: 'ghost_02',
        name: '유령 포도알 발견 부적',
        altText: '유령 포도알 발견 부적 - 빈 좌석 포도알 발견 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/ghost/02_grape_found_kakao.png',
        kakaoAsset: 'assets/charms/ghost/02_grape_found_kakao.png',
        photocardAsset: 'assets/charms/ghost/02_grape_found_photocard.png',
      ),
      CharmItem(
        id: 'ghost_03',
        name: '유령 앞자리 당첨 부적',
        altText: '유령 앞자리 당첨 부적 - 앞자리 당첨 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/ghost/03_front_row_kakao.png',
        kakaoAsset: 'assets/charms/ghost/03_front_row_kakao.png',
        photocardAsset: 'assets/charms/ghost/03_front_row_photocard.png',
      ),
      CharmItem(
        id: 'ghost_04',
        name: '유령 이선좌 방지 부적',
        altText: '유령 이선좌 방지 부적 - 이선좌 방지 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/ghost/04_no_iseonjwa_kakao.png',
        kakaoAsset: 'assets/charms/ghost/04_no_iseonjwa_kakao.png',
        photocardAsset: 'assets/charms/ghost/04_no_iseonjwa_photocard.png',
      ),
      CharmItem(
        id: 'ghost_05',
        name: '유령 취켓팅 성공 부적',
        altText: '유령 취켓팅 성공 부적 - 취소표 티켓팅 성공 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/ghost/05_cancel_ticket_kakao.png',
        kakaoAsset: 'assets/charms/ghost/05_cancel_ticket_kakao.png',
        photocardAsset: 'assets/charms/ghost/05_cancel_ticket_photocard.png',
      ),
      CharmItem(
        id: 'ghost_06',
        name: '유령 최애 포카 뽑기 부적',
        altText: '유령 최애 포카 뽑기 부적 - 최애 포토카드 뽑기 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/ghost/06_bias_photocard_kakao.png',
        kakaoAsset: 'assets/charms/ghost/06_bias_photocard_kakao.png',
        photocardAsset: 'assets/charms/ghost/06_bias_photocard_photocard.png',
      ),
    ],
  ),
  CharmSeries(
    id: 'figure',
    title: '피규어 부적',
    subtitle: '3D 피규어 스타일의 티켓팅 행운 부적',
    imageAspectRatio: 210 / 314,
    items: [
      CharmItem(
        id: 'figure_01',
        name: '피규어 티켓팅 성공 부적',
        altText: '피규어 티켓팅 성공 부적 - 콘서트 티켓팅 성공 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/figure/01_ticketing_success_vivid.png',
      ),
      CharmItem(
        id: 'figure_02',
        name: '피규어 포도알 발견 부적',
        altText: '피규어 포도알 발견 부적 - 빈 좌석 포도알 발견 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/figure/02_grape_found_vivid.png',
      ),
      CharmItem(
        id: 'figure_03',
        name: '피규어 앞자리 당첨 부적',
        altText: '피규어 앞자리 당첨 부적 - 앞자리 당첨 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/figure/03_front_row_vivid.png',
      ),
      CharmItem(
        id: 'figure_04',
        name: '피규어 이선좌 방지 부적',
        altText: '피규어 이선좌 방지 부적 - 이선좌 방지 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/figure/04_no_iseonjwa_vivid.png',
      ),
      CharmItem(
        id: 'figure_05',
        name: '피규어 취켓팅 성공 부적',
        altText: '피규어 취켓팅 성공 부적 - 취소표 티켓팅 성공 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/figure/05_cancel_ticket_vivid.png',
      ),
      CharmItem(
        id: 'figure_06',
        name: '피규어 최애 포카 뽑기 부적',
        altText: '피규어 최애 포카 뽑기 부적 - 최애 포토카드 뽑기 기원 무료 다운로드',
        thumbnailAsset: 'assets/charms/figure/06_bias_photocard_vivid.png',
      ),
    ],
  ),
  CharmSeries(
    id: 'zodiac',
    title: '12간지 부적',
    subtitle: '12간지 캐릭터로 만든 티켓팅 행운 부적',
    imageAspectRatio: 1.0,
    items: [
      CharmItem(
        id: 'zodiac_01',
        name: '쥐띠 티켓팅 부적',
        altText: '쥐띠 티켓팅 부적 - 쥐띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/01_rat_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/01_rat_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/01_rat_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_02',
        name: '소띠 티켓팅 부적',
        altText: '소띠 티켓팅 부적 - 소띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/02_ox_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/02_ox_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/02_ox_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_03',
        name: '호랑이띠 티켓팅 부적',
        altText: '호랑이띠 티켓팅 부적 - 호랑이띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/03_tiger_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/03_tiger_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/03_tiger_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_04',
        name: '토끼띠 티켓팅 부적',
        altText: '토끼띠 티켓팅 부적 - 토끼띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/04_rabbit_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/04_rabbit_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/04_rabbit_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_05',
        name: '용띠 티켓팅 부적',
        altText: '용띠 티켓팅 부적 - 용띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/05_dragon_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/05_dragon_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/05_dragon_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_06',
        name: '뱀띠 티켓팅 부적',
        altText: '뱀띠 티켓팅 부적 - 뱀띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/06_snake_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/06_snake_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/06_snake_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_07',
        name: '말띠 티켓팅 부적',
        altText: '말띠 티켓팅 부적 - 말띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/07_horse_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/07_horse_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/07_horse_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_08',
        name: '양띠 티켓팅 부적',
        altText: '양띠 티켓팅 부적 - 양띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/08_sheep_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/08_sheep_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/08_sheep_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_09',
        name: '원숭이띠 티켓팅 부적',
        altText: '원숭이띠 티켓팅 부적 - 원숭이띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/09_monkey_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/09_monkey_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/09_monkey_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_10',
        name: '닭띠 티켓팅 부적',
        altText: '닭띠 티켓팅 부적 - 닭띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/10_rooster_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/10_rooster_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/10_rooster_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_11',
        name: '개띠 티켓팅 부적',
        altText: '개띠 티켓팅 부적 - 개띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/11_dog_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/11_dog_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/11_dog_photocard.png',
      ),
      CharmItem(
        id: 'zodiac_12',
        name: '돼지띠 티켓팅 부적',
        altText: '돼지띠 티켓팅 부적 - 돼지띠 콘서트 티켓팅 행운 무료 다운로드',
        thumbnailAsset: 'assets/charms/zodiac/kakao/12_pig_kakao.png',
        kakaoAsset: 'assets/charms/zodiac/kakao/12_pig_kakao.png',
        photocardAsset: 'assets/charms/zodiac/photocard/12_pig_photocard.png',
      ),
    ],
  ),
];
