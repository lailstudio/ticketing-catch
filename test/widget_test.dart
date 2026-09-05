import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ticketing/app.dart';
import 'package:ticketing/data/venue_layout.dart';
import 'package:ticketing/data/venue_presets.dart';
import 'package:ticketing/models/practice_config.dart';
import 'package:ticketing/models/seat_status.dart';
import 'package:ticketing/models/venue.dart';
import 'package:ticketing/screens/captcha_screen.dart';
import 'package:ticketing/screens/grape_drill_screen.dart';
import 'package:ticketing/screens/seat_detail_screen.dart';
import 'package:ticketing/screens/venue_detail_screen.dart';
import 'package:ticketing/screens/venue_map_screen.dart';
import 'package:ticketing/services/booking_simulator.dart';
import 'package:ticketing/services/captcha_generator.dart';
import 'package:ticketing/services/queue_simulator.dart';
import 'package:ticketing/services/seat_map_generator.dart';
import 'package:ticketing/services/time_tracker.dart';
import 'package:ticketing/widgets/practice_mode_section.dart';
import 'package:ticketing/widgets/venue_card.dart';
import 'package:ticketing/widgets/venue_image.dart';
import 'package:ticketing/widgets/venue_links_section.dart';
import 'package:ticketing/widgets/venue_map_renderer.dart';
import 'package:ticketing/widgets/venue_selector.dart';

class _FixedRandom implements Random {
  final double _value;
  _FixedRandom(this._value);

  @override
  double nextDouble() => _value;
  @override
  int nextInt(int max) => 0;
  @override
  bool nextBool() => false;
}

