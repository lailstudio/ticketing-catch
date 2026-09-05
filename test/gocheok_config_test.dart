import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/gocheok_config.dart';
import 'package:ticketing/data/venue_data_registry.dart';

void main() {
  group('고척스카이돔 config', () {
    test('viewBox가 1000x850이다', () {
      expect(gocheokConfig.viewBoxWidth, 1000);
      expect(gocheokConfig.viewBoxHeight, 850);
    });

    test('113개 section이 존재한다', () {
      expect(gocheokConfig.sections.length, 113);
    });

    test('section ID에 중복이 없다', () {
      final ids = gocheokConfig.sections.map((s) => s.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('VIP section은 F1~F13 (13개)이다', () {
      final vip = gocheokConfig.sections
          .where((s) => s.level == 'vip')
          .map((s) => s.id)
          .toSet();
      expect(vip.length, 13);
      for (int i = 1; i <= 13; i++) {
        expect(vip.contains('F$i'), true, reason: 'F$i missing from VIP');
      }
    });

    test('FR section은 14개이다', () {
      final fr = gocheokConfig.sections
          .where((s) => s.level == 'fr')
          .map((s) => s.id)
          .toSet();
      expect(fr.length, 14);
      expect(fr, containsAll([
        'F14', 'F15', 'F16', 'F17',
        'F19', 'F20', 'F21', 'F22',
        'F23', 'F24', 'F25', 'F26', 'F27', 'F28',
      ]));
    });

    test('R section은 23개이다 (200s + T sections)', () {
      final r = gocheokConfig.sections
          .where((s) => s.level == 'r')
          .map((s) => s.id)
          .toSet();
      expect(r.length, 23);
      for (int i = 201; i <= 210; i++) {
        expect(r.contains('$i'), true, reason: '$i missing from R');
      }
      expect(r, containsAll([
        'T01', 'T02', 'T03', 'T04', 'T05', 'T06', 'T07',
        'T11', 'T12', 'T13', 'T15', 'T16', 'T17',
      ]));
    });

    test('S section은 22개이다 (301~322)', () {
      final s = gocheokConfig.sections
          .where((sec) => sec.level == 's')
          .map((sec) => sec.id)
          .toSet();
      expect(s.length, 22);
      for (int i = 301; i <= 322; i++) {
        expect(s.contains('$i'), true, reason: '$i missing from S');
      }
    });

    test('A section은 24개이다 (401~424)', () {
      final a = gocheokConfig.sections
          .where((s) => s.level == 'a')
          .map((s) => s.id)
          .toSet();
      expect(a.length, 24);
      for (int i = 401; i <= 424; i++) {
        expect(a.contains('$i'), true, reason: '$i missing from A');
      }
    });

    test('기타 section은 17개이다 (100s + F18, F29, F30)', () {
      final etc = gocheokConfig.sections
          .where((s) => s.level == 'etc')
          .map((s) => s.id)
          .toSet();
      expect(etc.length, 17);
      expect(etc, containsAll(['F18', 'F29', 'F30']));
      for (int i = 101; i <= 114; i++) {
        expect(etc.contains('$i'), true, reason: '$i missing from etc');
      }
    });

    test('모든 polygon이 짝수 개 좌표를 가진다 (최소 3꼭짓점)', () {
      for (final s in gocheokConfig.sections) {
        expect(s.polygon.length % 2, 0, reason: 'section ${s.id}');
        expect(s.polygon.length >= 6, true,
            reason: 'section ${s.id} has < 3 vertices');
      }
    });

    test('모든 좌표가 viewBox(1000x850) 내에 있다', () {
      for (final s in gocheokConfig.sections) {
        for (int i = 0; i < s.polygon.length; i += 2) {
          final x = s.polygon[i];
          final y = s.polygon[i + 1];
          expect(x >= 0 && x <= gocheokConfig.viewBoxWidth, true,
              reason: 'section ${s.id} x=$x out of bounds');
          expect(y >= 0 && y <= gocheokConfig.viewBoxHeight, true,
              reason: 'section ${s.id} y=$y out of bounds');
        }
      }
    });

    test('decoration에 STAGE가 있다', () {
      final labels = gocheokConfig.decorations
          .where((d) => d.label != null)
          .map((d) => d.label)
          .toSet();
      expect(labels, contains('STAGE'));
    });

    test('등급별 colorRole이 올바르다', () {
      for (final s in gocheokConfig.sections) {
        switch (s.level) {
          case 'vip':
            expect(s.colorRole, 'gocheok-vip', reason: s.id);
          case 'fr':
            expect(s.colorRole, 'gocheok-fr', reason: s.id);
          case 'r':
            expect(s.colorRole, 'gocheok-r', reason: s.id);
          case 's':
            expect(s.colorRole, 'gocheok-s', reason: s.id);
          case 'a':
            expect(s.colorRole, 'gocheok-a', reason: s.id);
          case 'etc':
            expect(s.colorRole, 'gocheok-gray', reason: s.id);
        }
      }
    });

    test('VenueData가 정상 생성된다', () {
      final venue = venueDataFor('gocheok');
      expect(venue.id, 'gocheok');
      expect(venue.name, '고척스카이돔');
      expect(venue.sections.length, 113);
      expect(venue.grades.length, 6);
    });

    test('등급 순서가 VIP → FR → R → S → A → 기타이다', () {
      final venue = venueDataFor('gocheok');
      final gradeIds = venue.grades.map((g) => g.id).toList();
      expect(gradeIds, ['vip', 'fr', 'r', 's', 'a', 'etc']);
    });
  });
}
