import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/league.dart';
import '../models/game.dart';
import '../models/game_detail.dart';
import 'package:intl/intl.dart';

class ApiService {
  static const String _baseUrl = 'https://api.sstats.net';

  Future<List<League>> getLeagues() async {
    final response = await http.get(Uri.parse('$_baseUrl/Leagues'));

    try {
      final data = json.decode(response.body);
      print(data);
      return (data['data'] as List)
          .map((json) => League.fromJson(json))
          .toList();
    } catch (e) {
      print("Возникло исключение: $e");
      return List.empty();
    }
  }

  Future<List<Game>> getGames({
    required int leagueId,
    required int year,
  }) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/Games/list').replace(
        queryParameters: {
          'leagueid': leagueId.toString(),
          'year': year.toString(),
        },
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        return (data['data'] as List)
            .map((json) => Game.fromJson(json))
            .toList();
      }
    }
    throw Exception(
      'Не получилось получить список лиг. Проверьте соединение к сети',
    );
  }

  Future<List<Game>> getGamesFromLeaguesList({
    required Future<List<League>> leaguesFuture,
    required int year,
  }) async {
    List<Game> Result = new List.empty();
    List leagues = await leaguesFuture;
    for (var i = 0; i < leagues.length; i++) {
      final response = await http.get(
        Uri.parse('$_baseUrl/Games/list').replace(
          queryParameters: {
            'leagueid': leagues[i].id.toString(),
            'year': year.toString(),
          },
        ),
      );

      final data = json.decode(response.body);
      if (data['status'] == 'OK') {
        Result += (data['data'] as List)
            .map((json) => Game.fromJson(json))
            .toList();
      }
    }
    return Result;
  }

  Future<GameDetail> getGameDetail({required int gameId}) async {
    final response = await http.get(Uri.parse('$_baseUrl/Games/${gameId}'));

    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      return GameDetail.fromJson(data['data']);
    } else {
      return GameDetail(
        id: 0,
        date: DateTime.now(),
        league: '-',
        status: '-',
        country: '-',
      );
    }
  }

  Future<List<Game>> getGamesByIntervalAndLeague({
    required DateTime from,
    required DateTime to,
    required int leagueId,
  }) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFrom = formatter.format(from);
    final String formattedTo = formatter.format(to);

    final response = await http.get(
      Uri.parse('$_baseUrl/Games/list').replace(
        queryParameters: {
          'from': formattedFrom,
          'to': formattedTo,
          'leagueid': leagueId,
        },
      ),
    );

    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      return (data['data'] as List).map((json) => Game.fromJson(json)).toList();
    } else {
      return List.empty();
    }
  }

  Future<List<Game>> getGamesByInterval({
    required DateTime from,
    required DateTime to,
  }) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedFrom = formatter.format(from);
    final String formattedTo = formatter.format(to);

    final response = await http.get(
      Uri.parse(
        '$_baseUrl/Games/list',
      ).replace(queryParameters: {'from': formattedFrom, 'to': formattedTo}),
    );

    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      return (data['data'] as List).map((json) => Game.fromJson(json)).toList();
    } else {
      return List.empty();
    }
  }
}
