import 'dart:math';

enum BookingResult { success, seatTaken }

class BookingSimulator {
  final Random _random;

  BookingSimulator({Random? random}) : _random = random ?? Random();

  static double contestRateFor(Duration elapsed) {
    final ms = elapsed.inMilliseconds;
    if (ms < 1000) return 0.0;
    if (ms < 2000) return 0.10;
    if (ms < 4000) return 0.20;
    if (ms < 6000) return 0.30;
    if (ms < 8000) return 0.40;
    return 0.50;
  }

  BookingResult attempt(Duration elapsed) {
    final rate = contestRateFor(elapsed);
    if (rate == 0.0) return BookingResult.success;
    return _random.nextDouble() < rate
        ? BookingResult.seatTaken
        : BookingResult.success;
  }
}
