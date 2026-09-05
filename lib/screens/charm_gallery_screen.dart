// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/charm_data.dart';
import '../data/venue_data_registry.dart';
import '../models/practice_config.dart';
import '../services/seo_service.dart';
import '../services/time_tracker.dart';
import 'grape_drill_screen.dart';
import 'queue_screen.dart';
import 'venue_map_screen.dart';
import '../widgets/ad_slot.dart';
import '../widgets/breadcrumb.dart';
import '../widgets/seo_footer.dart';
import '../widgets/site_header.dart';

class CharmGalleryScreen extends StatefulWidget {
  const CharmGalleryScreen({super.key});

  @override
  State<CharmGalleryScreen> createState() => _CharmGalleryScreenState();
}

class _CharmGalleryScreenState extends State<CharmGalleryScreen> {
  static const _title =
      '티켓팅 부적 무료 다운로드 | 티켓팅 성공 · 포도알 · 취켓팅 부적 - 티켓팅캐치';
  static const _description =
      '콘서트 티켓팅 성공을 기원하는 티켓팅 부적 무료 다운로드. '
      '유령 부적, 피규어 부적, 12간지 부적을 카카오톡 공유용·포토카드용으로 저장하세요.';
  static const _path = '/ticketing-charm';

  final Map<String, GlobalKey> _sectionKeys = {
    for (final s in charmSeriesList) s.id: GlobalKey(),
  };

  void _scrollToSection(String id) {
    final ctx = _sectionKeys[id]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

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
      description: _description,
      path: _path,
      ogTitle: _title,
      jsonLd: [
        SeoService.webPageSchema(
          name: '티켓팅 부적 무료 다운로드',
          description: _description,
          path: _path,
        ),
        SeoService.breadcrumbSchema([
          ('홈', '/'),
          ('티켓팅 부적', null),
        ]),
      ],
    );

