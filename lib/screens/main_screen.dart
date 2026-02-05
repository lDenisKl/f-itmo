import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/league.dart';
import 'game_detail_screen.dart';
import 'filter_screen.dart';
import '../services/api_service.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Game>> _gamesFuture;
  late Future<List<League>> _leaguesFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _gamesFuture = _apiService.getGamesByInterval(
      from: DateTime.now(),
      to: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day + 2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FilterScreen()),
            );
          },
          child: Text('Нажми чтобы открыть фильтрацию'),
        ),
      ),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка. Проверьте соединение ${snapshot.error}'),
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
                  subtitle: Text('Играют: ${game.awayTeam} и ${game.homeTeam}'),
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
    );
  }
}
