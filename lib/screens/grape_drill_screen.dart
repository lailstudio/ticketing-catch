import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../widgets/practice_back_button.dart';

class GrapeDrillScreen extends StatefulWidget {
  const GrapeDrillScreen({super.key});

  @override
  State<GrapeDrillScreen> createState() => _GrapeDrillScreenState();
}

class _GrapeDrillScreenState extends State<GrapeDrillScreen> {
  final _random = Random();

  static const _successTarget = 10;
  static const _roundTimeoutMs = 2000;

  int _seatCount = 0;
  int _activeIndex = -1;
  bool _roundActive = false;
  bool _started = false;
  DateTime? _roundStartedAt;
  Timer? _nextTimer;
  Timer? _timeoutTimer;

  int _correctClicks = 0;
  int _failures = 0;
  int _misclicks = 0;
  final List<int> _reactionTimesMs = [];

  DateTime? _sessionStartedAt;
  Duration? _sessionDuration;
  bool _sessionComplete = false;

  String? _lastFeedback;
  Color _feedbackColor = const Color(0xFF4CAF50);

  @override
  void dispose() {
    _nextTimer?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  void _scheduleNext() {
    _nextTimer?.cancel();
    _timeoutTimer?.cancel();
    setState(() {
      _activeIndex = -1;
      _roundActive = false;
    });

    final baseDelay = max(140, 450 - _correctClicks * 22);
    final delayMs = baseDelay + _random.nextInt(max(80, 200 - _correctClicks * 9));
    _nextTimer = Timer(Duration(milliseconds: delayMs), () {
      if (!mounted) return;
      _showActive();
    });
  }

  void _showActive() {
    if (_seatCount <= 0) return;
    _timeoutTimer?.cancel();
    setState(() {
      _activeIndex = _random.nextInt(_seatCount);
      _roundActive = true;
      _started = true;
      _roundStartedAt = DateTime.now();
      _lastFeedback = null;
      _sessionStartedAt ??= DateTime.now();
    });
    _timeoutTimer = Timer(const Duration(milliseconds: _roundTimeoutMs), () {
      if (!mounted || !_roundActive) return;
      _onTimeout();
    });
  }

  void _onTimeout() {
    setState(() {
      _failures++;
      _lastFeedback = '시간 초과';
      _feedbackColor = const Color(0xFFFF9800);
      _roundActive = false;
      _activeIndex = -1;
    });
    _nextTimer = Timer(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      _scheduleNext();
    });
  }

