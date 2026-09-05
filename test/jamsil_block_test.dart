import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/jamsil_block_map.dart';
import 'package:ticketing/data/venue_configs/jamsil_config.dart';
import 'package:ticketing/data/venue_data_registry.dart';
import 'package:ticketing/services/seat_block_generator.dart';

void main() {
  group('잠실실내체육관 상세 좌석', () {
    test('모든 section이 jamsilBlockMap에 정의되어 있다', () {
      final sectionIds =
          jamsilConfig.sections.map((s) => s.id).toSet();
      for (final id in sectionIds) {
        expect(jamsilBlockMap.containsKey(id), isTrue,
            reason: 'Missing: $id');
      }
    });

    test('blockMap 크기가 config section 고유 ID 수와 일치한다', () {
      final uniqueIds =
          jamsilConfig.sections.map((s) => s.id).toSet();
      expect(jamsilBlockMap.length, uniqueIds.length);
    });

    test('seatCount에 단행 스파이크가 없다', () {
      for (final entry in jamsilBlockMap.entries) {
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

    test('모든 행의 seatCount >= 4, startOffset >= 0', () {
      for (final entry in jamsilBlockMap.entries) {
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
      for (final entry in jamsilBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        expect(rows.length, entry.value.rows,
            reason: entry.key);
      }
    });

    test('총 좌석 수가 목표 대비 ±20% 이내이다', () {
      for (final entry in jamsilBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        final total = rows.fold<int>(0, (sum, r) => sum + r.seatCount);
        final target = entry.value.targetSeats;
        final ratio = total / target;
        expect(ratio, greaterThan(0.80),
            reason: '${entry.key}: $total vs target $target');
        expect(ratio, lessThan(1.20),
            reason: '${entry.key}: $total vs target $target');
      }
    });

    test('F1/F2 FLOOR 좌석 수가 100~170 범위이다', () {
      for (final id in ['F1', 'F2']) {
        final rows = generateBlockRows(jamsilBlockMap[id]!);
        final total = rows.fold<int>(0, (sum, r) => sum + r.seatCount);
        expect(total, greaterThanOrEqualTo(100), reason: id);
        expect(total, lessThanOrEqualTo(170), reason: id);
      }
    });

    test('F1 ↔ F2 seatCount가 동일하다 (동일 preset)', () {
      final f1 = generateBlockRows(jamsilBlockMap['F1']!);
      final f2 = generateBlockRows(jamsilBlockMap['F2']!);
      expect(f1.length, f2.length);
      for (int i = 0; i < f1.length; i++) {
        expect(f1[i].seatCount, f2[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('12 ↔ 15 seatCount가 동일하다 (angledSmallFan mirror)', () {
      final left = generateBlockRows(jamsilBlockMap['15']!);
      final right = generateBlockRows(jamsilBlockMap['12']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('11 ↔ 16 seatCount가 동일하다 (sideAngledFan mirror)', () {
      final left = generateBlockRows(jamsilBlockMap['16']!);
      final right = generateBlockRows(jamsilBlockMap['11']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('10 ↔ 17 seatCount가 동일하다 (sideSmallFan mirror)', () {
      final left = generateBlockRows(jamsilBlockMap['17']!);
      final right = generateBlockRows(jamsilBlockMap['10']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('30 ↔ 33 seatCount가 동일하다 (angledLargeFan mirror)', () {
      final left = generateBlockRows(jamsilBlockMap['33']!);
      final right = generateBlockRows(jamsilBlockMap['30']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('29 ↔ 34 seatCount가 동일하다 (sideLargeFan mirror)', () {
      final left = generateBlockRows(jamsilBlockMap['34']!);
      final right = generateBlockRows(jamsilBlockMap['29']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('31 ↔ 32 seatCount가 동일하다 (centerLargeFan 동일 preset)', () {
      final left = generateBlockRows(jamsilBlockMap['32']!);
      final right = generateBlockRows(jamsilBlockMap['31']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('VenueData에서 block preset이 적용된다', () {
      final venue = venueDataFor('jamsil');
      final sampleIds = [
        'F1', 'F2', '14', '13', '15', '12',
        '16', '11', '17', '10',
        '32', '31', '33', '30', '34', '29',
      ];
      for (final id in sampleIds) {
        final section = venue.sections.firstWhere((s) => s.id == id);
        final config = jamsilBlockMap[id]!;
        expect(section.rows.length, config.rows,
            reason: '$id row count');
        final maxSeat =
            section.rows.map((r) => r.seatCount).reduce(max);
        expect(maxSeat, greaterThanOrEqualTo(config.frontSeats),
            reason: '$id max seat');
      }
    });
  });
}
