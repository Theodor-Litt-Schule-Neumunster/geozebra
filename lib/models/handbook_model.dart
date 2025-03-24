import 'dart:convert';
import 'package:flutter/services.dart';

class HandbookData {
  final String handbookId;
  final String handbookTitle;
  final String handbookDescription;
  final String handbookShortDescription;
  final List<HandbookChapter> chapters;

  HandbookData({
    required this.handbookId,
    required this.handbookTitle,
    required this.handbookDescription,
    required this.handbookShortDescription,
    required this.chapters,
  });

  factory HandbookData.fromJson(Map<String, dynamic> json) {
    return HandbookData(
      handbookId: json['handbookId'],
      handbookTitle: json['handbookTitle'],
      handbookDescription: json['handbookDescription'],
      handbookShortDescription: json['handbookShortDescription'],
      chapters: (json['chapters'] as List)
          .map((chapter) => HandbookChapter.fromJson(chapter))
          .toList(),
    );
  }

  static Future<HandbookData> loadFromAsset(String assetPath) async {
    final jsonString = await rootBundle.loadString(assetPath);
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    return HandbookData.fromJson(jsonData);
  }
}

class HandbookChapter {
  final String chapterId;
  final String chapterTitle;
  final String description;
  final String shortDescription;
  final List<TextSection> textSections;

  HandbookChapter({
    required this.chapterId,
    required this.chapterTitle,
    required this.description,
    required this.shortDescription,
    required this.textSections,
  });

  factory HandbookChapter.fromJson(Map<String, dynamic> json) {
    return HandbookChapter(
      chapterId: json['chapterId'],
      chapterTitle: json['chapterTitle'],
      description: json['description'],
      shortDescription: json['shortDescription'],
      textSections: (json['textSections'] as List)
          .map((section) => TextSection.fromJson(section))
          .toList(),
    );
  }
}

class TextSection {
  final String header;
  final String subHeader;
  final String content;

  TextSection({
    required this.header,
    required this.subHeader,
    required this.content,
  });

  factory TextSection.fromJson(Map<String, dynamic> json) {
    return TextSection(
      header: json['header'] ?? '',
      subHeader: json['subHeader'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
