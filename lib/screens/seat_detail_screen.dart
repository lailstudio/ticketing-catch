import 'dart:math';

import 'package:flutter/material.dart';

import '../models/practice_config.dart';
import '../models/practice_seat.dart';
import '../models/seat_status.dart';
import '../models/venue.dart';
import '../services/booking_simulator.dart';
import '../services/seat_map_generator.dart';
import '../services/time_tracker.dart';
import '../widgets/practice_back_button.dart';
import 'result_screen.dart';

class SeatDetailScreen extends StatefulWidget {
  final TimeTracker timeTracker;
  final PracticeConfig config;
  final VenueData venue;
  final String sectionId;
  final String? venueId;

  const SeatDetailScreen({
    super.key,
    required this.timeTracker,
    required this.config,
    required this.venue,
    required this.sectionId,
    this.venueId,
  });

  @override
  State<SeatDetailScreen> createState() => _SeatDetailScreenState();
}

class _SeatDetailScreenState extends State<SeatDetailScreen> {
  late final VenueSection _section;
  late final SeatMapGenerator _seatMapGenerator;
  late final BookingSimulator _bookingSimulator;
  late List<PracticeSeat> _seats;
  PracticeSeat? _selectedSeat;
  bool _guaranteedNextSuccess = false;
  bool _processing = false;

  @override
  void initState() {
    super.initState();
    _section = widget.venue.sections.firstWhere(
      (s) => s.id == widget.sectionId,
    );
    _seatMapGenerator = SeatMapGenerator();
    _bookingSimulator = BookingSimulator();
    _seats = _seatMapGenerator.generate(
      section: _section.id,
      rows: _section.rows,
      availableCount: widget.config.availableSeatCount,
    );
  }

  Map<int, List<PracticeSeat>> get _seatsByRow {
    final map = <int, List<PracticeSeat>>{};
    for (final seat in _seats) {
      map.putIfAbsent(seat.row, () => []).add(seat);
    }
    return map;
  }

  int get _availableCount =>
      _seats.where((s) => s.status == SeatStatus.available).length;

  void _onSeatTap(PracticeSeat seat) {
    if (_processing) return;
    if (seat.status != SeatStatus.available) return;

    widget.timeTracker.markFirstSeatClicked();

    setState(() {
      if (_selectedSeat != null && _selectedSeat != seat) {
        _selectedSeat!.status = SeatStatus.available;
      }
      seat.status = SeatStatus.selected;
      _selectedSeat = seat;
    });
  }