void main() {
  // ─── 홈 화면 ───
  group('홈 화면', () {
    testWidgets('히어로 문구가 표시된다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('티켓팅,\n연습이 실력입니다'), findsOneWidget);
    });

    testWidgets('연습 모드 카드가 표시된다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('연습 모드'), findsOneWidget);
      expect(find.text('실전 티켓팅 연습'), findsOneWidget);
      expect(find.text('좌석 집중 연습'), findsOneWidget);
      expect(find.text('포도알 연습'), findsOneWidget);
    });

    testWidgets('공연장별 연습 섹션이 표시된다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('공연장별 연습'), findsOneWidget);
    });

    testWidgets('공연장 카드가 5개 표시된다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.byType(VenueCard), findsNWidgets(5));
    });

    testWidgets('좌석 집중 연습 카드 탭 시 좌석도 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      await tester.ensureVisible(find.text('좌석 집중 연습'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('좌석 집중 연습'));
      await tester.pump();
      await tester.pump();
      final venueNames = venuePresets.map((p) => p.name).toSet();
      final found = venueNames.any((name) => find.text(name).evaluate().isNotEmpty);
      expect(found, isTrue);
    });

    testWidgets('포도알 연습 카드 탭 시 포도알 연습 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      await tester.ensureVisible(find.text('포도알 연습'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('포도알 연습'));
      await tester.pump();
      await tester.pump();
      expect(find.text('시도'), findsOneWidget);
      expect(find.text('성공'), findsOneWidget);
    });

    testWidgets('dropdown이 표시되지 않는다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('전체 공연장'), findsNothing);
      expect(find.byType(DropdownButton<String?>), findsNothing);
    });

    testWidgets('전체 티켓팅 시작 버튼 탭 시 대기열 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      await tester.ensureVisible(find.text('연습 시작하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('연습 시작하기'));
      await tester.pump();
      await tester.pump();
      expect(find.text('나의 대기순서'), findsOneWidget);
    });
  });

  // ─── 대기열 화면 ───
  group('대기열 화면', () {
    testWidgets('대기열 완료 후 보안문자 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      await tester.ensureVisible(find.text('연습 시작하기'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('연습 시작하기'));
      await tester.pump();
      await tester.pump(const Duration(seconds: 20));
      await tester.pumpAndSettle();
      expect(find.text('문자를 입력해주세요'), findsOneWidget);
    });
  });

  // ─── 보안문자 화면 ───
  group('보안문자 화면', () {
    testWidgets('보안문자 화면이 정상 표시된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CaptchaScreen(
            timeTracker: TimeTracker(),
            initialAnswer: 'TESTAB',
          ),
        ),
      );
      expect(find.text('문자를 입력해주세요'), findsOneWidget);
      expect(find.text('안심예매'), findsOneWidget);
      expect(find.text('입력완료'), findsOneWidget);
    });

    testWidgets('오답 입력 시 오류 메시지를 표시한다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CaptchaScreen(
            timeTracker: TimeTracker(),
            initialAnswer: 'TESTAB',
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'WRONG1');
      await tester.tap(find.text('입력완료'));
      await tester.pump();
      expect(
        find.text('문자가 일치하지 않습니다. 다시 입력해주세요.'),
        findsOneWidget,
      );
    });

    testWidgets('정답 입력 시 공연장 전체맵 화면으로 이동한다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CaptchaScreen(
            timeTracker: TimeTracker(),
            initialAnswer: 'TESTAB',
          ),
        ),
      );
      await tester.enterText(find.byType(TextField), 'testab');
      await tester.tap(find.text('입력완료'));
      await tester.pumpAndSettle();
      expect(find.text('STAGE'), findsOneWidget);
    });
  });

  // ─── QueueSimulator ───
  group('QueueSimulator', () {
    test('초기 상태가 올바르다', () {
      final sim = QueueSimulator(initialNumber: 100, totalWaiting: 200);
      expect(sim.currentNumber, 100);
      expect(sim.totalWaiting, 200);
      expect(sim.isComplete, false);
      expect(sim.progress, 0.0);
    });

    test('tick 호출 시 대기번호가 감소한다', () {
      final sim = QueueSimulator(initialNumber: 100, totalWaiting: 200);
      sim.tick();
      expect(sim.currentNumber, lessThan(100));
    });

    test('충분한 tick 후 완료된다', () {
      final sim = QueueSimulator(initialNumber: 100, totalWaiting: 200);
      for (int i = 0; i < 100; i++) {
        sim.tick();
      }
      expect(sim.isComplete, true);
      expect(sim.currentNumber, 0);
      expect(sim.progress, 1.0);
    });
  });

  // ─── CaptchaGenerator ───
  group('CaptchaGenerator', () {
    test('6자리 영문 대문자를 생성한다', () {
      final gen = CaptchaGenerator();
      final result = gen.generate();
      expect(result.length, 6);
      expect(result, matches(RegExp(r'^[A-Z]{6}$')));
    });

    test('대소문자 구분 없이 검증한다', () {
      final gen = CaptchaGenerator();
      expect(gen.validate('abcdef', 'ABCDEF'), true);
      expect(gen.validate('AbCdEf', 'ABCDEF'), true);
      expect(gen.validate('ABCDEF', 'ABCDEF'), true);
      expect(gen.validate('WRONG1', 'ABCDEF'), false);
    });
  });

  // ─── SeatMapGenerator ───
  group('SeatMapGenerator', () {
    final testRows = [
      const SectionRowDef(rowNumber: 1, seatCount: 10),
      const SectionRowDef(rowNumber: 2, seatCount: 12),
      const SectionRowDef(rowNumber: 3, seatCount: 10),
    ];

    test('SectionRowDef에 따라 좌석을 생성한다', () {
      final gen = SeatMapGenerator(random: Random(42));
      final seats = gen.generate(
        section: 'E1',
        rows: testRows,
        availableCount: 2,
      );
      expect(seats.length, 32);
    });

    test('행별 좌석 수가 SectionRowDef와 일치한다', () {
      final gen = SeatMapGenerator(random: Random(42));
      final seats = gen.generate(
        section: 'E1',
        rows: testRows,
        availableCount: 2,
      );
      expect(seats.where((s) => s.row == 1).length, 10);
      expect(seats.where((s) => s.row == 2).length, 12);
      expect(seats.where((s) => s.row == 3).length, 10);
    });

    test('지정한 수만큼 available 좌석이 생성된다', () {
      final gen = SeatMapGenerator(random: Random(42));
      final seats = gen.generate(
        section: 'E1',
        rows: testRows,
        availableCount: 2,
      );
      final available =
          seats.where((s) => s.status == SeatStatus.available).length;
      expect(available, 2);
    });

    test('나머지 좌석은 모두 occupied 상태다', () {
      final gen = SeatMapGenerator(random: Random(42));
      final seats = gen.generate(
        section: 'E1',
        rows: testRows,
        availableCount: 2,
      );
      final occupied =
          seats.where((s) => s.status == SeatStatus.occupied).length;
      expect(occupied, 30);
    });

    test('availableCount가 총 좌석 수를 초과하면 전체가 available이다', () {
      final gen = SeatMapGenerator(random: Random(42));
      final seats = gen.generate(
        section: 'E1',
        rows: testRows,
        availableCount: 100,
      );
      final available =
          seats.where((s) => s.status == SeatStatus.available).length;
      expect(available, 32);
    });

    test('refreshSeats가 selected 상태를 유지한다', () {
      final gen = SeatMapGenerator(random: Random(42));
      final seats = gen.generate(
        section: 'E1',
        rows: testRows,
        availableCount: 2,
      );
      final first =
          seats.firstWhere((s) => s.status == SeatStatus.available);
      first.status = SeatStatus.selected;
      gen.refreshSeats(seats);
      expect(first.status, SeatStatus.selected);
    });
  });

  // ─── BookingSimulator 시간 기반 이선좌 확률 ───
  group('BookingSimulator contestRateFor 경계값', () {
    test('0ms → 0%', () {
      expect(BookingSimulator.contestRateFor(Duration.zero), 0.0);
    });

    test('999ms → 0%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 999)),
        0.0,
      );
    });

    test('1000ms → 10%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 1000)),
        0.10,
      );
    });

    test('1999ms → 10%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 1999)),
        0.10,
      );
    });

    test('2000ms → 20%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 2000)),
        0.20,
      );
    });

    test('3999ms → 20%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 3999)),
        0.20,
      );
    });

    test('4000ms → 30%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 4000)),
        0.30,
      );
    });

    test('5999ms → 30%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 5999)),
        0.30,
      );
    });

    test('6000ms → 40%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 6000)),
        0.40,
      );
    });

    test('7999ms → 40%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 7999)),
        0.40,
      );
    });

    test('8000ms → 50%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 8000)),
        0.50,
      );
    });

    test('10000ms 이상 → 50%', () {
      expect(
        BookingSimulator.contestRateFor(const Duration(milliseconds: 10000)),
        0.50,
      );
      expect(
        BookingSimulator.contestRateFor(const Duration(seconds: 60)),
        0.50,
      );
    });
  });

  group('BookingSimulator attempt 동작', () {
    test('1초 미만이면 Random 값과 무관하게 반드시 성공한다', () {
      final sim = BookingSimulator(random: _FixedRandom(0.99));
      expect(
        sim.attempt(const Duration(milliseconds: 0)),
        BookingResult.success,
      );
      expect(
        sim.attempt(const Duration(milliseconds: 500)),
        BookingResult.success,
      );
      expect(
        sim.attempt(const Duration(milliseconds: 999)),
        BookingResult.success,
      );
    });

    test('1초 이상에서 random < contestRate이면 이선좌', () {
      final sim = BookingSimulator(random: _FixedRandom(0.05));
      expect(
        sim.attempt(const Duration(milliseconds: 1500)),
        BookingResult.seatTaken,
      );
    });

    test('1초 이상에서 random >= contestRate이면 성공', () {
      final sim = BookingSimulator(random: _FixedRandom(0.15));
      expect(
        sim.attempt(const Duration(milliseconds: 1500)),
        BookingResult.success,
      );
    });

    test('8초 이상에서 random < 0.50이면 이선좌', () {
      final sim = BookingSimulator(random: _FixedRandom(0.49));
      expect(
        sim.attempt(const Duration(seconds: 10)),
        BookingResult.seatTaken,
      );
    });

    test('8초 이상에서 random >= 0.50이면 성공', () {
      final sim = BookingSimulator(random: _FixedRandom(0.50));
      expect(
        sim.attempt(const Duration(seconds: 10)),
        BookingResult.success,
      );
    });

    test('999ms→1000ms 경계에서 판정이 달라진다', () {
      final sim = BookingSimulator(random: _FixedRandom(0.05));
      expect(
        sim.attempt(const Duration(milliseconds: 999)),
        BookingResult.success,
      );
      expect(
        sim.attempt(const Duration(milliseconds: 1000)),
        BookingResult.seatTaken,
      );
    });
  });

  // ─── TimeTracker ───
  group('TimeTracker', () {
    test('전체 소요시간을 계산한다', () {
      final t = TimeTracker();
      t.practiceStartedAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.bookingCompletedAt = DateTime(2024, 1, 1, 0, 1, 30);
      expect(t.totalDuration, const Duration(minutes: 1, seconds: 30));
    });

    test('대기열 소요시간을 계산한다', () {
      final t = TimeTracker();
      t.practiceStartedAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.queueCompletedAt = DateTime(2024, 1, 1, 0, 0, 6);
      expect(t.queueDuration, const Duration(seconds: 6));
    });

    test('구역→좌석 진입 시간을 계산한다', () {
      final t = TimeTracker();
      t.sectionEnteredAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.firstSeatEnteredAt = DateTime(2024, 1, 1, 0, 0, 5);
      expect(t.seatSelectionDuration, const Duration(seconds: 5));
    });

    test('첫 좌석 클릭 시간을 계산한다', () {
      final t = TimeTracker();
      t.firstSeatEnteredAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.firstSeatClickedAt = DateTime(2024, 1, 1, 0, 0, 3);
      expect(t.firstClickDuration, const Duration(seconds: 3));
    });

    test('좌석 확보(seatAcquisition) 시간을 계산한다', () {
      final t = TimeTracker();
      t.firstSeatClickedAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.bookingCompletedAt = DateTime(2024, 1, 1, 0, 0, 10);
      expect(t.seatAcquisitionDuration, const Duration(seconds: 10));
    });

    test('이선좌 횟수를 기록한다', () {
      final t = TimeTracker();
      t.recordSeatTaken();
      t.recordSeatTaken();
      t.recordBookingSuccess();
      expect(t.seatTakenCount, 2);
      expect(t.bookingAttempts, 3);
    });

    test('markFirstSeatClicked는 최초 1회만 기록한다', () {
      final t = TimeTracker();
      t.firstSeatEnteredAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.markFirstSeatClicked();
      final first = t.firstSeatClickedAt;
      t.markFirstSeatClicked();
      expect(t.firstSeatClickedAt, first);
    });

    test('markSeatEntered는 firstSeatEnteredAt을 최초 1회만 기록한다', () {
      final t = TimeTracker();
      t.markSeatEntered();
      final first = t.firstSeatEnteredAt;
      expect(first, isNotNull);
      t.markSeatEntered();
      expect(identical(t.firstSeatEnteredAt, first), isTrue);
    });

    test('타임스탬프 미설정 시 null을 반환한다', () {
      final t = TimeTracker();
      expect(t.totalDuration, isNull);
      expect(t.queueDuration, isNull);
      expect(t.captchaDuration, isNull);
      expect(t.seatSelectionDuration, isNull);
      expect(t.firstClickDuration, isNull);
      expect(t.seatAcquisitionDuration, isNull);
    });

    test('좌석 화면 진입 2초 후 첫 클릭 시 firstClickDuration이 약 2초다', () {
      final t = TimeTracker();
      final base = DateTime(2024, 1, 1, 0, 0, 0);
      t.firstSeatEnteredAt = base;
      t.firstSeatClickedAt = base.add(const Duration(seconds: 2));
      expect(t.firstClickDuration, const Duration(seconds: 2));
    });

    test('이선좌 발생 후 재클릭해도 첫 좌석 클릭 기록이 유지된다', () {
      final t = TimeTracker();
      final base = DateTime(2024, 1, 1, 0, 0, 0);
      t.firstSeatEnteredAt = base;
      t.firstSeatClickedAt = base.add(const Duration(seconds: 1));
      final firstClick = t.firstSeatClickedAt;
      t.recordSeatTaken();
      t.markFirstSeatClicked();
      expect(t.firstSeatClickedAt, firstClick);
      expect(t.firstClickDuration, const Duration(seconds: 1));
    });

    test('첫 클릭 즉시 성공 시 좌석 확보 시간이 0초 이상이다', () {
      final t = TimeTracker();
      final clickTime = DateTime(2024, 1, 1, 0, 0, 5);
      t.firstSeatClickedAt = clickTime;
      t.bookingCompletedAt = clickTime;
      expect(t.seatAcquisitionDuration!.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('구역 재진입해도 firstSeatEnteredAt이 유지되어 음수가 발생하지 않는다', () {
      final t = TimeTracker();
      final base = DateTime(2024, 1, 1, 0, 0, 0);

      t.sectionEnteredAt = base;
      t.firstSeatEnteredAt = base.add(const Duration(seconds: 3));
      t.seatEnteredAt = base.add(const Duration(seconds: 3));
      t.firstSeatClickedAt = base.add(const Duration(seconds: 5));

      t.seatEnteredAt = base.add(const Duration(seconds: 15));

      t.bookingCompletedAt = base.add(const Duration(seconds: 20));

      expect(t.firstSeatEnteredAt, base.add(const Duration(seconds: 3)));
      expect(t.firstSeatClickedAt, base.add(const Duration(seconds: 5)));
      expect(t.seatSelectionDuration!.inMilliseconds, greaterThanOrEqualTo(0));
      expect(t.firstClickDuration!.inMilliseconds, greaterThanOrEqualTo(0));
      expect(t.seatAcquisitionDuration!.inMilliseconds, greaterThanOrEqualTo(0));
    });

    test('전체 소요시간이 각 단계 시간의 합과 논리적으로 모순되지 않는다', () {
      final t = TimeTracker();
      t.practiceStartedAt = DateTime(2024, 1, 1, 0, 0, 0);
      t.queueCompletedAt = DateTime(2024, 1, 1, 0, 0, 6);
      t.captchaEnteredAt = DateTime(2024, 1, 1, 0, 0, 6);
      t.captchaCompletedAt = DateTime(2024, 1, 1, 0, 0, 10);
      t.sectionEnteredAt = DateTime(2024, 1, 1, 0, 0, 10);
      t.firstSeatEnteredAt = DateTime(2024, 1, 1, 0, 0, 13);
      t.firstSeatClickedAt = DateTime(2024, 1, 1, 0, 0, 15);
      t.bookingCompletedAt = DateTime(2024, 1, 1, 0, 0, 18);

      expect(t.totalDuration, const Duration(seconds: 18));
      expect(t.queueDuration, const Duration(seconds: 6));
      expect(t.captchaDuration, const Duration(seconds: 4));
      expect(t.seatSelectionDuration, const Duration(seconds: 3));
      expect(t.firstClickDuration, const Duration(seconds: 2));
      expect(t.seatAcquisitionDuration, const Duration(seconds: 3));

      final subTotal = t.queueDuration! +
          t.captchaDuration! +
          t.seatSelectionDuration! +
          t.firstClickDuration! +
          t.seatAcquisitionDuration!;
      expect(subTotal, equals(t.totalDuration));
    });
  });

  // ─── VenueData ───
  group('VenueData', () {
    test('sampleVenue가 80개 이상의 섹션을 포함한다', () {
      expect(sampleVenue.sections.length, greaterThanOrEqualTo(80));
    });

    test('모든 섹션이 유효한 gradeId를 가진다', () {
      final gradeIds = sampleVenue.grades.map((g) => g.id).toSet();
      for (final section in sampleVenue.sections) {
        expect(gradeIds.contains(section.gradeId), true,
            reason: '${section.id} has invalid gradeId: ${section.gradeId}');
      }
    });

    test('모든 섹션이 rows를 가진다', () {
      for (final section in sampleVenue.sections) {
        expect(section.rows, isNotEmpty,
            reason: '${section.id} has no rows');
      }
    });

    test('gradeById가 올바른 등급을 반환한다', () {
      final vip = sampleVenue.gradeById('VIP');
      expect(vip.label, contains('VIP'));
    });

    test('sectionsByFloor가 올바르게 필터링한다', () {
      final floor = sampleVenue.sectionsByFloor('FLOOR');
      expect(floor.length, 20);
      for (final s in floor) {
        expect(s.floor, 'FLOOR');
      }
    });
  });

  // ─── 공연장 전체맵 화면 ───
  group('공연장 전체맵 화면', () {
    Widget buildVenueMap() {
      return MaterialApp(
        home: VenueMapScreen(
          timeTracker: TimeTracker()..markSectionEntered(),
          config: const PracticeConfig(mode: PracticeMode.focused),
          venue: sampleVenue,
        ),
      );
    }

    testWidgets('STAGE와 섹션 블록이 표시된다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      expect(find.text('STAGE'), findsOneWidget);
      expect(find.text('F1'), findsOneWidget);
    });

    testWidgets('잔여좌석보기 클릭 시 전체 딤 오버레이가 표시된다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      expect(find.textContaining('좌석명을 선택하시면'), findsOneWidget);
    });

    testWidgets('오른쪽 사이드바(width 280)가 존재하지 않는다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      final sidebarFinder = find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.maxWidth == 280,
      );
      expect(sidebarFinder, findsNothing);
    });

    testWidgets('오버레이 최초 진입 시 모든 등급이 접힌 상태다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      expect(find.text('VIP석(들꽃석)'), findsOneWidget);
      expect(find.text('R석(무지개석)'), findsOneWidget);
      expect(find.text('S석(별빛석)'), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsNWidgets(3));
      expect(find.byIcon(Icons.expand_less), findsNothing);
    });

    testWidgets('VIP 클릭 시 VIP 구역만 펼쳐진다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      await tester.tap(find.text('VIP석(들꽃석)'));
      await tester.pump();
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
      expect(find.byIcon(Icons.expand_more), findsNWidgets(2));
      expect(find.text('S5 (203)'), findsOneWidget);
    });

    testWidgets('펼쳐진 등급을 다시 클릭하면 접힌다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      await tester.tap(find.text('VIP석(들꽃석)'));
      await tester.pump();
      expect(find.byIcon(Icons.expand_less), findsOneWidget);
      await tester.tap(find.text('VIP석(들꽃석)'));
      await tester.pump();
      expect(find.byIcon(Icons.expand_less), findsNothing);
      expect(find.byIcon(Icons.expand_more), findsNWidgets(3));
    });

    testWidgets('좌석닫기 클릭 시 오버레이가 닫힌다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      expect(find.text('좌석닫기'), findsOneWidget);
      await tester.tap(find.text('좌석닫기'));
      await tester.pump();
      expect(find.textContaining('좌석명을 선택하시면'), findsNothing);
      expect(find.text('잔여좌석보기'), findsOneWidget);
    });

    testWidgets('좌석가격보기로 정상 전환된다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      expect(find.textContaining('좌석명을 선택하시면'), findsOneWidget);
      await tester.tap(find.text('좌석가격보기'));
      await tester.pump();
      expect(find.textContaining('등급별 좌석 가격'), findsOneWidget);
      expect(find.textContaining('165,000원'), findsOneWidget);
    });

    testWidgets('구역 데이터는 venue sections에서 가져온다', (tester) async {
      await tester.pumpWidget(buildVenueMap());
      await tester.tap(find.text('잔여좌석보기'));
      await tester.pump();
      await tester.tap(find.text('R석(무지개석)'));
      await tester.pump();
      expect(find.textContaining('F1'), findsWidgets);
    });
  });

  // ─── 좌석 상세 화면 ───
  group('좌석 상세 화면', () {
    testWidgets('섹션 정보가 표시된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SeatDetailScreen(
            timeTracker: TimeTracker()..markSeatEntered(),
            config: const PracticeConfig(),
            venue: sampleVenue,
            sectionId: 'F1',
          ),
        ),
      );
      expect(find.textContaining('좌석배치도'), findsOneWidget);
    });

    testWidgets('좌석 블록들이 렌더링된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: SeatDetailScreen(
            timeTracker: TimeTracker()..markSeatEntered(),
            config: const PracticeConfig(availableSeatCount: 2),
            venue: sampleVenue,
            sectionId: 'F1',
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });

  // ─── PracticeConfig ───
  group('PracticeConfig', () {
    test('기본값이 올바르다', () {
      const config = PracticeConfig();
      expect(config.availableSeatCount, 2);
      expect(config.contestRate, 0.65);
      expect(config.mode, PracticeMode.full);
    });

    test('커스텀 값을 설정할 수 있다', () {
      const config = PracticeConfig(
        availableSeatCount: 5,
        contestRate: 0.8,
        mode: PracticeMode.quick,
      );
      expect(config.availableSeatCount, 5);
      expect(config.contestRate, 0.8);
      expect(config.mode, PracticeMode.quick);
    });
  });

  // ─── VenuePreset ───
  group('VenuePreset', () {
    test('Top 5 공연장이 정의되어 있다', () {
      expect(venuePresets.length, 5);
      final names = venuePresets.map((p) => p.name).toList();
      expect(names, contains('고척스카이돔'));
      expect(names, contains('KSPO DOME'));
      expect(names, contains('잠실실내체육관'));
      expect(names, contains('인스파이어 아레나'));
      expect(names, contains('올림픽홀'));
    });

    test('각 프리셋이 필수 필드를 가진다', () {
      for (final preset in venuePresets) {
        expect(preset.id, isNotEmpty);
        expect(preset.slug, isNotEmpty);
        expect(preset.name, isNotEmpty);
        expect(preset.shortName, isNotEmpty);
        expect(preset.description, isNotEmpty);
        expect(preset.tagline, isNotEmpty);
        expect(preset.enabled, isTrue);
        expect(preset.pageTitle, isNotEmpty);
        expect(preset.heading, isNotEmpty);
        expect(preset.shortDescription, isNotEmpty);
        expect(preset.representativeLayoutLabel, isNotEmpty);
        expect(preset.disclaimer, isNotEmpty);
      }
    });

    test('각 프리셋이 새 필드를 가진다', () {
      for (final preset in venuePresets) {
        expect(preset.imageAsset, isNotNull);
        expect(preset.capacity, isNotNull);
        expect(preset.difficulty, isNotNull);
        expect(preset.difficulty, greaterThanOrEqualTo(1));
        expect(preset.difficulty, lessThanOrEqualTo(5));
      }
    });

    test('slug로 프리셋을 찾을 수 있다', () {
      final found = findPresetBySlug('gocheok-skydome');
      expect(found, isNotNull);
      expect(found!.name, '고척스카이돔');
    });

    test('존재하지 않는 slug는 null을 반환한다', () {
      expect(findPresetBySlug('nonexistent'), isNull);
    });

    test('id로 프리셋을 찾을 수 있다', () {
      final found = findPresetById('kspo');
      expect(found, isNotNull);
      expect(found!.name, 'KSPO DOME');
    });

    test('모든 slug가 고유하다', () {
      final slugs = venuePresets.map((p) => p.slug).toSet();
      expect(slugs.length, venuePresets.length);
    });

    test('각 프리셋의 pageTitle에 Ticketing Practice가 포함된다', () {
      for (final preset in venuePresets) {
        expect(preset.pageTitle, contains('Ticketing Practice'));
        expect(preset.pageTitle, contains(preset.name));
      }
    });
  });

  // ─── VenueSelector ───
  group('VenueSelector', () {
    testWidgets('기본 상태에서 "전체 공연장"이 표시된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenueSelector(
              selected: null,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('전체 공연장'), findsOneWidget);
    });

    testWidgets('선택된 공연장 이름이 표시된다', (tester) async {
      final preset = findPresetBySlug('kspo-dome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenueSelector(
              selected: preset,
              onChanged: (_) {},
            ),
          ),
        ),
      );
      expect(find.text('KSPO DOME'), findsOneWidget);
    });
  });

  // ─── PracticeModeSection ───
  group('PracticeModeSection', () {
    testWidgets('포도알 연습이 콜백 제공 시 표시된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PracticeModeSection(
              onFullPractice: () {},
              onFocusedPractice: () {},
              onQuickPractice: () {},
            ),
          ),
        ),
      );
      expect(find.text('전체 티켓팅 연습'), findsOneWidget);
      expect(find.text('좌석 집중 연습'), findsOneWidget);
      expect(find.text('포도알 연습'), findsOneWidget);
    });

    testWidgets('포도알 연습이 콜백 미제공 시 숨겨진다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PracticeModeSection(
              onFullPractice: () {},
              onFocusedPractice: () {},
            ),
          ),
        ),
      );
      expect(find.text('전체 티켓팅 연습'), findsOneWidget);
      expect(find.text('좌석 집중 연습'), findsOneWidget);
      expect(find.text('포도알 연습'), findsNothing);
    });
  });

  // ─── VenueLinksSection ───
  group('VenueLinksSection', () {
    testWidgets('일반 홈에서 모든 공연장이 표시된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: VenueLinksSection(),
          ),
        ),
      );
      expect(find.text('공연장별 연습'), findsOneWidget);
      expect(find.text('고척스카이돔'), findsOneWidget);
      expect(find.text('KSPO DOME'), findsOneWidget);
      expect(find.text('잠실실내체육관'), findsOneWidget);
      expect(find.text('인스파이어 아레나'), findsOneWidget);
      expect(find.text('올림픽홀'), findsOneWidget);
    });

    testWidgets('공연장 페이지에서 현재 공연장이 제외되고 기본 티켓팅이 포함된다', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const Scaffold(
            body: VenueLinksSection(currentSlug: 'gocheok-skydome'),
          ),
        ),
      );
      expect(find.text('다른 연습'), findsOneWidget);
      expect(find.text('기본 티켓팅'), findsOneWidget);
      expect(find.text('고척스카이돔'), findsNothing);
      expect(find.text('KSPO DOME'), findsOneWidget);
    });
  });

  // ─── 공연장별 URL 라우팅 ───
  group('공연장별 URL 라우팅', () {
    testWidgets('/ 경로에서 홈 화면이 표시된다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('티켓팅,\n연습이 실력입니다'), findsOneWidget);
      expect(find.text('공연장별 연습'), findsOneWidget);
    });

    testWidgets('/ 경로에서 dropdown이 없다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('전체 공연장'), findsNothing);
    });

    testWidgets('/venue/{slug} 경로에서 VenueDetailScreen이 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.text(preset.heading), findsOneWidget);
      expect(find.text('공연장 연습'), findsOneWidget);
    });

    testWidgets('공연장 상세에 대표 배치 레이블이 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.text(preset.representativeLayoutLabel), findsWidgets);
    });

    testWidgets('공연장 상세에 안내 문구가 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.textContaining('실제 무대 및 좌석 배치는 달라질 수 있습니다'), findsOneWidget);
    });

    testWidgets('공연장 상세에 연습 모드 선택이 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.text('연습 모드 선택'), findsOneWidget);
      expect(find.text('전체 티켓팅 연습'), findsOneWidget);
      expect(find.text('좌석 집중 연습'), findsOneWidget);
    });

    testWidgets('공연장 상세에 연습 정보가 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.text('연습 정보'), findsOneWidget);
      expect(find.text(preset.name), findsWidgets);
      expect(find.text('연습 배치'), findsOneWidget);
      expect(find.text('대표 콘서트 배치 기반'), findsOneWidget);
      expect(find.text('공연장 규모'), findsOneWidget);
      expect(find.text(preset.capacity!), findsOneWidget);
      expect(
        find.text('실제 판매 좌석 수는 공연 및 무대 배치에 따라 달라질 수 있습니다.'),
        findsOneWidget,
      );
    });

    testWidgets('공연장 상세에 다른 연습 링크가 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.text('다른 연습'), findsOneWidget);
      expect(find.text('기본 티켓팅'), findsOneWidget);
      expect(find.text('KSPO DOME'), findsOneWidget);
    });

    testWidgets('공연장 상세에 TIP 섹션이 표시된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      expect(find.text('TIP'), findsOneWidget);
    });

    testWidgets('일반 홈에서는 공연장 헤딩이 표시되지 않는다', (tester) async {
      await tester.pumpWidget(const TicketingApp());
      expect(find.text('고척스카이돔 티켓팅 연습'), findsNothing);
      expect(find.text('다른 연습'), findsNothing);
      expect(find.text('기본 티켓팅'), findsNothing);
    });
  });

  // ─── 포도알 연습 화면 ───
  group('포도알 연습 화면', () {
    testWidgets('포도알 연습 화면이 정상 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: GrapeDrillScreen()),
      );
      expect(find.text('포도알 연습'), findsOneWidget);
      expect(find.text('시도'), findsOneWidget);
      expect(find.text('성공'), findsOneWidget);
      expect(find.text('오클릭'), findsOneWidget);
      expect(find.text('평균'), findsOneWidget);
      expect(find.text('최근'), findsOneWidget);
      expect(find.text('최고'), findsOneWidget);
      expect(find.text('성공률'), findsOneWidget);
    });

    testWidgets('초기 상태에서 준비 텍스트가 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: GrapeDrillScreen()),
      );
      expect(find.text('준비...'), findsOneWidget);
    });

    testWidgets('초기 통계가 0이다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: GrapeDrillScreen()),
      );
      expect(find.text('0'), findsNWidgets(3));
      expect(find.text('-'), findsNWidgets(4));
    });
  });

  // ─── VenueImage ───
  group('VenueImage', () {
    testWidgets('그라데이션 플레이스홀더가 렌더링된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VenueImage(venueId: 'gocheok', height: 200),
          ),
        ),
      );
      expect(find.byType(VenueImage), findsOneWidget);
    });

    testWidgets('알 수 없는 venueId에도 기본 그라데이션이 표시된다', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: VenueImage(venueId: 'unknown', height: 200),
          ),
        ),
      );
      expect(find.byType(VenueImage), findsOneWidget);
    });
  });

  // ─── VenueCard ───
  group('VenueCard', () {
    testWidgets('공연장 이름과 설명이 표시된다', (tester) async {
      final preset = findPresetBySlug('kspo-dome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenueCard(
              preset: preset,
              onTap: () {},
            ),
          ),
        ),
      );
      expect(find.text('KSPO DOME'), findsOneWidget);
      expect(find.text('연습하기 →'), findsOneWidget);
    });

    testWidgets('탭 시 콜백이 호출된다', (tester) async {
      var tapped = false;
      final preset = findPresetBySlug('kspo-dome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenueCard(
              preset: preset,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );
      await tester.tap(find.byType(VenueCard));
      expect(tapped, isTrue);
    });
  });

  // ─── venueId 전달 ───
  group('venueId 전달', () {
    testWidgets('실전 연습 시작 시 venueId가 QueueScreen으로 전달된다', (tester) async {
      final preset = findPresetBySlug('gocheok-skydome')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      await tester.tap(find.text('전체 티켓팅 연습'));
      await tester.pump();
      await tester.pump();
      expect(find.text('나의 대기순서'), findsOneWidget);
    });

    testWidgets('좌석 집중 연습 시 venueId가 VenueMapScreen으로 전달된다', (tester) async {
      final preset = findPresetBySlug('jamsil-arena')!;
      await tester.pumpWidget(
        MaterialApp(
          home: VenueDetailScreen(venuePreset: preset),
        ),
      );
      await tester.scrollUntilVisible(
        find.text('좌석 집중 연습'),
        200,
      );
      await tester.tap(find.text('좌석 집중 연습'));
      await tester.pump();
      await tester.pump();
      expect(find.byType(VenueMapRenderer), findsOneWidget);
    });

    test('CaptchaScreen이 venueId를 보존한다', () {
      const venueId = 'gocheok';
      final screen = CaptchaScreen(
        timeTracker: TimeTracker(),
        venueId: venueId,
      );
      expect(screen.venueId, venueId);
    });
  });
}
