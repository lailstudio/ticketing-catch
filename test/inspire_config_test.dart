import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/inspire_block_map.dart';
import 'package:ticketing/data/venue_configs/inspire_config.dart';
import 'package:ticketing/data/venue_data_registry.dart';
import 'package:ticketing/services/seat_block_generator.dart';

void main() {
  group('인스파이어 아레나 config', () {
    test('viewBox가 1000x850이다', () {
      expect(inspireConfig.viewBoxWidth, 1000);
      expect(inspireConfig.viewBoxHeight, 850);
    });

    test('37개 section이 존재한다', () {
      expect(inspireConfig.sections.length, 37);
    });

    test('section ID에 중복이 없다', () {
      final ids = inspireConfig.sections.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('모든 section ID가 올바르다', () {
      final ids = inspireConfig.sections.map((s) => s.id).toSet();
      final expected = {
        'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8',
        '114', '113', '112', '111', '110',
        '214', '213', '212', '211', '210', '209', '208', '207',
        '206', '205', '204', '203', '202',
        '314', '313', '312', '311', '310', '309', '308',
        '102', '103', '104', '105',
      };
      expect(ids, expected);
    });

    test('FLOOR section은 F1~F8이다', () {
      final floors = inspireConfig.sections
          .where((s) => s.level == 'floor')
          .map((s) => s.id)
          .toSet();
      expect(floors, {'F1', 'F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8'});
    });

    test('1F section은 9개이다 (좌5 + 우4)', () {
      final sections1f = inspireConfig.sections
          .where((s) => s.level == '1f')
          .map((s) => s.id)
          .toSet();
      expect(sections1f, {
        '114', '113', '112', '111', '110',
        '102', '103', '104', '105',
      });
    });

    test('2F section은 13개이다', () {
      final sections2f = inspireConfig.sections
          .where((s) => s.level == '2f')
          .map((s) => s.id)
          .toSet();
      expect(sections2f, {
        '214', '213', '212', '211', '210',
        '209', '208', '207',
        '206', '205', '204', '203', '202',
      });
    });

    test('3F section은 7개이다', () {
      final sections3f = inspireConfig.sections
          .where((s) => s.level == '3f')
          .map((s) => s.id)
          .toSet();
      expect(sections3f, {
        '314', '313', '312', '311', '310', '309', '308',
      });
    });

    test('모든 polygon이 짝수 개 좌표를 가진다 (최소 3꼭짓점)', () {
      for (final s in inspireConfig.sections) {
        expect(s.polygon.length % 2, 0, reason: 'section ${s.id}');
        expect(s.polygon.length >= 6, true,
            reason: 'section ${s.id} has < 3 vertices');
      }
    });

    test('모든 좌표가 viewBox(1000x850) 내에 있다', () {
      for (final s in inspireConfig.sections) {
        for (int i = 0; i < s.polygon.length; i += 2) {
          final x = s.polygon[i];
          final y = s.polygon[i + 1];
          expect(x >= 0 && x <= inspireConfig.viewBoxWidth, true,
              reason: 'section ${s.id} x=$x out of bounds');
          expect(y >= 0 && y <= inspireConfig.viewBoxHeight, true,
              reason: 'section ${s.id} y=$y out of bounds');
        }
      }
    });

    test('decoration에 STAGE와 CONSOLE이 있다', () {
      final labels = inspireConfig.decorations
          .where((d) => d.label != null)
          .map((d) => d.label)
          .toSet();
      expect(labels, containsAll(['STAGE', 'CONSOLE']));
    });

    test('VenueData가 정상 생성된다', () {
      final venue = venueDataFor('inspire');
      expect(venue.id, 'inspire');
      expect(venue.name, '인스파이어 아레나');
      expect(venue.sections.length, 37);
      expect(venue.grades.length, 4);
    });
  });

  group('인스파이어 상세 좌석', () {
    test('모든 section이 inspireBlockMap에 정의되어 있다', () {
      final sectionIds =
          inspireConfig.sections.map((s) => s.id).toSet();
      for (final id in sectionIds) {
        expect(inspireBlockMap.containsKey(id), isTrue,
            reason: 'Missing: $id');
      }
    });

    test('seatCount에 단행 스파이크가 없다', () {
      for (final entry in inspireBlockMap.entries) {
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
      for (final entry in inspireBlockMap.entries) {
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
      for (final entry in inspireBlockMap.entries) {
        final rows = generateBlockRows(entry.value);
        expect(rows.length, entry.value.rows,
            reason: entry.key);
      }
    });

    test('총 좌석 수가 목표 대비 ±20% 이내이다', () {
      for (final entry in inspireBlockMap.entries) {
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

    test('F1~F8은 동일한 floorRect preset을 공유한다', () {
      final f1Rows = generateBlockRows(inspireBlockMap['F1']!);
      for (final id in ['F2', 'F3', 'F4', 'F5', 'F6', 'F7', 'F8']) {
        final rows = generateBlockRows(inspireBlockMap[id]!);
        expect(rows.length, f1Rows.length, reason: '$id rows');
        for (int i = 0; i < rows.length; i++) {
          expect(rows[i].seatCount, f1Rows[i].seatCount,
              reason: '$id row ${i + 1} seatCount');
        }
      }
    });

    test('좌측 vertBlock (114~112) ↔ 우측 (102~104) seatCount가 동일하다', () {
      final pairs = [['114', '102'], ['113', '103'], ['112', '104']];
      for (final pair in pairs) {
        final left = generateBlockRows(inspireBlockMap[pair[0]]!);
        final right = generateBlockRows(inspireBlockMap[pair[1]]!);
        expect(left.length, right.length, reason: '${pair[0]}↔${pair[1]}');
        for (int i = 0; i < left.length; i++) {
          expect(left[i].seatCount, right[i].seatCount,
              reason: '${pair[0]}↔${pair[1]} row ${i + 1}');
        }
      }
    });

    test('111 ↔ 105 seatCount가 동일하다 (vertSmall mirror)', () {
      final left = generateBlockRows(inspireBlockMap['111']!);
      final right = generateBlockRows(inspireBlockMap['105']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('110 ↔ 206 seatCount가 동일하다 (diag mirror)', () {
      final left = generateBlockRows(inspireBlockMap['110']!);
      final right = generateBlockRows(inspireBlockMap['206']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('209 ↔ 207 seatCount가 동일하다 (horizTrap mirror)', () {
      final left = generateBlockRows(inspireBlockMap['209']!);
      final right = generateBlockRows(inspireBlockMap['207']!);
      expect(left.length, right.length);
      for (int i = 0; i < left.length; i++) {
        expect(left[i].seatCount, right[i].seatCount,
            reason: 'row ${i + 1}');
      }
    });

    test('VenueData에서 block preset이 적용된다', () {
      final venue = venueDataFor('inspire');
      for (final id in ['F1', '102', '111', '110', '210', '206', '209', '310']) {
        final section = venue.sections.firstWhere((s) => s.id == id);
        final config = inspireBlockMap[id]!;
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
