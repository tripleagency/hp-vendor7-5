/// Working time entity for a single day
class WorkingTimeEntity {
  final String day; // e.g. "saturday"
  final String from; // e.g. "08:00 AM"
  final String to; // e.g. "06:00 PM"

  const WorkingTimeEntity({
    required this.day,
    required this.from,
    required this.to,
  });
}
