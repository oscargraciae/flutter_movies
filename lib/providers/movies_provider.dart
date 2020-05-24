import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import 'package:movies/models/movie.dart';

class MoviesProvider {
  String _apiKey = '2a40f89c42392c08602b52c39d974f5b';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _popularPage = 0;
  bool _isLoading = false;

  List<Movie> _popularList = new List();

  final _popularStreamController = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularSink => _popularStreamController.sink.add;

  Stream<List<Movie>> get popularStream => _popularStreamController.stream;

  void disposeStreams() {
    _popularStreamController?.close();
  }

  Future<List<Movie>> _request(Uri url) async {
    final response = await http.get(url);
    final decodeData = json.decode(response.body);
    final data = new Movies.fromJsonList(decodeData['results']);
    return data.movies;
  }

  Uri getUrl (String url, page) {
    return Uri.https(_url, url, {
      'api_key': _apiKey,
      'language': _language,
      'page': page.toString(),
    });
  }

  Future<List<Movie>> getNowPlaying() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _language,
    });

    return await _request(url);
  }

  Future<List<Movie>> getPopularMovies() async {
    if (_isLoading) return [];

    _isLoading = true;

    _popularPage++;
    
    final url = getUrl('3/movie/popular', _popularPage);
    final response = await _request(url);
    
    _popularList.addAll(response);
    popularSink(_popularList);

    _isLoading = false;
    return response;
  }

}