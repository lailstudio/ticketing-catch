import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/gocheok_block_map.dart';
import 'package:ticketing/data/venue_configs/gocheok_config.dart';
import 'package:ticketing/data/venue_data_registry.dart';
import 'package:ticketing/services/seat_block_generator.dart';

void main() {
  group('고척스카이돔 상세 좌석', () {
    test('모든 section이 gocheokBlockMap에 정의되어 있다', () {
      final sectionIds =
          gocheokConfig.sections.map((s) => s.id).toSet();
      for (final id in sectionIds) {
        expect(gocheokBlockMap.containsKey(id), isTrue,
            reason: 'Missing: $id');
      }
    });

    test('blockMap 크기가 config section 고유 ID 수와 일치한다', () {
      final uniqueIds =
          gocheokConfig.sections.map((s) => s.id).toSet();
      expect(gocheokBlockMap.length, uniqueIds.length);
    });

    test('seatCount에 단행 스파이크가 없다', () {
      for (final entry in gocheokBlockMap.entries) {
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
      for (final entry in gocheokBlockMap.entries) {
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
      for (final entry in gocheokBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        expect(rows.length, entry.value.rows,
            reason: entry.key);
      }
    });

    test('총 좌석 수가 목표 대비 ±20% 이내이다', () {
      for (final entry in gocheokBlockMap.entries) {
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

    test('F1~F13 VIP 구역의 좌석 수가 40~100 범위이다', () {
      for (int i = 1; i <= 13; i++) {
        final id = 'F$i';
        final rows = generateBlockRows(gocheokBlockMap[id]!);
        final total = rows.fold<int>(0, (sum, r) => sum + r.seatCount);
        expect(total, greaterThanOrEqualTo(40), reason: id);
        expect(total, lessThanOrEqualTo(100), reason: id);
      }
    });

    test('좌측 날개(114~108) ↔ 우측 날개(101~107) seatCount가 동일하다', () {
      final pairs = [
        ['114', '101'], ['113', '102'], ['112', '103'],
        ['111', '104'], ['110', '105'], ['109', '106'],
        ['108', '107'],
      ];
      for (final pair in pairs) {
        final left = generateBlockRows(gocheokBlockMap[pair[0]]!);
        final right = generateBlockRows(gocheokBlockMap[pair[1]]!);
        expect(left.length, right.length,
            reason: '${pair[0]}↔${pair[1]}');
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: '${pair[0]}↔${pair[1]} row ${i + 1}');
        }
      }
    });

    test('좌측 2F(210~206) ↔ 우측 2F(201~205) seatCount가 동일하다', () {
      final pairs = [
        ['210', '201'], ['209', '202'], ['208', '203'],
        ['207', '204'], ['206', '205'],
      ];
      for (final pair in pairs) {
        final left = generateBlockRows(gocheokBlockMap[pair[0]]!);
        final right = generateBlockRows(gocheokBlockMap[pair[1]]!);
        expect(left.length, right.length,
            reason: '${pair[0]}↔${pair[1]}');
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: '${pair[0]}↔${pair[1]} row ${i + 1}');
        }
      }
    });

    test('T 테이블 좌측(T07/T17/T06/T16) ↔ 우측(T01/T11/T02/T12) seatCount가 동일하다', () {
      final pairs = [
        ['T07', 'T01'], ['T17', 'T11'], ['T06', 'T02'], ['T16', 'T12'],
      ];
      for (final pair in pairs) {
        final left = generateBlockRows(gocheokBlockMap[pair[0]]!);
        final right = generateBlockRows(gocheokBlockMap[pair[1]]!);
        expect(left.length, right.length,
            reason: '${pair[0]}↔${pair[1]}');
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: '${pair[0]}↔${pair[1]} row ${i + 1}');
        }
      }
    });

    test('T 테이블 wide(T05/T15) ↔ (T03/T13) seatCount가 동일하다', () {
      final left = generateBlockRows(gocheokBlockMap['T05']!);
      final right = generateBlockRows(gocheokBlockMap['T03']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('3F 좌측 링(322~315) ↔ 우측 링(301~308) seatCount가 동일하다', () {
      final pairs = [
        ['322', '301'], ['321', '302'], ['320', '303'],
        ['319', '304'], ['318', '305'], ['317', '306'],
        ['316', '307'], ['315', '308'],
      ];
      for (final pair in pairs) {
        final left = generateBlockRows(gocheokBlockMap[pair[0]]!);
        final right = generateBlockRows(gocheokBlockMap[pair[1]]!);
        expect(left.length, right.length,
            reason: '${pair[0]}↔${pair[1]}');
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: '${pair[0]}↔${pair[1]} row ${i + 1}');
        }
      }
    });

    test('4F 좌측 외곽(424~417) ↔ 우측 외곽(408~401) seatCount가 동일하다', () {
      final pairs = [
        ['424', '401'], ['423', '402'], ['422', '403'],
        ['421', '404'], ['420', '405'], ['419', '406'],
        ['418', '407'], ['417', '408'],
      ];
      for (final pair in pairs) {
        final left = generateBlockRows(gocheokBlockMap[pair[0]]!);
        final right = generateBlockRows(gocheokBlockMap[pair[1]]!);
        expect(left.length, right.length,
            reason: '${pair[0]}↔${pair[1]}');
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: '${pair[0]}↔${pair[1]} row ${i + 1}');
        }
      }
    });

    test('VenueData에서 block preset이 적용된다', () {
      final venue = venueDataFor('gocheok');
      final sampleIds = [
        'F1', 'F8', 'F16', '114', '101', '210', '201',
        'T07', 'T01', 'T04', '322', '301', '314',
        '424', '401', '416',
      ];
      for (final id in sampleIds) {
        final section = venue.sections.firstWhere((s) => s.id == id);
        final config = gocheokBlockMap[id]!;
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
