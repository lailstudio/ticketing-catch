import 'package:flutter/material.dart';

import '../data/venue_data_registry.dart';
import '../models/practice_config.dart';
import '../services/seo_service.dart';
import '../services/time_tracker.dart';
import '../widgets/ad_slot.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/seo_footer.dart';
import '../widgets/site_header.dart';
import 'venue_map_screen.dart';

class SeatPracticeLandingScreen extends StatelessWidget {
  const SeatPracticeLandingScreen({super.key});

  static const _title = '좌석 집중 연습 | 티켓팅캐치';
  static const _description = '공연장 구역을 선택한 뒤 좌석 선택 단계만 반복해서 연습할 수 있습니다. '
      '좌석 찾기와 클릭 속도에 집중하는 연습 모드입니다.';
  static const _path = '/seat-practice';

  @override
  Widget build(BuildContext context) {
    SeoService.update(
      description: _description,
      path: _path,
      ogTitle: _title,
      jsonLd: [
        SeoService.webPageSchema(
          name: _title,
          description: _description,
          path: _path,
        ),
        SeoService.breadcrumbSchema([
          ('홈', '/'),
          ('좌석 집중 연습', null),
        ]),
      ],
    );

    return Title(
      title: _title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SiteHeader(),
              const Breadcrumb(items: [
                BreadcrumbItem('홈', '/'),
                BreadcrumbItem('좌석 집중 연습'),
              ]),
              _buildHeroContent(context),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: AdSlot(slotId: 'seat-practice-bottom'),
              ),
              _buildSeoSection(),
              const SizedBox(height: 8),
              const SeoFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: const Text(
                  '좌석 집중 연습',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '공연장과 구역을 선택한 뒤 좌석 선택 단계만 '
                '반복해서 연습할 수 있습니다. 전체 티켓팅 과정을 반복하지 않고 '
                '좌석 찾기와 클릭 속도에 집중하고 싶은 사용자를 위한 모드입니다.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: FilledButton.icon(
                  onPressed: () => _startPractice(context),
                  icon: const Icon(Icons.grid_view_rounded),
                  label: const Text(
                    '연습 시작하기',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSeoSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '연습 흐름',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '1. 공연장 전체 좌석 배치도에서 원하는 구역을 선택합니다.\n'
                '2. 선택한 구역의 좌석 목록에서 원하는 좌석을 빠르게 클릭합니다.\n'
                '3. 반복해서 연습하며 선택 속도를 높일 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.8,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '실제 공연의 무대 및 좌석 배치는 공연마다 달라질 수 있으며, '
                '본 연습은 공연장 좌석 구조를 참고한 연습용 배치입니다.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPractice(BuildContext context) {
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
}
