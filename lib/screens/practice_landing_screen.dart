import 'package:flutter/material.dart';

import '../services/embedded_mode.dart';
import '../services/seo_service.dart';
import '../services/time_tracker.dart';
import '../widgets/ad_slot.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/seo_footer.dart';
import '../widgets/site_header.dart';
import 'queue_screen.dart';

class PracticeLandingScreen extends StatelessWidget {
  const PracticeLandingScreen({super.key});

  static const _title = '실전 티켓팅 연습 | 티켓팅캐치';
  static const _description = '대기열 진입부터 좌석 선택까지 티켓팅 흐름을 연습할 수 있습니다. '
      '전체 과정을 반복하며 티켓팅 감각을 키워보세요.';
  static const _path = '/practice';

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
          ('실전 티켓팅 연습', null),
        ]),
      ],
    );

    final embedded = isEmbeddedMode;

    return Title(
      title: _title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            children: [
              if (!embedded) const SiteHeader(),
              if (!embedded) const Breadcrumb(items: [
                BreadcrumbItem('홈', '/'),
                BreadcrumbItem('실전 티켓팅 연습'),
              ]),
              if (embedded)
                _buildEmbeddedContent(context)
              else
                _buildHeroContent(context),
              if (AdSlot.adsEnabled) const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: AdSlot(slotId: 'practice-bottom'),
              ),
              _buildSeoSection(),
              const SizedBox(height: 8),
              if (!embedded) const SeoFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmbeddedContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Center(
            child: FilledButton.icon(
              onPressed: () => _startPractice(context),
              icon: const Icon(Icons.play_circle_filled),
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
                  '실전 티켓팅 연습',
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
                '대기 단계부터 좌석 선택까지 티켓팅 흐름을 '
                '연습할 수 있는 모드입니다. 대기열에서 순서를 기다린 뒤, '
                'CAPTCHA를 통과하고, 공연장 좌석 배치도에서 원하는 구역과 '
                '좌석을 선택하는 전체 과정을 체험할 수 있습니다.',
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
                  icon: const Icon(Icons.play_circle_filled),
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
                '연습 과정',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '1. 대기열에서 입장 순서를 기다립니다.\n'
                '2. CAPTCHA 인증을 통과합니다.\n'
                '3. 공연장 전체 좌석 배치도에서 원하는 구역을 선택합니다.\n'
                '4. 선택한 구역 내에서 원하는 좌석을 클릭합니다.',
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QueueScreen(timeTracker: timeTracker),
      ),
    );
  }
}
