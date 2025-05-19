import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/news_model.dart';

class NewsService {
  final String _baseUrl = 'https://newsapi.org/v2/top-headlines';
  final String _source = 'bbc-news';
  final String _apiKey = '015de596678245d7ae0971f2f34f6053';

  Future<NewsResponse> fetchNews() async {
    final Uri url = Uri.parse("$_baseUrl?sources=$_source&apiKey=$_apiKey");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return NewsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load news');
    }
  }
}
