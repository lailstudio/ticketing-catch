import 'dart:math';

class CaptchaGenerator {
  static const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final Random _random;

  CaptchaGenerator({Random? random}) : _random = random ?? Random();

  String generate({int length = 6}) {
    return List.generate(
      length,
      (_) => _chars[_random.nextInt(_chars.length)],
    ).join();
  }

  bool validate(String input, String answer) {
    return input.trim().toUpperCase() == answer.toUpperCase();
  }
}
