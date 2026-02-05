class Game {
  final int id;
  final DateTime date;
  final String homeTeam;
  final String awayTeam;

  Game({
    required this.id,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    final date = json['date'];
    final nDate = date.substring(0, 19);
    DateTime d = DateTime.parse(nDate);
    //print(json['id']);
    return Game(
      id: json['id'],
      date: d,
      homeTeam: json['homeTeam']['name'] ?? '-',
      awayTeam: json['awayTeam']['name'] ?? '-',
    );
  }
}
