import 'package:flutter/material.dart';

import '../data/venue_data_registry.dart';
import '../data/venue_presets.dart';
import '../models/practice_config.dart';
import '../screens/grape_drill_screen.dart';
import '../screens/queue_screen.dart';
import '../screens/venue_map_screen.dart';
import '../services/seo_service.dart';
import '../services/time_tracker.dart';
import '../widgets/ad_slot.dart';
import '../widgets/seo_footer.dart';
import '../widgets/site_header.dart';
import '../widgets/venue_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _practiceKey = GlobalKey();

  void _startFullPractice(BuildContext context) {
    final timeTracker = TimeTracker();
    timeTracker.markPracticeStarted();
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => QueueScreen(timeTracker: timeTracker)),
    );
  }

  void _startSeatPractice(BuildContext context) {
    final timeTracker = TimeTracker();
    timeTracker.markPracticeStarted();
    timeTracker.markSectionEntered();
    const config = PracticeConfig(mode: PracticeMode.focused);
    final venue = venueDataFor(null);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VenueMapScreen(
          timeTracker: timeTracker,
          config: config,
          venue: venue,
        ),
      ),
    );
  }

  void _startGrapePractice(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const GrapeDrillScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SeoService.update(
      description: '실전처럼 티켓팅을 연습하세요. '
          '대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 구조를 참고한 연습.',
      path: '/',
      ogTitle: '티켓팅캐치 | 실전 티켓팅 · 좌석 집중 연습',
      jsonLd: [
        SeoService.webSiteSchema(),
        SeoService.webPageSchema(
          name: '티켓팅캐치',
          description: '실전처럼 티켓팅을 연습하세요. '
              '대기열, CAPTCHA, 좌석 선택까지 주요 공연장 좌석 구조를 참고한 연습.',
          path: '/',
        ),
      ],
    );

    return Title(
      title: '티켓팅캐치 | 실전 티켓팅 · 좌석 집중 연습',
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SiteHeader(),
                  _buildHero(context, screenWidth),
                _buildPracticeModeCards(context, screenWidth),
                _buildVenueGrid(context, screenWidth),
                if (AdSlot.adsEnabled) Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth > 800 ? 48 : 20,
                    vertical: 20,
                  ),
                  child: const AdSlot(slotId: 'home-bottom'),
                ),
                _buildSeoSection(screenWidth),
                const SizedBox(height: 8),
                const SeoFooter(),
              ],
            ),
          );
        },
      ),
      ),
    );
  }

  Widget _buildHero(BuildContext context, double screenWidth) {
    final isWide = screenWidth > 800;

    final textColumn = Column(
      crossAxisAlignment:
          isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '티켓팅캐치',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: isWide ? 14 : 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: isWide ? 4 : 2),
        Semantics(
          header: true,
          child: Text.rich(
            TextSpan(
              style: TextStyle(
                fontSize: isWide ? 28 : 22,
                fontWeight: FontWeight.w800,
                height: 1.2,
                letterSpacing: -0.5,
              ),
              children: [
                TextSpan(
                  text: '티켓팅',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const TextSpan(
                  text: '은 ',
                  style: TextStyle(color: Color(0xFF1A1A1A)),
                ),
                TextSpan(
                  text: '연습',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
                const TextSpan(
                  text: '이 실력입니다',
                  style: TextStyle(color: Color(0xFF1A1A1A)),
                ),
              ],
            ),
            textAlign: isWide ? TextAlign.start : TextAlign.center,
          ),
        ),
        SizedBox(height: isWide ? 8 : 4),
        Text(
          '정각 진입부터 좌석 선택까지, 실전처럼 연습하세요',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: isWide ? 1.5 : 1.4,
          ),
        ),
        SizedBox(height: isWide ? 10 : 8),
        FilledButton(
          onPressed: () => _startFullPractice(context),
          style: FilledButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 28, vertical: isWide ? 14 : 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            '연습 시작하기',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

    final imageWidget = Image.asset(
      'assets/home/hero_ticket.png',
      fit: BoxFit.contain,
      height: isWide ? 180 : 80,
      errorBuilder: (context, error, stackTrace) => SizedBox(
        height: isWide ? 180 : 80,
        child: const Center(
          child: Icon(Icons.confirmation_number, size: 40, color: Color(0xFFB39DDB)),
        ),
      ),
    );

    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.only(
        top: isWide ? 20 : 4,
        bottom: isWide ? 24 : 6,
        left: screenWidth > 800 ? 48 : 24,
        right: screenWidth > 800 ? 48 : 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: textColumn),
                    const SizedBox(width: 40),
                    Expanded(child: imageWidget),
                  ],
                )
              : Column(
                  children: [
                    imageWidget,
                    const SizedBox(height: 4),
                    textColumn,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPracticeModeCards(BuildContext context, double screenWidth) {
    return Container(
      key: _practiceKey,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 800 ? 48 : 20,
        vertical: 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '어떤 연습을 할까요?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 10),
              if (screenWidth > 700)
                Row(
                  children: [
                    Expanded(
                      child: _buildModeCard(
                        icon: Icons.play_circle_filled,
                        title: '실전 티켓팅 연습',
                        description: '대기열 → CAPTCHA → 좌석 선택 전 과정',
                        color: const Color(0xFF5C2D91),
                        onTap: () => _startFullPractice(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModeCard(
                        icon: Icons.grid_view_rounded,
                        title: '좌석 집중 연습',
                        description: '좌석 선택부터 포도알 클릭까지',
                        color: const Color(0xFF1565C0),
                        onTap: () => _startSeatPractice(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildModeCard(
                        icon: Icons.circle,
                        title: '포도알 연습',
                        description: '활성 좌석을 빠르게 찾아 클릭',
                        color: const Color(0xFF00897B),
                        onTap: () => _startGrapePractice(context),
                      ),
                    ),
                  ],
                )
              else if (screenWidth > 480)
                Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildModeCard(
                            icon: Icons.play_circle_filled,
                            title: '실전 티켓팅 연습',
                            description: '대기열 → CAPTCHA → 좌석 선택 전 과정',
                            color: const Color(0xFF5C2D91),
                            onTap: () => _startFullPractice(context),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _buildModeCard(
                            icon: Icons.grid_view_rounded,
                            title: '좌석 집중 연습',
                            description: '좌석 선택부터 포도알 클릭까지',
                            color: const Color(0xFF1565C0),
                            onTap: () => _startSeatPractice(context),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    _buildModeCard(
                      icon: Icons.circle,
                      title: '포도알 연습',
                      description: '활성 좌석을 빠르게 찾아 클릭',
                      color: const Color(0xFF00897B),
                      onTap: () => _startGrapePractice(context),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _buildModeCard(
                      icon: Icons.play_circle_filled,
                      title: '실전 티켓팅 연습',
                      description: '대기열 → CAPTCHA → 좌석 선택 전 과정',
                      color: const Color(0xFF5C2D91),
                      onTap: () => _startFullPractice(context),
                    ),
                    const SizedBox(height: 8),
                    _buildModeCard(
                      icon: Icons.grid_view_rounded,
                      title: '좌석 집중 연습',
                      description: '좌석 선택부터 포도알 클릭까지',
                      color: const Color(0xFF1565C0),
                      onTap: () => _startSeatPractice(context),
                    ),
                    const SizedBox(height: 8),
                    _buildModeCard(
                      icon: Icons.circle,
                      title: '포도알 연습',
                      description: '활성 좌석을 빠르게 찾아 클릭',
                      color: const Color(0xFF00897B),
                      onTap: () => _startGrapePractice(context),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: color.withValues(alpha: 0.15)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVenueGrid(BuildContext context, double screenWidth) {
    final venues = venuePresets.where((p) => p.enabled).toList();

    final totalCount = venues.length + 1;

    final Widget cardGrid;
    if (screenWidth > 700) {
      final crossAxisCount = screenWidth > 1000 ? 6 : 3;
      final childAspectRatio = screenWidth > 1000 ? 0.68 : 0.85;
      cardGrid = GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: totalCount,
        itemBuilder: (context, index) {
          if (index < venues.length) {
            final preset = venues[index];
            return VenueCard(
              preset: preset,
              onTap: () {
                Navigator.of(context).pushNamed('/venue/${preset.slug}');
              },
            );
          }
          return _buildCharmCard(context);
        },
      );
    } else {
      cardGrid = LayoutBuilder(
        builder: (_, constraints) {
          final cardWidth = (constraints.maxWidth - 14) / 2;
          return Wrap(
            spacing: 14,
            runSpacing: 14,
            children: List.generate(totalCount, (index) {
              final child = index < venues.length
                  ? VenueCard(
                      preset: venues[index],
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed('/venue/${venues[index].slug}');
                      },
                    )
                  : _buildCharmCard(context);
              return SizedBox(width: cardWidth, child: child);
            }),
          );
        },
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: screenWidth > 800 ? 48 : 20,
        right: screenWidth > 800 ? 48 : 20,
        top: 28,
        bottom: 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '공연장별 티켓팅 연습',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '주요 공연장의 좌석 구조를 참고해 연습해보세요',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 20),
              cardGrid,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharmCard(BuildContext context) {
    return Material(
      color: const Color(0xFFFAF5FF),
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.of(context).pushNamed('/ticketing-charm');
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: Image.asset(
                  'assets/home/charm_banner.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (_, _, _) => Container(
                    color: const Color(0xFFF3E5F5),
                    child: const Center(
                      child: Icon(Icons.auto_awesome, size: 32, color: Color(0xFF9C27B0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '티켓팅 부적',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '티켓팅 전 행운을 챙겨보세요',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '부적 보러가기 →',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeoSection(double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 800 ? 48 : 20,
        vertical: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '티켓팅캐치란?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '티켓팅캐치는 콘서트 티켓팅 흐름을 참고해 '
                '대기열 진입부터 좌석 선택까지 연습할 수 있는 서비스입니다. '
                'KSPO DOME, 고척스카이돔, 잠실실내체육관, '
                '인스파이어 아레나, 올림픽홀 등 주요 공연장의 '
                '좌석 구조를 참고한 배치에서 원하는 구역과 좌석을 '
                '빠르게 선택하는 연습을 할 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '실전 티켓팅 연습뿐 아니라 '
                '좌석 집중 연습과 포도알 연습을 통해 '
                '좌석을 찾고 클릭하는 속도도 반복해서 연습할 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.7,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
