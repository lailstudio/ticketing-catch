// ignore_for_file: prefer_initializing_formals
import 'dart:math';

class QueueSimulator {
  final int initialNumber;
  int currentNumber;
  int totalWaiting;
  final Random _random;

  QueueSimulator._({
    required this.initialNumber,
    required this.currentNumber,
    required this.totalWaiting,
    required Random random,
  }) : _random = random;

  factory QueueSimulator({int? initialNumber, int? totalWaiting}) {
    final random = Random();
    final initial = initialNumber ?? (300 + random.nextInt(1201));
    return QueueSimulator._(
      initialNumber: initial,
      currentNumber: initial,
      totalWaiting: totalWaiting ?? (initial + 500 + random.nextInt(5000)),
      random: random,
    );
  }

  bool get isComplete => currentNumber <= 0;
  bool get isNearlyDone => currentNumber < initialNumber * 0.2;
  double get progress => 1.0 - (currentNumber / initialNumber).clamp(0.0, 1.0);

  void tick() {
    if (isComplete) return;
    final decrement =
        max(1, initialNumber ~/ 25 + _random.nextInt(max(1, initialNumber ~/ 50)));
    currentNumber = max(0, currentNumber - decrement);
    if (totalWaiting > 0) {
      totalWaiting = max(0, totalWaiting - 50 - _random.nextInt(200));
    }
  }
}
