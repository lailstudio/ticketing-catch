class Venue {
  final String id;
  final String name;
  final List<Section> sections;

  const Venue({
    required this.id,
    required this.name,
    required this.sections,
  });
}

class Section {
  final String id;
  final String name;
  final int? floor;
  final List<Seat> seats;

  const Section({
    required this.id,
    required this.name,
    this.floor,
    required this.seats,
  });
}

class Seat {
  final String id;
  final int row;
  final int number;
  final double x;
  final double y;

  const Seat({
    required this.id,
    required this.row,
    required this.number,
    required this.x,
    required this.y,
  });
}
