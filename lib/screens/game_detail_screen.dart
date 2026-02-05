import 'package:flutter/material.dart';
import '../models/game.dart';
import '../models/game_detail.dart';
import '../services/api_service.dart';

class GameDetailScreen extends StatefulWidget {
  final int gameId;
  final Game game;

  GameDetailScreen({required this.gameId, required this.game});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late Future<GameDetail> _gameDetailFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _gameDetailFuture = _apiService.getGameDetail(gameId: widget.gameId);
  }

  Widget _buildInfoTab(GameDetail detail) {
    return ListView(
      children: [
        ListTile(
          title: Text(detail.date.toString()),
          subtitle: Text(detail.country),
        ),
        ListTile(
          title: Text(detail.id.toString()),
          subtitle: Text(detail.status),
        ),
        ListTile(title: Text(detail.league)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.game.date.toString())),
        body: TabBarView(
          children: [
            FutureBuilder<GameDetail>(
              future: _gameDetailFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Ошибка. Проверьте соединение ${snapshot.error}',
                    ),
                  );
                } else if (snapshot.hasData) {
                  return _buildInfoTab(snapshot.data!);
                }
                return Center(child: Text('Нет данных. Проверьте соединение'));
              },
            ),
          ],
        ),
      ),
    );
  }
}
