import 'package:flutter/material.dart';

import '../services/seo_service.dart';
import '../widgets/ad_slot.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/seo_footer.dart';
import '../widgets/site_header.dart';
import 'grape_drill_screen.dart';

class GrapePracticeLandingScreen extends StatelessWidget {
  const GrapePracticeLandingScreen({super.key});

  static const _title = '포도알 연습 | 티켓팅캐치';
  static const _description = '티켓팅에서 빈 좌석을 빠르게 찾아 클릭하는 연습입니다. '
      '랜덤 좌석 중 선택 가능한 좌석을 찾아 반복 클릭하며 탐색 속도와 정확도를 높이세요.';
  static const _path = '/grape-practice';

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
          ('포도알 연습', null),
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
                BreadcrumbItem('포도알 연습'),
              ]),
              _buildHeroContent(context),
              if (AdSlot.adsEnabled) const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: AdSlot(slotId: 'grape-practice-bottom'),
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
                  '포도알 연습',
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
                '티켓팅에서 빈 좌석을 빠르게 찾아 클릭하는 상황을 '
                '연습할 수 있습니다. 랜덤하게 표시되는 좌석 중 '
                '선택 가능한 좌석을 빠르게 찾아 반복해서 클릭하며 '
                '시각적인 탐색 속도와 클릭 정확도를 연습합니다.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[600],
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: FilledButton.icon(
                  onPressed: () => _startDrill(context),
                  icon: const Icon(Icons.circle),
                  label: const Text(
                    '연습 시작하기',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
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
                '포도알 연습이란?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '티켓팅 사용자들이 좌석 선택 화면에서 빈 좌석이 '
                '작은 원 모양으로 표시되는 것을 보고 '
                '"포도알"이라고 부르는 데서 유래한 표현입니다. '
                '인기 공연의 경우 수백 개의 좌석 중 빈 좌석을 빠르게 '
                '찾아 클릭해야 하므로, 시각적 탐색 속도가 중요합니다.',
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

  void _startDrill(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const GrapeDrillScreen(),
      ),
    );
  }
}
