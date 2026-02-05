class League {
  final int id;
  final String name;
  final String country;

  League({required this.id, required this.name, required this.country});

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] ?? 0,
      name: json['name'] ?? '-',
      country: json['county'] ?? '-',
    );
  }
}
