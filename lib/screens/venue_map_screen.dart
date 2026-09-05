import 'package:flutter/material.dart';

import '../data/venue_configs/venue_configs.dart';
import '../models/practice_config.dart';
import '../models/venue.dart';
import '../models/venue_map_config.dart';
import '../services/time_tracker.dart';
import '../widgets/practice_back_button.dart';
import '../widgets/venue_map_renderer.dart';
import 'seat_detail_screen.dart';

enum _OverlayMode { none, remaining, pricing }

class VenueMapScreen extends StatefulWidget {
  final TimeTracker timeTracker;
  final PracticeConfig config;
  final VenueData venue;
  final String? venueId;

  const VenueMapScreen({
    super.key,
    required this.timeTracker,
    required this.config,
    required this.venue,
    this.venueId,
  });

  @override
  State<VenueMapScreen> createState() => _VenueMapScreenState();
}

class _VenueMapScreenState extends State<VenueMapScreen> {
  _OverlayMode _overlayMode = _OverlayMode.none;
  final Set<String> _expandedGrades = {};

  static const _mapW = 800.0;
  static const _mapH = 950.0;

  bool get _hasOverlay => _overlayMode != _OverlayMode.none;

  void _setOverlayMode(_OverlayMode mode) {
    setState(() {
      if (_overlayMode != mode) {
        _expandedGrades.clear();
      }
      _overlayMode = mode;
    });
  }