  void _onConfirmSelection() {
    final seat = _selectedSeat;
    if (seat == null || _processing) return;

    _processing = true;

    final BookingResult result;
    if (_guaranteedNextSuccess) {
      result = BookingResult.success;
      _guaranteedNextSuccess = false;
    } else {
      final elapsed =
          DateTime.now().difference(widget.timeTracker.seatEnteredAt!);
      result = _bookingSimulator.attempt(elapsed);
    }

    if (result == BookingResult.seatTaken) {
      widget.timeTracker.recordSeatTaken();
      setState(() {
        seat.status = SeatStatus.occupied;
        _selectedSeat = null;
      });
      _showSeatTakenDialog().then((_) {
        _processing = false;
        if (_availableCount == 0) {
          _spawnSafetyNetSeat();
        }
      });
    } else {
      widget.timeTracker.recordBookingSuccess();
      widget.timeTracker.markBookingCompleted();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ResultScreen(
            timeTracker: widget.timeTracker,
            section: seat.section,
            row: seat.row,
            seatNumber: seat.number,
            mode: widget.config.mode,
            venueId: widget.venueId,
          ),
        ),
      );
    }
  }

  Future<void> _showSeatTakenDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('이선좌'),
        content: const Text('다른 사용자가 먼저 선택한 좌석입니다.\n다른 좌석을 선택해주세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _spawnSafetyNetSeat() {
    final occupied =
        _seats.where((s) => s.status == SeatStatus.occupied).toList();
    if (occupied.isEmpty) return;
    final target = occupied[Random().nextInt(occupied.length)];
    setState(() {
      target.status = SeatStatus.available;
      _guaranteedNextSuccess = true;
    });
  }

  void _onRefresh() {
    setState(() {
      _selectedSeat = null;
      _seatMapGenerator.refreshSeats(_seats);
    });
  }

  @override
  Widget build(BuildContext context) {
    final grade = widget.venue.gradeById(_section.gradeId);
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          _buildHeader(context),
          _buildSectionInfo(grade),
          Expanded(
            child: InteractiveViewer(
              constrained: false,
              minScale: 0.5,
              maxScale: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _buildSeatGrid(),
              ),
            ),
          ),
          _buildConfirmButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 4,
        bottom: 8,
        left: 8,
        right: 8,
      ),
      child: Row(
        children: [
          const PracticeBackButton(),
          const SizedBox(width: 8),
          _darkPillButton('잔여좌석보기'),
          const SizedBox(width: 6),
          _darkPillButton('좌석가격보기'),
          const Spacer(),
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
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Color(0xFF333333),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  Widget _darkPillButton(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _buildSectionInfo(GradeInfo grade) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: const Color(0xFFFAFAFA),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.venue.name} · ${_section.number}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '* ${_section.number} 구역 좌석배치도',
            style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    final enabled = _selectedSeat != null;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, 8, 16, max(16.0, bottomPadding + 8)),
      color: const Color(0xFFFAFAFA),
      child: GestureDetector(
        onTap: enabled ? _onConfirmSelection : null,
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: enabled
                ? Theme.of(context).colorScheme.primary
                : const Color(0xFFCCCCCC),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            '좌석선택완료',
            style: TextStyle(
              color: enabled ? Colors.white : const Color(0xFF999999),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSeatGrid() {
    final sortedRows = _seatsByRow.keys.toList()..sort();
    final maxSeats =
        sortedRows.map((r) => _seatsByRow[r]!.length).reduce(max);
    const seatSize = 11.0;
    const seatGap = 2.0;
    const rowGap = 5.0;
    const seatStep = seatSize + seatGap;
    const labelWidth = 80.0;
    const labelSeatGap = 6.0;

    final rowOffsets = <int, int>{};
    for (final rowDef in _section.rows) {
      rowOffsets[rowDef.rowNumber] = rowDef.startOffset;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final rowNum in sortedRows)
          Padding(
            padding: const EdgeInsets.only(bottom: rowGap),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: labelWidth,
                  height: seatSize,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${_section.id}구역 $rowNum열',
                      style: const TextStyle(
                        fontSize: 7,
                        color: Color(0xFF1A1A1A),
                        height: 1.0,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                const SizedBox(width: labelSeatGap),
                SizedBox(width: (rowOffsets[rowNum] ?? 0) * seatStep),
                ..._buildRowSeats(
                  _seatsByRow[rowNum]!,
                  maxSeats,
                  seatSize,
                  seatGap,
                ),
              ],
            ),
          ),
      ],
    );
  }

  List<Widget> _buildRowSeats(
    List<PracticeSeat> rowSeats,
    int maxSeats,
    double seatSize,
    double gap,
  ) {
    rowSeats.sort((a, b) => a.number.compareTo(b.number));
    return [
      for (final seat in rowSeats)
        Padding(
          padding: EdgeInsets.only(right: gap),
          child: GestureDetector(
            onTap: () => _onSeatTap(seat),
            child: _buildSeatBox(seat.status, seatSize),
          ),
        ),
    ];
  }

  Widget _buildSeatBox(SeatStatus status, double size) {
    if (status == SeatStatus.selected) {
      return Container(
        width: size,
        height: size,
        color: const Color(0xFF1A1A1A),
        alignment: Alignment.center,
        child: Container(
          width: size * 0.4,
          height: size * 0.4,
          color: Colors.white,
        ),
      );
    }
    return Container(
      width: size,
      height: size,
      color: _seatColor(status),
    );
  }

  Color _seatColor(SeatStatus status) {
    switch (status) {
      case SeatStatus.available:
        return const Color(0xFF7B68AE);
      case SeatStatus.selected:
        return const Color(0xFF1A1A1A);
      case SeatStatus.occupied:
        return const Color(0xFFDCDCDC);
      case SeatStatus.unavailable:
        return const Color(0xFF989898);
    }
  }
}