  void _onSeatTap(int index) {
    if (!_roundActive || _activeIndex < 0) return;

    if (index == _activeIndex) {
      _nextTimer?.cancel();
      _timeoutTimer?.cancel();
      final ms = DateTime.now().difference(_roundStartedAt!).inMilliseconds;
      setState(() {
        _correctClicks++;
        _reactionTimesMs.add(ms);
        _lastFeedback = '${(ms / 1000).toStringAsFixed(3)}초';
        _feedbackColor = const Color(0xFF4CAF50);
        _roundActive = false;
      });

      if (_correctClicks >= _successTarget) {
        _sessionDuration = DateTime.now().difference(_sessionStartedAt!);
        setState(() {
          _sessionComplete = true;
          _lastFeedback = null;
        });
        return;
      }

      _nextTimer = Timer(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        _scheduleNext();
      });
    } else {
      setState(() {
        _misclicks++;
        _lastFeedback = '오클릭';
        _feedbackColor = const Color(0xFFE57373);
      });
    }
  }

  int get _avgMs {
    if (_reactionTimesMs.isEmpty) return 0;
    return _reactionTimesMs.reduce((a, b) => a + b) ~/ _reactionTimesMs.length;
  }

  int get _bestMs {
    if (_reactionTimesMs.isEmpty) return 0;
    return _reactionTimesMs.reduce(min);
  }

  String _fmtMs(int ms) {
    if (ms == 0) return '-';
    return '${(ms / 1000).toStringAsFixed(3)}초';
  }

  String _fmtDuration(Duration? d) {
    if (d == null) return '-';
    final s = d.inMilliseconds / 1000;
    return '${s.toStringAsFixed(3)}초';
  }

  void _resetStats() {
    _nextTimer?.cancel();
    _timeoutTimer?.cancel();
    setState(() {
      _correctClicks = 0;
      _failures = 0;
      _misclicks = 0;
      _reactionTimesMs.clear();
      _lastFeedback = null;
      _activeIndex = -1;
      _roundActive = false;
      _started = false;
      _sessionComplete = false;
      _sessionStartedAt = null;
      _sessionDuration = null;
    });
    _scheduleNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            if (_sessionComplete)
              Expanded(child: _buildResultView())
            else ...[
              _buildStatsBar(),
              Expanded(child: _buildSeatGrid()),
              _buildFeedbackBar(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          const PracticeBackButton(),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              '포도알 연습',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
          if (!_sessionComplete && _started)
            GestureDetector(
              onTap: _resetStats,
              child: Text(
                '초기화',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 480;

          if (isWide) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _statItem('진행', '$_correctClicks / $_successTarget'),
                _statItem('실패', '$_failures'),
                _statItem('오클릭', '$_misclicks'),
                _statItem('평균', _fmtMs(_avgMs)),
              ],
            );
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(child: _statItem('진행', '$_correctClicks / $_successTarget')),
                  Expanded(child: _statItem('실패', '$_failures')),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(child: _statItem('오클릭', '$_misclicks')),
                  Expanded(child: _statItem('평균', _fmtMs(_avgMs))),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _statItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSeatGrid() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availW = constraints.maxWidth;
          final availH = constraints.maxHeight;

          const seatSize = 12.0;
          const gap = 2.0;
          const rowGap = 4.0;
          const maxGridWidth = 520.0;
          const maxGridHeight = 640.0;

          final effectiveW = min(availW, maxGridWidth);
          final effectiveH = min(availH, maxGridHeight);
          const step = seatSize + gap;
          final cols = max(8, (effectiveW / step).floor());
          final rows = max(6, (effectiveH / (seatSize + rowGap)).floor());
          final total = cols * rows;

          if (_seatCount != total) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _seatCount = total;
              if (_activeIndex >= total || (!_roundActive && _activeIndex < 0)) {
                _scheduleNext();
              } else {
                setState(() {});
              }
            });
          }

          final gridW = cols * seatSize + (cols - 1) * gap;
          final gridH = rows * seatSize + (rows - 1) * rowGap;

          return Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: gridW,
              height: gridH,
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(rows, (r) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: r < rows - 1 ? rowGap : 0,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(cols, (c) {
                            final idx = r * cols + c;
                            final isActive = _roundActive &&
                                idx == _activeIndex &&
                                _activeIndex < total;
                            return Padding(
                              padding: EdgeInsets.only(
                                right: c < cols - 1 ? gap : 0,
                              ),
                              child: GestureDetector(
                                onTap: () => _onSeatTap(idx),
                                child: Container(
                                  width: seatSize,
                                  height: seatSize,
                                  decoration: BoxDecoration(
                                    color: isActive
                                        ? const Color(0xFF7E57C2)
                                        : const Color(0xFFD0D0D0),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      );
                    }),
                  ),
                  if (!_started)
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          '준비...',
                          style: TextStyle(
                            fontSize: 18,
                            color: Color(0xFFBBBBBB),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeedbackBar() {
    final visible = _lastFeedback != null;
    final isSuccess =
        visible && _lastFeedback != '오클릭' && _lastFeedback != '시간 초과';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: visible ? _feedbackColor : Colors.transparent,
      child: Text(
        visible ? (isSuccess ? '성공! $_lastFeedback' : _lastFeedback!) : '',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildResultView() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(24),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '연습 완료',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 24),
            _resultRow('성공', '$_successTarget'),
            _resultRow('실패', '$_failures'),
            _resultRow('오클릭', '$_misclicks'),
            _resultRow('평균 반응시간', _fmtMs(_avgMs)),
            _resultRow('최고 반응시간', _fmtMs(_bestMs)),
            _resultRow('총 소요시간', _fmtDuration(_sessionDuration)),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _resetStats,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7E57C2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  '다시 연습',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ],
      ),
    );
  }
}