  void _onSectionTap(VenueSection section) {
    widget.timeTracker.markSeatEntered();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => SeatDetailScreen(
          timeTracker: widget.timeTracker,
          config: widget.config,
          venue: widget.venue,
          sectionId: section.id,
          venueId: widget.venueId,
        ),
      ),
    );
  }

  void _onRefresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0E0E0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            if (_mapConfig != null) _buildVenueTitle(),
            Expanded(
              child: Stack(
                children: [
                  _buildMapArea(),
                  if (_hasOverlay) _buildOverlay(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          PracticeBackButton(
            onPressed: () {
              if (_hasOverlay) {
                _setOverlayMode(_OverlayMode.none);
              } else {
                Navigator.of(context).pop();
              }
            },
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _headerPill(
                  label: _overlayMode == _OverlayMode.remaining
                      ? '좌석닫기'
                      : '잔여좌석보기',
                  active: _overlayMode == _OverlayMode.remaining,
                  onTap: () {
                    if (_overlayMode == _OverlayMode.remaining) {
                      _setOverlayMode(_OverlayMode.none);
                    } else {
                      _setOverlayMode(_OverlayMode.remaining);
                    }
                  },
                ),
                const SizedBox(width: 6),
                _headerPill(
                  label: _overlayMode == _OverlayMode.pricing
                      ? '좌석닫기'
                      : '좌석가격보기',
                  active: _overlayMode == _OverlayMode.pricing,
                  onTap: () {
                    if (_overlayMode == _OverlayMode.pricing) {
                      _setOverlayMode(_OverlayMode.none);
                    } else {
                      _setOverlayMode(_OverlayMode.pricing);
                    }
                  },
                ),
              ],
            ),
          ),
          _circleButton(
            icon: Icons.refresh,
            onTap: _onRefresh,
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF303030),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _headerPill({
    required String label,
    required bool active,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: active ? Colors.grey[700] : const Color(0xFF303030),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
      ),
    );
  }

  Widget _buildVenueTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            widget.venue.name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '콘서트 좌석배치도',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Map area ───

  VenueMapConfig? get _mapConfig =>
      widget.venueId != null ? venueMapConfigFor(widget.venueId!) : null;

  Widget _buildMapArea() {
    final mapConfig = _mapConfig;
    if (mapConfig != null) {
      return _buildPolygonMapArea(mapConfig);
    }
    return _buildLegacyMapArea();
  }

  Widget _buildPolygonMapArea(VenueMapConfig config) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: InteractiveViewer(
                  minScale: 1.0,
                  maxScale: 4.0,
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: VenueMapRenderer(
                      config: config,
                      onSectionTap: (sectionId) {
                        final match = widget.venue.sections
                            .where((s) => s.id == sectionId);
                        if (match.isNotEmpty) {
                          _onSectionTap(match.first);
                        }
                      },
                    ),
                  ),
                ),
              ),
              if (config.legendEntries.isNotEmpty)
                _buildLegend(config),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegend(VenueMapConfig config) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 6,
        children: config.legendEntries.map((entry) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: Color(entry.colorValue),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 4),
              Text(
                entry.label,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLegacyMapArea() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.white,
          child: InteractiveViewer(
            constrained: false,
            minScale: 0.4,
            maxScale: 2.5,
            child: SizedBox(
              width: _mapW,
              height: _mapH,
              child: Stack(
                children: [
                  Positioned(
                    left: 150,
                    top: 10,
                    width: 500,
                    child: Column(
                      children: [
                        Text(
                          '구역 내 상단이 무대와 가까운 쪽입니다.',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                          ),
                          color: Colors.red[800],
                          child: const Text(
                            '※ 가로로 (한줄로 나란히) 예매해 주세요.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 220,
                    top: 50,
                    width: 360,
                    height: 35,
                    child: CustomPaint(
                      painter: _StagePainter(),
                      child: const Center(
                        child: Text(
                          'STAGE',
                          style: TextStyle(
                            color: Color(0xFF888888),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 145,
                    top: 100,
                    child: Text(
                      'FLOOR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 620,
                    top: 100,
                    child: Text(
                      'FLOOR',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 310,
                    top: 195,
                    width: 180,
                    height: 22,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(3),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        'CONSOLE',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    top: 235,
                    child: Text(
                      '2F',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 768,
                    top: 235,
                    child: Text(
                      '2F',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 18,
                    top: 600,
                    child: Text(
                      '4F',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 768,
                    top: 600,
                    child: Text(
                      '4F',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                  ...widget.venue.sections.map(_buildSection),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(VenueSection section) {
    final grade = widget.venue.gradeById(section.gradeId);
    final left = section.x * _mapW;
    final top = section.y * _mapH;
    final width = section.w * _mapW;
    final height = section.h * _mapH;

    Widget block = GestureDetector(
      onTap: () => _onSectionTap(section),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: grade.color,
          borderRadius: BorderRadius.circular(3),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              section.id,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
            Text(
              section.number,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 7,
                height: 1.1,
              ),
              overflow: TextOverflow.clip,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );

    if (section.rotation != 0) {
      block = Transform.rotate(angle: section.rotation, child: block);
    }

    return Positioned(left: left, top: top, child: block);
  }

  // ─── Full-screen overlay ───

  Widget _buildOverlay() {
    return Container(
      color: const Color(0xCC1A1A1A),
      child: Column(
        children: [
          _buildOverlayGuide(),
          Expanded(
            child: _overlayMode == _OverlayMode.remaining
                ? _buildRemainingContent()
                : _buildPricingContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlayGuide() {
    final text = _overlayMode == _OverlayMode.remaining
        ? '좌석명을 선택하시면 각 구역 별 잔여좌석을 확인할 수 있습니다.\n'
          '좌석이 선점되어 있는 경우, 표기 된 잔여좌석과 선택할 수 있는 잔여좌석이 다를 수 있습니다.'
        : '각 등급별 좌석 가격을 확인할 수 있습니다.';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 11,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ─── Remaining-seats content ───

  Widget _buildRemainingContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final grade in widget.venue.grades) ...[
          _buildGradeRow(grade),
          if (_expandedGrades.contains(grade.id)) _buildSectionList(grade),
          const Divider(color: Colors.white24, height: 1),
        ],
      ],
    );
  }

  Widget _buildGradeRow(GradeInfo grade) {
    final sections =
        widget.venue.sections.where((s) => s.gradeId == grade.id).toList();
    final expanded = _expandedGrades.contains(grade.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (expanded) {
            _expandedGrades.remove(grade.id);
          } else {
            _expandedGrades.add(grade.id);
          }
        });
      },
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: grade.color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                grade.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${sections.length}구역',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              expanded ? Icons.expand_less : Icons.expand_more,
              color: Colors.white.withValues(alpha: 0.5),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionList(GradeInfo grade) {
    final sections =
        widget.venue.sections.where((s) => s.gradeId == grade.id).toList();

    return Padding(
      padding: const EdgeInsets.only(left: 28, bottom: 12),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: sections.map((s) {
          return GestureDetector(
            onTap: () {
              _setOverlayMode(_OverlayMode.none);
              _onSectionTap(s);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Text(
                '${s.id} (${s.number})',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontSize: 12,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Pricing content ───

  Widget _buildPricingContent() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        for (final grade in widget.venue.grades) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: grade.color,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    grade.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  _formatPrice(grade.price),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
        ],
      ],
    );
  }

  String _formatPrice(int price) {
    final str = price.toString();
    final buf = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buf.write(',');
      buf.write(str[i]);
    }
    return '$buf원';
  }
}

class _StagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFD0D0D0);
    final path = Path()
      ..moveTo(size.width * 0.05, 0)
      ..lineTo(size.width * 0.95, 0)
      ..lineTo(size.width * 0.85, size.height)
      ..lineTo(size.width * 0.15, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
