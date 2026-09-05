import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/olympic_block_map.dart';
import 'package:ticketing/data/venue_configs/olympic_config.dart';
import 'package:ticketing/data/venue_data_registry.dart';
import 'package:ticketing/services/seat_block_generator.dart';

void main() {
  group('올림픽홀 config', () {
    test('viewBox가 1000x850이다', () {
      expect(olympicConfig.viewBoxWidth, 1000);
      expect(olympicConfig.viewBoxHeight, 850);
    });

    test('36개 section entry가 존재한다 (multiPolygon 포함)', () {
      expect(olympicConfig.sections.length, 36);
    });

    test('21개 고유 section ID가 존재한다', () {
      final ids = olympicConfig.sections.map((s) => s.id).toSet();
      expect(ids.length, 21);
      expect(ids, {
        'F1', 'F2', 'F3', 'F4',
        'G', 'H',
        'B1', 'B2', 'D1', 'D2',
        'A1', 'A2', 'A3', 'A4',
        'E1', 'E2', 'E3', 'E4',
        'C1', 'C2', 'C3',
      });
    });

    test('FLOOR section은 F1~F4이다', () {
      final floors = olympicConfig.sections
          .where((s) => s.level == 'floor')
          .map((s) => s.id)
          .toSet();
      expect(floors, {'F1', 'F2', 'F3', 'F4'});
    });

    test('1F section ID는 G, H, B1, B2, D1, D2, C1, C2, C3이다', () {
      final ids1f = olympicConfig.sections
          .where((s) => s.level == '1f')
          .map((s) => s.id)
          .toSet();
      expect(ids1f, {'G', 'H', 'B1', 'B2', 'D1', 'D2', 'C1', 'C2', 'C3'});
    });

    test('2F section ID는 A1~A4, E1~E4, C1~C3이다', () {
      final ids2f = olympicConfig.sections
          .where((s) => s.level == '2f')
          .map((s) => s.id)
          .toSet();
      expect(ids2f, {
        'A1', 'A2', 'A3', 'A4',
        'E1', 'E2', 'E3', 'E4',
        'C1', 'C2', 'C3',
      });
    });

    test('multiPolygon section은 15개이다', () {
      final idCounts = <String, int>{};
      for (final s in olympicConfig.sections) {
        idCounts[s.id] = (idCounts[s.id] ?? 0) + 1;
      }
      final multi = idCounts.entries.where((e) => e.value > 1).map((e) => e.key).toSet();
      expect(multi, {
        'A1', 'A2', 'A3', 'A4',
        'B1', 'B2', 'D1', 'D2',
        'E1', 'E2', 'E3', 'E4',
        'C1', 'C2', 'C3',
      });
      expect(multi.length, 15);
    });

    test('모든 polygon entry에 section ID가 표시된다', () {
      for (final s in olympicConfig.sections) {
        expect(s.label, s.id, reason: '${s.id} 모든 entry에 라벨 필요');
      }
    });

    test('모든 polygon이 짝수 개 좌표를 가진다 (최소 3꼭짓점)', () {
      for (final s in olympicConfig.sections) {
        expect(s.polygon.length % 2, 0, reason: 'section ${s.id}');
        expect(s.polygon.length >= 6, true,
            reason: 'section ${s.id} has < 3 vertices');
      }
    });

    test('모든 좌표가 viewBox(1000x850) 내에 있다', () {
      for (final s in olympicConfig.sections) {
        for (int i = 0; i < s.polygon.length; i += 2) {
          final x = s.polygon[i];
          final y = s.polygon[i + 1];
          expect(x >= 0 && x <= olympicConfig.viewBoxWidth, true,
              reason: 'section ${s.id} x=$x out of bounds');
          expect(y >= 0 && y <= olympicConfig.viewBoxHeight, true,
              reason: 'section ${s.id} y=$y out of bounds');
        }
      }
    });

    test('decoration 좌표도 viewBox(1000x850) 내에 있다', () {
      for (final d in olympicConfig.decorations) {
        for (int i = 0; i < d.polygon.length; i += 2) {
          final x = d.polygon[i];
          final y = d.polygon[i + 1];
          expect(x >= 0 && x <= olympicConfig.viewBoxWidth, true,
              reason: 'decoration x=$x out of bounds');
          expect(y >= 0 && y <= olympicConfig.viewBoxHeight, true,
              reason: 'decoration y=$y out of bounds');
        }
      }
    });

    test('decoration에 CONSOLE이 있다', () {
      final labels = olympicConfig.decorations
          .where((d) => d.label != null)
          .map((d) => d.label)
          .toSet();
      expect(labels, contains('CONSOLE'));
    });

    test('STAGE label은 labelDecorations에 있다', () {
      final stageLabels = olympicConfig.labelDecorations
          .where((ld) => ld.label == 'STAGE')
          .toList();
      expect(stageLabels.length, 1);
      expect(stageLabels[0].cx, closeTo(500.75, 1.0));
      expect(stageLabels[0].cy, closeTo(147.6, 1.0));
    });

    test('STAGE polygon decoration에는 label이 없다', () {
      final stageDecos = olympicConfig.decorations
          .where((d) => d.colorValue == 0xFF152746)
          .toList();
      expect(stageDecos.length, 1);
      expect(stageDecos[0].label, isNull);
    });

    test('non-interactive transition decoration이 4개 있다', () {
      final transitions = olympicConfig.decorations
          .where((d) => d.label == null && d.colorValue == 0xFF5A6577)
          .toList();
      expect(transitions.length, 4);
    });

    test('C section inner는 lavender, outer는 mint이다', () {
      for (final cId in ['C1', 'C2', 'C3']) {
        final entries = olympicConfig.sections.where((s) => s.id == cId).toList();
        expect(entries.length, 2, reason: '$cId should have 2 entries');
        expect(entries[0].colorRole, 'lavender', reason: '$cId inner');
        expect(entries[1].colorRole, 'mint', reason: '$cId outer');
      }
    });

    test('같은 층 안에서는 모든 polygon이 동일한 색상이다', () {
      for (final s in olympicConfig.sections) {
        switch (s.level) {
          case 'floor':
            expect(s.colorRole, 'coral', reason: '${s.id} floor');
          case '1f':
            expect(s.colorRole, 'lavender', reason: '${s.id} 1f');
          case '2f':
            expect(s.colorRole, 'mint', reason: '${s.id} 2f');
        }
      }
    });

    test('VenueData가 정상 생성된다', () {
      final venue = venueDataFor('olympic');
      expect(venue.id, 'olympic');
      expect(venue.name, '올림픽홀');
      expect(venue.sections.length, 36);
      expect(venue.grades.length, 3);
    });

    test('등급 순서가 FLOOR → 1F → 2F이다', () {
      final venue = venueDataFor('olympic');
      final gradeIds = venue.grades.map((g) => g.id).toList();
      expect(gradeIds, ['floor', '1f', '2f']);
    });
  });

  group('올림픽홀 B1/B2/D1/D2 상세 좌석', () {
    test('olympicBlockMap에 B1, B2, D1, D2가 정의되어 있다', () {
      expect(olympicBlockMap.containsKey('B1'), isTrue);
      expect(olympicBlockMap.containsKey('B2'), isTrue);
      expect(olympicBlockMap.containsKey('D1'), isTrue);
      expect(olympicBlockMap.containsKey('D2'), isTrue);
      expect(olympicBlockMap.length, 4);
    });

    test('B1/D1은 innerBentUpper, B2/D2는 innerBentLower이다', () {
      expect(olympicBlockMap['B1']!.shape, SeatShape.innerBentUpper);
      expect(olympicBlockMap['D1']!.shape, SeatShape.innerBentUpper);
      expect(olympicBlockMap['B2']!.shape, SeatShape.innerBentLower);
      expect(olympicBlockMap['D2']!.shape, SeatShape.innerBentLower);
    });

    test('B1 ↔ D1 seatCount가 동일하다 (mirror)', () {
      final b1 = generateBlockRows(olympicBlockMap['B1']!);
      final d1 = generateBlockRows(olympicBlockMap['D1']!);
      expect(b1.length, d1.length);
      for (int i = 0; i < b1.length; i++) {
        expect(b1[i].seatCount, d1[i].seatCount, reason: 'row ${i + 1}');
      }
    });

    test('B2 ↔ D2 seatCount가 동일하다 (mirror)', () {
      final b2 = generateBlockRows(olympicBlockMap['B2']!);
      final d2 = generateBlockRows(olympicBlockMap['D2']!);
      expect(b2.length, d2.length);
      for (int i = 0; i < b2.length; i++) {
        expect(b2[i].seatCount, d2[i].seatCount, reason: 'row ${i + 1}');
      }
    });

    test('B1은 rightFixed, D1은 leftFixed이다', () {
      expect(olympicBlockMap['B1']!.alignment, SeatAlignment.rightFixed);
      expect(olympicBlockMap['D1']!.alignment, SeatAlignment.leftFixed);
    });

    test('B2는 rightFixed, D2는 leftFixed이다', () {
      expect(olympicBlockMap['B2']!.alignment, SeatAlignment.rightFixed);
      expect(olympicBlockMap['D2']!.alignment, SeatAlignment.leftFixed);
    });

    test('seatCount에 단행 스파이크가 없다', () {
      for (final entry in olympicBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        final counts = rows.map((r) => r.seatCount).toList();
        for (int i = 1; i < counts.length - 1; i++) {
          if (counts[i] != counts[i - 1] && counts[i] != counts[i + 1]) {
            fail('Section ${entry.key}: 단행 스파이크 at row ${i + 1} '
                '(${counts[i - 1]}, ${counts[i]}, ${counts[i + 1]})');
          }
        }
      }
    });

    test('seatCount가 단조 증가한다', () {
      for (final entry in olympicBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        for (int i = 1; i < rows.length; i++) {
          expect(rows[i].seatCount,
              greaterThanOrEqualTo(rows[i - 1].seatCount),
              reason: '${entry.key} row ${i + 1}');
        }
      }
    });

    test('모든 행의 seatCount >= 4, startOffset >= 0', () {
      for (final entry in olympicBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        for (final r in rows) {
          expect(r.seatCount, greaterThanOrEqualTo(4),
              reason: '${entry.key} row ${r.rowNumber}');
          expect(r.startOffset, greaterThanOrEqualTo(0),
              reason: '${entry.key} row ${r.rowNumber}');
        }
      }
    });

    test('config에 지정된 rows 수만큼 행이 생성된다', () {
      for (final entry in olympicBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        expect(rows.length, entry.value.rows,
            reason: entry.key);
      }
    });

    test('총 좌석 수가 목표 대비 ±15% 이내이다', () {
      for (final entry in olympicBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        final total = rows.fold<int>(0, (sum, r) => sum + r.seatCount);
        final target = entry.value.targetSeats;
        final ratio = total / target;
        expect(ratio, greaterThan(0.85),
            reason: '${entry.key}: $total vs target $target');
        expect(ratio, lessThan(1.15),
            reason: '${entry.key}: $total vs target $target');
      }
    });

    test('B1 rightFixed에서 right edge가 일정하다', () {
      final rows = generateBlockRows(olympicBlockMap['B1']!);
      final rightEdges =
          rows.map((r) => r.startOffset + r.seatCount).toSet();
      expect(rightEdges.length, 1);
    });

    test('D1 leftFixed에서 offset이 모두 0이다', () {
      final rows = generateBlockRows(olympicBlockMap['D1']!);
      for (final r in rows) {
        expect(r.startOffset, 0);
      }
    });

    test('bent 보간에서 중반 plateau가 존재한다', () {
      final rows = generateBlockRows(olympicBlockMap['B1']!);
      final counts = rows.map((r) => r.seatCount).toList();
      final midValue = counts[counts.length ~/ 2];
      final midCount =
          counts.where((c) => c == midValue).length;
      expect(midCount, greaterThanOrEqualTo(3),
          reason: 'B1 bent 보간의 중간 plateau는 3행 이상이어야 한다');
    });

    test('VenueData에서 B1/B2/D1/D2가 block preset을 사용한다', () {
      final venue = venueDataFor('olympic');
      for (final id in ['B1', 'B2', 'D1', 'D2']) {
        final section = venue.sections.firstWhere((s) => s.id == id);
        final maxSeat =
            section.rows.map((r) => r.seatCount).reduce(max);
        expect(maxSeat, greaterThanOrEqualTo(13),
            reason: '$id의 최대 좌석 수가 block preset 수준이어야 한다');
      }
    });
  });
}
