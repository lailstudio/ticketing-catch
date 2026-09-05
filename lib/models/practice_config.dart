enum PracticeMode { full, focused, quick }

class PracticeConfig {
  final int availableSeatCount;
  final double contestRate;
  final PracticeMode mode;

  const PracticeConfig({
    this.availableSeatCount = 2,
    this.contestRate = 0.65,
    this.mode = PracticeMode.full,
  });
}
