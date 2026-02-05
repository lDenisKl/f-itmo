class GameDetail {
  final int id;
  final DateTime date;
  final String league;
  final String status;
  final String country;

  GameDetail({
    required this.id,
    required this.date,
    required this.league,
    required this.status,
    required this.country,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    final date = json['game']['date'];
    final nDate = date.substring(0, 19);
    DateTime d = DateTime.parse(nDate);
    return GameDetail(
      id: json['game']['id'] ?? 0,
      date: d,
      status: json['game']['statusName'] ?? '-',
      league: json['game']['season']['league']['name'] ?? '-',
      country: json['game']['season']['league']['country']['name'] ?? '-',
    );
  }
}
