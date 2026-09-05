import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/kspo_block_map.dart';
import 'package:ticketing/services/seat_block_generator.dart';

void main() {
  group('steppedInterpolation', () {
    test('동일 값이면 전부 같은 값', () {
      final result = steppedInterpolation(10, 5, 5);
      expect(result, List.filled(10, 5));
    });

    test('count=1이면 start만', () {
      expect(steppedInterpolation(1, 3, 7), [3]);
    });

    test('각 단계가 최소 2행', () {
      final result = steppedInterpolation(20, 5, 14);
      int groupLen = 1;
      for (int i = 1; i < result.length; i++) {
        if (result[i] == result[i - 1]) {
          groupLen++;
        } else {
          expect(groupLen, greaterThanOrEqualTo(2),
              reason: 'Group with value ${result[i - 1]} has length $groupLen');
          groupLen = 1;
        }
      }
      expect(groupLen, greaterThanOrEqualTo(1));
    });

    test('단조 증가', () {
      final result = steppedInterpolation(18, 8, 14);
      for (int i = 1; i < result.length; i++) {
        expect(result[i], greaterThanOrEqualTo(result[i - 1]));
      }
      expect(result.first, 8);
    });

    test('단조 감소', () {
      final result = steppedInterpolation(18, 14, 8);
      for (int i = 1; i < result.length; i++) {
        expect(result[i], lessThanOrEqualTo(result[i - 1]));
      }
      expect(result.first, 14);
    });

    test('길이가 정확히 count', () {
      for (int c = 2; c <= 30; c++) {
        final result = steppedInterpolation(c, 3, 10);
        expect(result.length, c, reason: 'count=$c');
      }
    });
  });

  group('generateBlockRows', () {
    test('leftFixed 정렬은 slant 없을 때 offset이 0이다', () {
      final rows = generateBlockRows(const SectionSeatConfig(
        shape: SeatShape.trapezoid,
        rows: 20,
        frontSeats: 8,
        rearSeats: 12,
        alignment: SeatAlignment.leftFixed,
      ));
      for (final r in rows) {
        expect(r.startOffset, 0);
      }
    });

    test('rightFixed 정렬은 right edge가 일정하다 (slant 없을 때)', () {
      final rows = generateBlockRows(const SectionSeatConfig(
        shape: SeatShape.trapezoid,
        rows: 20,
        frontSeats: 8,
        rearSeats: 12,
        alignment: SeatAlignment.rightFixed,
      ));
      final rightEdge = rows.map((r) => r.startOffset + r.seatCount).toSet();
      expect(rightEdge.length, 1, reason: 'right edge should be constant');
    });

    test('centered 정렬은 양쪽 여백이 대칭적이다', () {
      final rows = generateBlockRows(const SectionSeatConfig(
        shape: SeatShape.trapezoid,
        rows: 20,
        frontSeats: 8,
        rearSeats: 12,
        alignment: SeatAlignment.centered,
      ));
      final maxCount = rows.map((r) => r.seatCount).reduce(max);
      for (final r in rows) {
        final leftMargin = r.startOffset;
        final rightMargin = maxCount - (r.startOffset + r.seatCount);
        expect((leftMargin - rightMargin).abs(), lessThanOrEqualTo(1));
      }
    });

    test('slant right는 offset이 단조 증가한다', () {
      final rows = generateBlockRows(const SectionSeatConfig(
        shape: SeatShape.rectangle,
        rows: 20,
        frontSeats: 10,
        rearSeats: 10,
        alignment: SeatAlignment.leftFixed,
        slant: SlantDirection.right,
        slantAmount: SlantAmount.medium,
      ));
      for (int i = 1; i < rows.length; i++) {
        expect(rows[i].startOffset,
            greaterThanOrEqualTo(rows[i - 1].startOffset));
      }
    });

    test('slant left는 offset이 단조 감소한다', () {
      final rows = generateBlockRows(const SectionSeatConfig(
        shape: SeatShape.rectangle,
        rows: 20,
        frontSeats: 10,
        rearSeats: 10,
        alignment: SeatAlignment.leftFixed,
        slant: SlantDirection.left,
        slantAmount: SlantAmount.medium,
      ));
      for (int i = 1; i < rows.length; i++) {
        expect(rows[i].startOffset,
            lessThanOrEqualTo(rows[i - 1].startOffset));
      }
    });

    test('seatCount가 단행 스파이크 없이 단계적으로 변한다', () {
      for (final entry in kspoBlockMap.entries) {
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
      for (final entry in kspoBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        for (final r in rows) {
          expect(r.seatCount, greaterThanOrEqualTo(4),
              reason: 'Section ${entry.key} row ${r.rowNumber}');
          expect(r.startOffset, greaterThanOrEqualTo(0),
              reason: 'Section ${entry.key} row ${r.rowNumber}');
        }
      }
    });

    test('config에 지정된 rows 수만큼 행이 생성된다', () {
      for (final entry in kspoBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        expect(rows.length, entry.value.rows,
            reason: 'Section ${entry.key}');
      }
    });
  });

  group('KSPO 전체 구역', () {
    test('모든 KSPO 구역이 블록맵에 정의되어 있다', () {
      final expectedIds = [
        'A', 'B', 'C', 'D', 'E', 'F',
        '1', '2', '3', '4', '5', '6', '7', '8',
        '9', '10', '11', '12', '13', '14', '15',
        '25', '26', '27', '28', '29', '30',
        '31', '32', '33', '34', '35', '36',
        '37', '38', '39', '40', '41', '42',
      ];
      for (final id in expectedIds) {
        expect(kspoBlockMap.containsKey(id), isTrue, reason: 'Missing: $id');
      }
    });

    test('각 구역의 총 좌석 수가 목표 대비 ±15% 이내', () {
      for (final entry in kspoBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        final total = rows.fold<int>(0, (sum, r) => sum + r.seatCount);
        final target = entry.value.targetSeats;
        final ratio = total / target;
        expect(ratio, greaterThan(0.85),
            reason: '${entry.key}: $total seats vs target $target');
        expect(ratio, lessThan(1.15),
            reason: '${entry.key}: $total seats vs target $target');
      }
    });

    test('각 구역의 seatCount에 단행 스파이크가 없다', () {
      for (final entry in kspoBlockMap.entries) {
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
  });

  group('Mirror 대칭 검증', () {
    final mirrorPairs = [
      ['D', 'F'],
      ['1', '15'],
      ['2', '14'],
      ['3', '13'],
      ['4', '12'],
      ['5', '11'],
      ['6', '10'],
      ['7', '9'],
      ['25', '42'],
      ['26', '41'],
      ['27', '40'],
      ['28', '39'],
      ['29', '38'],
      ['30', '37'],
      ['31', '36'],
      ['32', '35'],
      ['33', '34'],
    ];

    for (final pair in mirrorPairs) {
      test('${pair[0]} ↔ ${pair[1]} seatCount가 동일하다', () {
        final left = generateBlockRows(kspoBlockMap[pair[0]]!);
        final right = generateBlockRows(kspoBlockMap[pair[1]]!);
        expect(left.length, right.length);
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: 'row ${i + 1}');
        }
      });
    }
  });

  group('oneSideCurve (D/F)', () {
    test('D의 right edge가 일정하다', () {
      final rows = generateBlockRows(kspoBlockMap['D']!);
      final rightEdges = rows.map((r) => r.startOffset + r.seatCount).toSet();
      expect(rightEdges.length, 1,
          reason: 'D: rightFixed should keep right edge constant');
    });

    test('F의 left edge가 일정하다 (offset=0)', () {
      final rows = generateBlockRows(kspoBlockMap['F']!);
      for (final r in rows) {
        expect(r.startOffset, 0, reason: 'F: leftFixed should keep offset=0');
      }
    });

    test('seatCount가 단조 감소하며 단행 스파이크가 없다', () {
      final rows = generateBlockRows(kspoBlockMap['D']!);
      final counts = rows.map((r) => r.seatCount).toList();
      for (int i = 1; i < counts.length; i++) {
        expect(counts[i], lessThanOrEqualTo(counts[i - 1]),
            reason: 'row ${i + 1}: monotone decrease');
      }
      for (int i = 1; i < counts.length - 1; i++) {
        if (counts[i] != counts[i - 1] && counts[i] != counts[i + 1]) {
          fail('단행 스파이크 at row ${i + 1}');
        }
      }
    });

    test('첫 행 seatCount > 마지막 행 seatCount (넓은 위→좁은 아래)', () {
      final rows = generateBlockRows(kspoBlockMap['D']!);
      expect(rows.first.seatCount, greaterThan(rows.last.seatCount));
    });
  });

  group('centerSoftArc (8)', () {
    test('대부분의 행이 frontSeats와 동일하다', () {
      final config = kspoBlockMap['8']!;
      final rows = generateBlockRows(config);
      final frontCount =
          rows.where((r) => r.seatCount == config.frontSeats).length;
      expect(frontCount, greaterThan(rows.length * 0.6),
          reason: '60% 이상의 행이 frontSeats여야 한다');
    });

    test('seatCount 범위가 좁다 (1~2 차이)', () {
      final rows = generateBlockRows(kspoBlockMap['8']!);
      final counts = rows.map((r) => r.seatCount).toList();
      final range = counts.reduce(max) - counts.reduce(min);
      expect(range, lessThanOrEqualTo(2));
    });

    test('centered 정렬이 적용된다', () {
      final rows = generateBlockRows(kspoBlockMap['8']!);
      final maxCount = rows.map((r) => r.seatCount).reduce(max);
      for (final r in rows) {
        final leftMargin = r.startOffset;
        final rightMargin = maxCount - (r.startOffset + r.seatCount);
        expect((leftMargin - rightMargin).abs(), lessThanOrEqualTo(1));
      }
    });
  });

  group('Section 5 rightFixed 검증', () {
    test('right edge 이동이 slant amount 이내이다', () {
      final rows = generateBlockRows(kspoBlockMap['5']!);
      final rightEdges = rows.map((r) => r.startOffset + r.seatCount).toList();
      final maxEdge = rightEdges.reduce(max);
      final minEdge = rightEdges.reduce(min);
      expect(maxEdge - minEdge, lessThanOrEqualTo(2),
          reason: 'right edge shift should be <= slant small (2)');
    });
  });
}
