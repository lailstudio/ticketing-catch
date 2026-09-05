import 'package:flutter/material.dart';

import '../data/venue_data_registry.dart';
import '../data/venue_seo_content.dart';
import '../models/practice_config.dart';
import '../models/venue_preset.dart';
import '../services/seo_service.dart';
import '../services/time_tracker.dart';
import '../widgets/ad_slot.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/seo_footer.dart';
import '../widgets/site_header.dart';
import '../widgets/venue_image.dart';
import '../widgets/venue_links_section.dart';
import 'queue_screen.dart';
import 'venue_map_screen.dart';

class VenueDetailScreen extends StatelessWidget {
  final VenuePreset venuePreset;

  const VenueDetailScreen({super.key, required this.venuePreset});

  @override
  Widget build(BuildContext context) {
    final seo = venueSeoContents[venuePreset.id];
    final path = '/venue/${venuePreset.slug}';

    SeoService.update(
      description: seo?.metaDescription ?? venuePreset.shortDescription.replaceAll('\n', ' '),
      path: path,
      ogTitle: venuePreset.pageTitle,
      ogImage: venuePreset.imageAsset != null
          ? '$siteBaseUrl/assets/${venuePreset.imageAsset}'
          : null,
      jsonLd: [
        SeoService.webPageSchema(
          name: venuePreset.pageTitle,
          description: seo?.metaDescription ?? venuePreset.shortDescription.replaceAll('\n', ' '),
          path: path,
        ),
        SeoService.breadcrumbSchema([
          ('홈', '/'),
          ('공연장별 연습', '/'),
          (venuePreset.name, null),
        ]),
      ],
    );

    return Title(
      title: venuePreset.pageTitle,
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
                  Breadcrumb(items: [
                    const BreadcrumbItem('홈', '/'),
                    const BreadcrumbItem('공연장별 연습', '/'),
                    BreadcrumbItem(venuePreset.name),
                  ]),
                  if (screenWidth > 800)
                    _buildDesktopLayout(context, screenWidth)
                  else
                    _buildMobileLayout(context, screenWidth),
                  _buildTipSection(context, screenWidth),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 800 ? 48 : 20,
                      vertical: 4,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1200),
                        child: VenueLinksSection(
                          currentSlug: venuePreset.slug,
                        ),
                      ),
                    ),
                  ),
                  if (AdSlot.adsEnabled) Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth > 800 ? 48 : 20,
                      vertical: 10,
                    ),
                    child: const AdSlot(slotId: 'venue-detail-bottom'),
                  ),
                  if (seo != null)
                    _buildSeoContent(context, screenWidth, seo),
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

  Widget _buildDesktopLayout(BuildContext context, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: VenueImage(
                  venueId: venuePreset.id,
                  imageAsset: venuePreset.imageAsset,
                  semanticLabel: venuePreset.altText,
                  height: 340,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const SizedBox(width: 32),
              Expanded(
                flex: 6,
                child: _buildInfoColumn(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, double screenWidth) {
    return Column(
      children: [
        VenueImage(
          venueId: venuePreset.id,
          imageAsset: venuePreset.imageAsset,
          semanticLabel: venuePreset.altText,
          height: 240,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: _buildInfoColumn(context),
        ),
      ],
    );
  }

  Widget _buildInfoColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F0FF),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            '공연장 연습',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Semantics(
          header: true,
          child: Text(
            venuePreset.heading,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
              height: 1.3,
            ),
          ),
        ),
        if (venuePreset.alias != null) ...[
          const SizedBox(height: 4),
          Text(
            venuePreset.alias!,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            venuePreset.representativeLayoutLabel,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          venuePreset.shortDescription.replaceAll('\n', ' '),
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          venuePreset.disclaimer,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[400],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 24),
        _buildPracticeModeCards(context),
        const SizedBox(height: 24),
        _buildInfoSidebar(),
      ],
    );
  }

  Widget _buildPracticeModeCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '연습 모드 선택',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 12),
        _buildPracticeModeCard(
          icon: Icons.play_circle_filled,
          title: '실전 티켓팅 연습',
          subtitle: '대기열 · CAPTCHA · 좌석 선택',
          color: const Color(0xFF5C2D91),
          onTap: () => _startFullPractice(context),
        ),
        const SizedBox(height: 10),
        _buildPracticeModeCard(
          icon: Icons.grid_view_rounded,
          title: '좌석 집중 연습',
          subtitle: '좌석 선택부터 포도알 클릭까지 집중 연습',
          color: const Color(0xFF1565C0),
          onTap: () => _startFocusedPractice(context),
        ),
      ],
    );
  }

  Widget _buildPracticeModeCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withValues(alpha: 0.2)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Icon(icon, size: 28, color: color),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: color.withValues(alpha: 0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSidebar() {
    final items = <_InfoItem>[
      _InfoItem('공연장', venuePreset.name),
      const _InfoItem('연습 배치', '대표 콘서트 배치 기반'),
      if (venuePreset.capacity != null)
        _InfoItem('공연장 규모', venuePreset.capacity!),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '연습 정보',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 12),
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      item.value,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 4),
          Text(
            '실제 판매 좌석 수는 공연 및 무대 배치에 따라 달라질 수 있습니다.',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[400],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipSection(BuildContext context, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 800 ? 48 : 20,
        vertical: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFEF5),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFECB3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  size: 18,
                  color: Color(0xFFFF8F00),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'TIP',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF8F00),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '실전 티켓팅 연습으로 전체 흐름을 파악한 후, '
                        '좌석 집중 연습으로 빠른 좌석 선택 감각을 키워보세요.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeoContent(
    BuildContext context,
    double screenWidth,
    VenueSeoContent seo,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth > 800 ? 48 : 20,
        vertical: 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${venuePreset.name} 좌석 배치 연습',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                seo.seatPracticeDescription,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                '어떤 연습을 할 수 있나요?',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                seo.practiceListIntro,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 6),
              _buildPracticeListItems(),
              const SizedBox(height: 8),
              Text(
                venuePreset.disclaimer,
                style: TextStyle(
                  fontSize: 11,
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

  Widget _buildPracticeListItems() {
    const items = [
      '실전 티켓팅 연습 — 대기열부터 좌석 선택까지',
      '좌석 집중 연습 — 구역과 좌석 선택에 집중',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '• ',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[500],
                      height: 1.6,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  void _startFullPractice(BuildContext context) {
    final timeTracker = TimeTracker();
    timeTracker.markPracticeStarted();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QueueScreen(timeTracker: timeTracker),
      ),
    );
  }

  void _startFocusedPractice(BuildContext context) {
    final timeTracker = TimeTracker();
    timeTracker.markPracticeStarted();
    timeTracker.markSectionEntered();
    const config = PracticeConfig(mode: PracticeMode.focused);
    final venue = venueDataFor(venuePreset.id);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VenueMapScreen(
          timeTracker: timeTracker,
          config: config,
          venue: venue,
          venueId: venuePreset.id,
        ),
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;
  const _InfoItem(this.label, this.value);
}
