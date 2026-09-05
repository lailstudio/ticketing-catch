import 'package:flutter_test/flutter_test.dart';
import 'package:ticketing/data/venue_configs/jamsil_config.dart';
import 'package:ticketing/data/venue_data_registry.dart';

void main() {
  group('잠실실내체육관 config', () {
    test('viewBox가 1000x850이다', () {
      expect(jamsilConfig.viewBoxWidth, 1000);
      expect(jamsilConfig.viewBoxHeight, 850);
    });

    test('16개 section이 존재한다', () {
      expect(jamsilConfig.sections.length, 16);
    });

    test('모든 section ID가 올바르다', () {
      final ids = jamsilConfig.sections.map((s) => s.id).toSet();
      expect(ids, containsAll([
        'F1', 'F2',
        '17', '16', '15', '14', '13', '12', '11', '10',
        '34', '33', '32', '31', '30', '29',
      ]));
    });

    test('FLOOR section은 F1, F2이다', () {
      final floors = jamsilConfig.sections
          .where((s) => s.level == 'floor')
          .map((s) => s.id)
          .toSet();
      expect(floors, {'F1', 'F2'});
    });

    test('2F section은 10~17이다', () {
      final sections2f = jamsilConfig.sections
          .where((s) => s.level == '2f')
          .map((s) => s.id)
          .toSet();
      expect(sections2f, {'10', '11', '12', '13', '14', '15', '16', '17'});
    });

    test('3F section은 29~34이다', () {
      final sections3f = jamsilConfig.sections
          .where((s) => s.level == '3f')
          .map((s) => s.id)
          .toSet();
      expect(sections3f, {'29', '30', '31', '32', '33', '34'});
    });

    test('모든 polygon이 짝수 개 좌표를 가진다', () {
      for (final s in jamsilConfig.sections) {
        expect(s.polygon.length % 2, 0, reason: 'section ${s.id}');
        expect(s.polygon.length >= 6, true,
            reason: 'section ${s.id} has < 3 vertices');
      }
    });

    test('모든 좌표가 viewBox 내에 있다', () {
      for (final s in jamsilConfig.sections) {
        for (int i = 0; i < s.polygon.length; i += 2) {
          final x = s.polygon[i];
          final y = s.polygon[i + 1];
          expect(x >= 0 && x <= jamsilConfig.viewBoxWidth, true,
              reason: 'section ${s.id} x=$x out of bounds');
          expect(y >= 0 && y <= jamsilConfig.viewBoxHeight, true,
              reason: 'section ${s.id} y=$y out of bounds');
        }
      }
    });

    test('decoration에 STAGE와 CONSOLE이 있다', () {
      final labels = jamsilConfig.decorations
          .where((d) => d.label != null)
          .map((d) => d.label)
          .toSet();
      expect(labels, containsAll(['STAGE', 'CONSOLE']));
    });

    test('VenueData가 정상 생성된다', () {
      final venue = venueDataFor('jamsil');
      expect(venue.id, 'jamsil');
      expect(venue.name, '잠실실내체육관');
      expect(venue.sections.length, 16);
      expect(venue.grades.length, 3);
    });

    test('sectionId로 VenueSection을 찾을 수 있다', () {
      final venue = venueDataFor('jamsil');
      for (final id in ['F1', 'F2', '17', '10', '34', '29']) {
        final match = venue.sections.where((s) => s.id == id);
        expect(match.isNotEmpty, true, reason: 'section $id not found');
        expect(match.first.rows.isNotEmpty, true,
            reason: 'section $id has no rows');
      }
    });
  });
}
