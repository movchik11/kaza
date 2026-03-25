import 'dart:convert';
import 'package:flutter/services.dart';

class LibraryArticle {
  final String id;
  final String title;
  final String content;
  final String category;
  final String? source;

  LibraryArticle({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.source,
  });

  factory LibraryArticle.fromJson(Map<String, dynamic> json) {
    return LibraryArticle(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      category: json['category'],
      source: json['source'],
    );
  }
}

class Supplication {
  final String id;
  final String title;
  final String arabic;
  final String phonetic;
  final String translation;
  final String category;
  final String? audioPath;

  Supplication({
    required this.id,
    required this.title,
    required this.arabic,
    required this.phonetic,
    required this.translation,
    required this.category,
    this.audioPath,
  });

  factory Supplication.fromJson(Map<String, dynamic> json) {
    return Supplication(
      id: json['id'],
      title: json['title'],
      arabic: json['arabic'],
      phonetic: json['phonetic'],
      translation: json['translation'],
      category: json['category'],
      audioPath: json['audioPath'],
    );
  }
}

class ContentService {
  static List<LibraryArticle>? _articles;
  static List<Supplication>? _supplications;
  static List<Map<String, String>>? _dailyVerses;

  static Future<void> init() async {
    await Future.wait([
      _loadArticles(),
      _loadSupplications(),
      _loadDailyVerses(),
    ]);
  }

  static Future<void> _loadArticles() async {
    final String response = await rootBundle.loadString(
      'assets/data/articles.json',
    );
    final List<dynamic> data = json.decode(response);
    _articles = data.map((json) => LibraryArticle.fromJson(json)).toList();
  }

  static Future<void> _loadSupplications() async {
    final String response = await rootBundle.loadString(
      'assets/data/duas.json',
    );
    final List<dynamic> data = json.decode(response);
    _supplications = data.map((json) => Supplication.fromJson(json)).toList();
  }

  static Future<void> _loadDailyVerses() async {
    final String response = await rootBundle.loadString(
      'assets/data/verses.json',
    );
    final List<dynamic> data = json.decode(response);
    _dailyVerses = data.map((item) => Map<String, String>.from(item)).toList();
  }

  static List<LibraryArticle> getArticles() => _articles ?? [];

  static List<Supplication> getSupplications() => _supplications ?? [];

  static Map<String, String> getDailyVerse() {
    if (_dailyVerses == null || _dailyVerses!.isEmpty) {
      return {
        "text": "Indeed, prayer prohibits immorality and wrongdoing.",
        "source": "Quran 29:45",
      };
    }
    final now = DateTime.now();
    final index = (now.year + now.month + now.day) % _dailyVerses!.length;
    return _dailyVerses![index];
  }

  static List<LibraryArticle> getArticlesByCategory(String category) {
    return (_articles ?? []).where((a) => a.category == category).toList();
  }

  static List<Supplication> getSupplicationsByCategory(String category) {
    return (_supplications ?? []).where((s) => s.category == category).toList();
  }
}
