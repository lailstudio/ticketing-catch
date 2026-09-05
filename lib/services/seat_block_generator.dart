import 'dart:math';

import '../models/venue.dart';

enum SeatShape {
  rectangle,
  trapezoid,
  parallelogram,
  oneSideTaper,
  fan,
  curve,
  arc,
  oneSideCurve,
  centerSoftArc,
  innerBentUpper,
  innerBentLower,
}

enum SeatAlignment { leftFixed, rightFixed, centered }

enum SlantDirection { none, left, right }

enum SlantAmount { none, small, medium, large }

class SectionSeatConfig {
  final SeatShape shape;
  final int rows;
  final int frontSeats;
  final int rearSeats;
  final SeatAlignment alignment;
  final SlantDirection slant;
  final SlantAmount slantAmount;
  final int targetSeats;

  const SectionSeatConfig({
    required this.shape,
    required this.rows,
    required this.frontSeats,
    required this.rearSeats,
    required this.alignment,
    this.slant = SlantDirection.none,
    this.slantAmount = SlantAmount.none,
    this.targetSeats = 0,
  });
}

List<SectionRowDef> generateBlockRows(SectionSeatConfig config) {
  final rowCount = config.rows;

  final List<int> counts;
  switch (config.shape) {
    case SeatShape.oneSideCurve:
      counts = _easedInterpolation(
          rowCount, config.frontSeats, config.rearSeats, 2.0);
    case SeatShape.centerSoftArc:
      counts = _easedInterpolation(
          rowCount, config.frontSeats, config.rearSeats, 3.0);
    case SeatShape.innerBentUpper:
    case SeatShape.innerBentLower:
      counts =
          _bentInterpolation(rowCount, config.frontSeats, config.rearSeats);
    default:
      counts =
          steppedInterpolation(rowCount, config.frontSeats, config.rearSeats);
  }

  final maxCount = counts.reduce(max);

  final slantTotal = _slantPixels(config.slantAmount);
  final slantOffsets = _calcSlantOffsets(rowCount, config.slant, slantTotal);

  return List.generate(rowCount, (i) {
    final baseOffset = _alignmentOffset(config.alignment, maxCount, counts[i]);
    return SectionRowDef(
      rowNumber: i + 1,
      seatCount: counts[i],
      startOffset: max(0, baseOffset + slantOffsets[i]),
    );
  });
}

int _slantPixels(SlantAmount amount) {
  switch (amount) {
    case SlantAmount.none:
      return 0;
    case SlantAmount.small:
      return 2;
    case SlantAmount.medium:
      return 3;
    case SlantAmount.large:
      return 5;
  }
}

List<int> _calcSlantOffsets(
    int rowCount, SlantDirection direction, int total) {
  if (total == 0 || direction == SlantDirection.none) {
    return List.filled(rowCount, 0);
  }
  switch (direction) {
    case SlantDirection.left:
      return steppedInterpolation(rowCount, total, 0);
    case SlantDirection.right:
      return steppedInterpolation(rowCount, 0, total);
    default:
      return List.filled(rowCount, 0);
  }
}

int _alignmentOffset(
    SeatAlignment alignment, int maxCount, int seatCount) {
  switch (alignment) {
    case SeatAlignment.leftFixed:
      return 0;
    case SeatAlignment.rightFixed:
      return maxCount - seatCount;
    case SeatAlignment.centered:
      return ((maxCount - seatCount) / 2).round();
  }
}

List<int> _easedInterpolation(int count, int start, int end, double power) {
  if (count <= 1) return [start];
  if (start == end) return List.filled(count, start);

  final diff = (end - start).toDouble();
  final raw = List<int>.generate(count, (i) {
    final t = i / (count - 1);
    return (start + diff * pow(t, power)).round();
  });

  for (int i = raw.length - 1; i > 0; i--) {
    final alone = (raw[i] != raw[i - 1]) &&
        (i == raw.length - 1 || raw[i] != raw[i + 1]);
    if (alone) {
      raw[i] = raw[i - 1];
    }
  }

  return raw;
}

List<int> _bentInterpolation(int count, int start, int end) {
  if (count <= 1) return [start];
  if (start == end) return List.filled(count, start);

  final range = (end - start).abs();
  if (range <= 2) return steppedInterpolation(count, start, end);

  final bendPoint = (count * 0.4).round().clamp(2, count - 2);
  final midOffset = (range * 0.25).round().clamp(1, range - 1);
  final midValue = start + (end > start ? midOffset : -midOffset);

  final phase1 = steppedInterpolation(bendPoint, start, midValue);
  final phase2 = steppedInterpolation(count - bendPoint, midValue, end);

  return [...phase1, ...phase2];
}

List<int> steppedInterpolation(int count, int start, int end) {
  if (count <= 1) return [start];
  if (start == end) return List.filled(count, start);

  final direction = end > start ? 1 : -1;
  var range = (end - start).abs();
  final maxRange = count ~/ 2;
  if (range > maxRange) range = maxRange;

  final numValues = range + 1;
  final baseSize = count ~/ numValues;
  final remainder = count % numValues;

  final result = <int>[];
  for (int v = 0; v < numValues; v++) {
    final value = start + v * direction;
    final groupSize = baseSize + (v < remainder ? 1 : 0);
    result.addAll(List.filled(groupSize, value));
  }

  return result;
}
