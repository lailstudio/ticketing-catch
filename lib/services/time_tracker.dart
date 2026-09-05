class TimeTracker {
  DateTime? practiceStartedAt;
  DateTime? queueCompletedAt;
  DateTime? captchaEnteredAt;
  DateTime? captchaCompletedAt;
  DateTime? sectionEnteredAt;
  DateTime? seatEnteredAt;
  DateTime? firstSeatEnteredAt;
  DateTime? bookingCompletedAt;
  DateTime? firstSeatClickedAt;

  int bookingAttempts = 0;
  int seatTakenCount = 0;

  void markPracticeStarted() => practiceStartedAt = DateTime.now();
  void markQueueCompleted() => queueCompletedAt = DateTime.now();
  void markCaptchaEntered() => captchaEnteredAt = DateTime.now();
  void markCaptchaCompleted() => captchaCompletedAt = DateTime.now();
  void markSectionEntered() => sectionEnteredAt = DateTime.now();

  void markSeatEntered() {
    seatEnteredAt = DateTime.now();
    firstSeatEnteredAt ??= seatEnteredAt;
  }

  void markBookingCompleted() => bookingCompletedAt = DateTime.now();
  void markFirstSeatClicked() => firstSeatClickedAt ??= DateTime.now();

  void recordBookingSuccess() => bookingAttempts++;

  void recordSeatTaken() {
    bookingAttempts++;
    seatTakenCount++;
  }

  // practiceStartedAt → bookingCompletedAt
  Duration? get totalDuration {
    if (practiceStartedAt == null || bookingCompletedAt == null) return null;
    return bookingCompletedAt!.difference(practiceStartedAt!);
  }

  // practiceStartedAt → queueCompletedAt
  Duration? get queueDuration {
    if (practiceStartedAt == null || queueCompletedAt == null) return null;
    return queueCompletedAt!.difference(practiceStartedAt!);
  }

  // captchaEnteredAt → captchaCompletedAt
  Duration? get captchaDuration {
    if (captchaEnteredAt == null || captchaCompletedAt == null) return null;
    return captchaCompletedAt!.difference(captchaEnteredAt!);
  }

  // sectionEnteredAt → firstSeatEnteredAt
  Duration? get seatSelectionDuration {
    if (sectionEnteredAt == null || firstSeatEnteredAt == null) return null;
    return firstSeatEnteredAt!.difference(sectionEnteredAt!);
  }

  // firstSeatEnteredAt → firstSeatClickedAt
  Duration? get firstClickDuration {
    if (firstSeatEnteredAt == null || firstSeatClickedAt == null) return null;
    return firstSeatClickedAt!.difference(firstSeatEnteredAt!);
  }

  // firstSeatClickedAt → bookingCompletedAt
  Duration? get seatAcquisitionDuration {
    if (firstSeatClickedAt == null || bookingCompletedAt == null) return null;
    return bookingCompletedAt!.difference(firstSeatClickedAt!);
  }
}