    return Title(
      title: _title,
      color: Theme.of(context).colorScheme.primary,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth > 800 ? 48.0 : 20.0;
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(child: SiteHeader()),
                const SliverToBoxAdapter(
                  child: Breadcrumb(items: [
                    BreadcrumbItem('홈', '/'),
                    BreadcrumbItem('티켓팅 부적'),
                  ]),
                ),
                SliverToBoxAdapter(
                  child: _buildHero(screenWidth, horizontalPadding),
                ),
                SliverToBoxAdapter(
                  child: _buildCategoryNav(horizontalPadding),
                ),
                for (int i = 0; i < charmSeriesList.length; i++) ...[
                  SliverToBoxAdapter(
                    child: _buildSectionHeader(
                      charmSeriesList[i],
                      horizontalPadding,
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: _buildCharmGrid(
                      context,
                      charmSeriesList[i],
                      screenWidth,
                      horizontalPadding,
                    ),
                  ),
                  if (i < charmSeriesList.length - 1)
                    SliverToBoxAdapter(
                      child: _buildSectionDivider(horizontalPadding),
                    )
                  else
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
                SliverToBoxAdapter(
                  child: _buildPracticeLinks(
                    context,
                    screenWidth,
                    horizontalPadding,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: 20,
                    ),
                    child: const AdSlot(slotId: 'charm-bottom'),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _buildSeoText(screenWidth, horizontalPadding),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                const SliverToBoxAdapter(child: SeoFooter()),
              ],
            );
          },
        ),
      ),
    );
  }

  // ── Hero ──────────────────────────────────────────────────

  Widget _buildHero(double screenWidth, double horizontalPadding) {
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
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Semantics(
          header: true,
          child: Text(
            '티켓팅 부적 무료 다운로드',
            textAlign: isWide ? TextAlign.start : TextAlign.center,
            style: TextStyle(
              fontSize: isWide ? 26 : 22,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A1A1A),
              height: 1.3,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '티켓팅 성공을 기원하는 행운 부적을 골라 저장해보세요.\n'
          '유령, 피규어, 12간지 등 다양한 부적을 무료로 이용할 수 있습니다.',
          textAlign: isWide ? TextAlign.start : TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
      ],
    );

    final imageCollage = _buildHeroImages(isWide);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFAF8FF), Colors.white],
        ),
      ),
      padding: EdgeInsets.only(
        top: isWide ? 32 : 20,
        bottom: isWide ? 32 : 16,
        left: horizontalPadding,
        right: horizontalPadding,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 3, child: textColumn),
                    const SizedBox(width: 40),
                    Expanded(flex: 2, child: Center(child: imageCollage)),
                  ],
                )
              : Column(
                  children: [
                    textColumn,
                    const SizedBox(height: 16),
                    imageCollage,
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildHeroImages(bool isWide) {
    final cardW = isWide ? 96.0 : 60.0;
    final cardH = cardW * 1.2;
    final gap = cardW * 0.72;
    final totalW = gap * 2 + cardW;
    final totalH = cardH + 16;

    return SizedBox(
      width: totalW,
      height: totalH,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 10,
            child: Transform.rotate(
              angle: -0.08,
              child: _heroCard(
                'assets/charms/ghost/01_ticketing_success_kakao.png',
                cardW,
                cardH,
              ),
            ),
          ),
          Positioned(
            left: gap * 2,
            top: 12,
            child: Transform.rotate(
              angle: 0.1,
              child: _heroCard(
                'assets/charms/zodiac/kakao/05_dragon_kakao.png',
                cardW,
                cardH,
              ),
            ),
          ),
          Positioned(
            left: gap,
            top: 0,
            child: _heroCard(
              'assets/charms/figure/01_ticketing_success_vivid.png',
              cardW,
              cardH,
            ),
          ),
        ],
      ),
    );
  }

  Widget _heroCard(String asset, double w, double h) {
    return Material(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        width: w,
        height: h,
        child: Image.asset(
          asset,
          fit: BoxFit.cover,
          cacheWidth: 300,
          errorBuilder: (_, _, _) => Container(
            color: const Color(0xFFF8F8FA),
            child: const Center(
              child: Icon(Icons.auto_awesome, color: Color(0xFFB39DDB)),
            ),
          ),
        ),
      ),
    );
  }

  // ── Category Nav ──────────────────────────────────────────

  Widget _buildCategoryNav(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 4,
        bottom: 12,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (int i = 0; i < charmSeriesList.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  ActionChip(
                    label: Text(charmSeriesList[i].title),
                    labelStyle: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.primary
                          .withValues(alpha: 0.15),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.primary.withValues(alpha: 0.04),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    onPressed: () =>
                        _scrollToSection(charmSeriesList[i].id),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Sections ──────────────────────────────────────────────

  Widget _buildSectionHeader(
    CharmSeries series,
    double horizontalPadding,
  ) {
    return Padding(
      key: _sectionKeys[series.id],
      padding: EdgeInsets.only(
        left: horizontalPadding,
        right: horizontalPadding,
        top: 24,
        bottom: 16,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                series.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                series.subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharmGrid(
    BuildContext context,
    CharmSeries series,
    double screenWidth,
    double horizontalPadding,
  ) {
    int crossAxisCount;
    if (screenWidth > 900) {
      crossAxisCount = 6;
    } else if (screenWidth > 600) {
      crossAxisCount = 3;
    } else if (screenWidth > 380) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    final effectiveWidth =
        (screenWidth - horizontalPadding * 2).clamp(0.0, 1100.0);
    final gapTotal = 16.0 * (crossAxisCount - 1);
    final columnWidth = (effectiveWidth - gapTotal) / crossAxisCount;
    final imageHeight = columnWidth / series.imageAspectRatio;
    const labelHeight = 44.0;
    final cardAspectRatio =
        (columnWidth / (imageHeight + labelHeight)).clamp(0.45, 0.95);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: cardAspectRatio,
            ),
            itemCount: series.items.length,
            itemBuilder: (context, index) {
              return _CharmCard(
                item: series.items[index],
                seriesTitle: series.title,
                isSquare: series.imageAspectRatio >= 0.9,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider(double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 20,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Divider(height: 1, color: Colors.grey[200]),
        ),
      ),
    );
  }

  // ── Bottom Sections ───────────────────────────────────────

  Widget _buildPracticeLinks(
    BuildContext context,
    double screenWidth,
    double horizontalPadding,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 24,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '마음에 드는 부적을 골라 티켓팅 전 행운을 챙겨가세요.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '부적도 받았으니, 연습도 해볼까요?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _practiceLink(
                    icon: Icons.play_circle_filled,
                    label: '실전 티켓팅 연습하기',
                    onPressed: () => _startFullPractice(context),
                    color: const Color(0xFF5C2D91),
                  ),
                  _practiceLink(
                    icon: Icons.grid_view_rounded,
                    label: '좌석 집중 연습하기',
                    onPressed: () => _startSeatPractice(context),
                    color: const Color(0xFF1565C0),
                  ),
                  _practiceLink(
                    icon: Icons.circle,
                    label: '포도알 연습하기',
                    onPressed: () => _startGrapePractice(context),
                    color: const Color(0xFF00897B),
                  ),
                  _practiceLink(
                    icon: Icons.stadium,
                    label: '공연장별 연습 보러가기',
                    onPressed: () => Navigator.of(context).pushNamed('/'),
                    color: const Color(0xFF37474F),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _practiceLink({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      labelStyle: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: color,
      ),
      side: BorderSide(color: color.withValues(alpha: 0.2)),
      backgroundColor: color.withValues(alpha: 0.04),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildSeoText(double screenWidth, double horizontalPadding) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: 32,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 960),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '티켓팅 부적이란?',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '티켓팅 부적은 콘서트 티켓팅 성공을 기원하며 만든 디지털 부적입니다. '
                '유령 부적, 피규어 부적, 12간지 부적 세 가지 시리즈로 구성되어 있으며, '
                '티켓팅 성공, 포도알 발견, 앞자리 당첨, 이선좌 방지, 취켓팅 성공, '
                '최애 포카 뽑기 등 다양한 소원에 맞는 부적을 고를 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '카카오톡 프로필이나 오픈채팅에 공유할 수 있는 정방형 이미지와 '
                '포토카드로 인쇄할 수 있는 세로형 이미지를 함께 제공합니다. '
                '12간지 부적은 자신의 띠에 맞는 동물 캐릭터를 선택할 수 있습니다.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.7,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '※ 재미로 즐겨주세요.',
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
}

// ── Charm Card ────────────────────────────────────────────

class _CharmCard extends StatefulWidget {
  final CharmItem item;
  final String seriesTitle;
  final bool isSquare;

  const _CharmCard({
    required this.item,
    required this.seriesTitle,
    required this.isSquare,
  });

  @override
  State<_CharmCard> createState() => _CharmCardState();
}

class _CharmCardState extends State<_CharmCard> {
  bool _hovered = false;

  String get _displayName {
    final name = widget.item.name;
    for (final word in widget.seriesTitle.split(' ')) {
      if (word.length > 1 && name.startsWith('$word ')) {
        return name.substring(word.length + 1);
      }
    }
    return name;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _hovered
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : const Color(0xFFEEEEEE),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _showDetail(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Semantics(
                  label: widget.item.altText,
                  child: Image.asset(
                    widget.item.thumbnailAsset,
                    fit: widget.isSquare ? BoxFit.cover : BoxFit.contain,
                    cacheWidth: 400,
                    errorBuilder: (_, _, _) => Container(
                      color: const Color(0xFFF8F8FA),
                      child: const Center(
                        child: Icon(Icons.auto_awesome,
                            color: Color(0xFFB39DDB)),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Text(
                  _displayName,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A1A),
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => _CharmDetailDialog(
        item: widget.item,
        seriesTitle: widget.seriesTitle,
      ),
    );
  }
}

// ── Detail Dialog ─────────────────────────────────────────

class _CharmDetailDialog extends StatelessWidget {
  final CharmItem item;
  final String seriesTitle;

  const _CharmDetailDialog({
    required this.item,
    required this.seriesTitle,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 600;
    final dialogWidth = isWide ? 400.0 : screenWidth * 0.92;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)),
      insetPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 4),
              child: Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                  color: Colors.grey[500],
                ),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 280),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          item.thumbnailAsset,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary
                            .withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        seriesTitle,
                        style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.primary
                              .withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (item.hasVariants) ...[
                      _downloadButton(
                        context: context,
                        label: '카톡 공유용 저장',
                        icon: Icons.chat_bubble_outline,
                        assetPath: item.kakaoAsset!,
                        fileName: '${item.name}_카톡공유용.png',
                      ),
                      const SizedBox(height: 10),
                      _downloadButton(
                        context: context,
                        label: '포카용 저장',
                        icon: Icons.photo_outlined,
                        assetPath: item.photocardAsset!,
                        fileName: '${item.name}_포카용.png',
                      ),
                    ] else
                      _downloadButton(
                        context: context,
                        label: '이미지 저장',
                        icon: Icons.download,
                        assetPath: item.thumbnailAsset,
                        fileName: '${item.name}.png',
                      ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _downloadButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required String assetPath,
    required String fileName,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => _downloadImage(assetPath, fileName),
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Color(0xFFE0E0E0)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Future<void> _downloadImage(String assetPath, String fileName) async {
    try {
      final data = await rootBundle.load(assetPath);
      final bytes = data.buffer.asUint8List();
      final blob = html.Blob([bytes], 'image/png');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (_) {
      // asset load failure — no-op
    }
  }
}
