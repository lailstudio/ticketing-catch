import 'seat_status.dart';

class PracticeSeat {
  final String section;
  final int row;
  final int number;
  SeatStatus status;

  PracticeSeat({
    required this.section,
    required this.row,
    required this.number,
    this.status = SeatStatus.available,
  });
}
