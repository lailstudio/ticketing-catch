import 'dart:math';

import '../models/practice_seat.dart';
import '../models/seat_status.dart';
import '../models/venue.dart';

class SeatMapGenerator {
  final Random _random;

  SeatMapGenerator({Random? random}) : _random = random ?? Random();

  List<PracticeSeat> generate({
    required String section,
    required List<SectionRowDef> rows,
    int availableCount = 2,
  }) {
    final seats = <PracticeSeat>[];
    for (final row in rows) {
      for (int num = 1; num <= row.seatCount; num++) {
        seats.add(PracticeSeat(
          section: section,
          row: row.rowNumber,
          number: num,
          status: SeatStatus.occupied,
        ));
      }
    }

    final actual = min(availableCount, seats.length);
    final indices = List.generate(seats.length, (i) => i);
    indices.shuffle(_random);

    for (int i = 0; i < actual; i++) {
      seats[indices[i]].status = SeatStatus.available;
    }

    return seats;
  }

  void refreshSeats(List<PracticeSeat> seats) {
    for (final seat in seats) {
      if (seat.status != SeatStatus.selected) {
        seat.status = SeatStatus.occupied;
      }
    }

    final nonSelected =
        seats.where((s) => s.status != SeatStatus.selected).toList();
    if (nonSelected.isNotEmpty && _random.nextBool()) {
      final idx = _random.nextInt(nonSelected.length);
      nonSelected[idx].status = SeatStatus.available;
    }
  }
}
