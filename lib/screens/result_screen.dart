import 'package:flutter/material.dart';

import '../data/venue_data_registry.dart';
import '../models/practice_config.dart';
import '../services/time_tracker.dart';
import '../widgets/practice_back_button.dart';
import 'queue_screen.dart';
import 'venue_map_screen.dart';
import 'seat_detail_screen.dart';

class ResultScreen extends StatelessWidget {
  final TimeTracker timeTracker;
  final String section;
  final int row;
  final int seatNumber;
  final PracticeMode mode;
  final String? venueId;

  const ResultScreen({
    super.key,
    required this.timeTracker,
    required this.section,
    required this.row,
    required this.seatNumber,
    this.mode = PracticeMode.full,
    this.venueId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              children: [
                Icon(Icons.check_circle, size: 64, color: Colors.green[400]),
                const SizedBox(height: 16),
                Text(
                  '예매 성공',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  '$section구역 $row열 $seatNumber번',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _modeLabel,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(height: 32),
                _buildRecordCard(context),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: () => _restartSameMode(context),
                    child: Text(
                      _restartLabel,
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context)
                          .popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      '홈으로',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
            ),
            const Positioned(
              left: 12,
              top: 12,
              child: PracticeBackButton(),
            ),
          ],
        ),
      ),
    );
  }

  String get _modeLabel {
    switch (mode) {
      case PracticeMode.full:
        return '실전 티켓팅 연습';
      case PracticeMode.focused:
        return '좌석 집중 연습';
      case PracticeMode.quick:
        return '바로 포도알 연습';
    }
  }

  String get _restartLabel {
    switch (mode) {
      case PracticeMode.full:
        return '다시 실전 티켓팅 연습';
      case PracticeMode.focused:
        return '다시 집중 연습';
      case PracticeMode.quick:
        return '다시 포도알 연습';
    }
  }

  Widget _buildRecordCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '연습 기록',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (mode == PracticeMode.full) ...[
            _recordRow('전체 소요시간', _formatDuration(timeTracker.totalDuration)),
            _recordRow('대기열', _formatDuration(timeTracker.queueDuration)),
            _recordRow('CAPTCHA', _formatDuration(timeTracker.captchaDuration)),
          ],
          if (mode != PracticeMode.quick)
            _recordRow(
                '구역→좌석 진입',
                _formatDuration(timeTracker.seatSelectionDuration)),
          _recordRow(
              '첫 좌석 클릭',
              _formatDuration(timeTracker.firstClickDuration)),
          _recordRow(
              '좌석 확보',
              _formatDuration(timeTracker.seatAcquisitionDuration)),
          const Divider(height: 24),
          _recordRow('이선좌 횟수', '${timeTracker.seatTakenCount}회'),
          _recordRow('총 시도', '${timeTracker.bookingAttempts}회'),
        ],
      ),
    );
  }

  Widget _recordRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  String _formatDuration(Duration? d) {
    if (d == null) return '-';
    if (d.inMinutes > 0) {
      final secs = d.inSeconds % 60;
      return '${d.inMinutes}분 $secs초';
    }
    final ms = d.inMilliseconds;
    return '${(ms / 1000).toStringAsFixed(1)}초';
  }

  void _restartSameMode(BuildContext context) {
    final newTracker = TimeTracker();
    newTracker.markPracticeStarted();
    final venue = venueDataFor(venueId);

    switch (mode) {
      case PracticeMode.full:
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => QueueScreen(
              timeTracker: newTracker,
              venueId: venueId,
            ),
          ),
          (route) => route.isFirst,
        );
      case PracticeMode.focused:
        newTracker.markSectionEntered();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => VenueMapScreen(
              timeTracker: newTracker,
              config: const PracticeConfig(mode: PracticeMode.focused),
              venue: venue,
              venueId: venueId,
            ),
          ),
          (route) => route.isFirst,
        );
      case PracticeMode.quick:
        newTracker.markSectionEntered();
        newTracker.markSeatEntered();
        final randomSection = venue
            .sections[DateTime.now().millisecondsSinceEpoch % venue.sections.length];
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => SeatDetailScreen(
              timeTracker: newTracker,
              config: const PracticeConfig(mode: PracticeMode.quick),
              venue: venue,
              sectionId: randomSection.id,
            ),
          ),
          (route) => route.isFirst,
        );
    }
  }
}
