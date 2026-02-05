import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/league.dart';
import 'game_detail_screen.dart';
import '../services/api_service.dart';

class FilterScreen extends StatefulWidget {
  int leagueid = 0;
  int offset = 30;

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  late Future<List<Game>> _gamesFuture = refresh();
  late Future<List<League>> _leaguesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _gamesFuture = _apiService.getGamesByIntervalAndLeague(
      from: DateTime.now(),
      to: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + widget.offset,
      ),
      leagueId: widget.leagueid,
    );
  }

  Future<List<Game>> refresh() {
    return _apiService.getGamesByIntervalAndLeague(
      from: DateTime.now(),
      to: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + widget.offset,
      ),
      leagueId: widget.leagueid,
    );
  }

  _changeId(String text) {
    setState(() => widget.leagueid = int.parse(text));
  }

  _changeOff(String text) {
    setState(() => widget.offset = int.parse(text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ближайшие игры')),
      body: Column(
        children: [
          Text("id лиги введите", style: TextStyle(fontSize: 22)),
          TextField(onChanged: _changeId),
          Text(
            "введите сколько дней вперед смотреть",
            style: TextStyle(fontSize: 22),
          ),
          TextField(onChanged: _changeOff),

          FutureBuilder<List<Game>>(
            future: _gamesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Column(
                  children: [
                    Icon(Icons.error),
                    Text('Failed to fetch data.'),
                    GestureDetector(
                      child: Text('RETRY'),
                      onTap: () {
                        setState() {
                          _gamesFuture =
                              refresh(); //<== (3) that will trigger the UI to rebuild an run the Future again
                        }
                      },
                    ),
                  ],
                );
              } else if (snapshot.hasData) {
                final games = snapshot.data!;
                return ListView.builder(
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    //print(game.id);
                    return ListTile(
                      title: Text(game.date.toString()),
                      subtitle: Text(
                        'Играют: ${game.awayTeam} и ${game.homeTeam}',
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                GameDetailScreen(gameId: game.id, game: game),
                          ),
                        );
                      },
                    );
                  },
                );
              } else {
                return Center(child: Text('Нет данных'));
              }
            },
          ),
        ],
      ),
    );
  }
}
