import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/info_lesson_model.dart';

class InfoLessonService {
  Future<InfoLesson> loadInfoLesson(String lessonId) async {
    // Load the lesson data from assets
    final String jsonData = await rootBundle.loadString('assets/classes/$lessonId.json');
    final Map<String, dynamic> data = json.decode(jsonData);
    
    return _parseInfoLesson(data);
  }
  
  InfoLesson _parseInfoLesson(Map<String, dynamic> data) {
    List<ContentSection> sections = (data['sections'] as List)
        .map((section) => ContentSection(
              title: section['title'],
              type: _parseContentType(section['type']),
              content: section['content'],
            ))
        .toList();
            
    return InfoLesson(
      id: data['id'],
      title: data['title'],
      sections: sections,
    );
  }
  
  ContentType _parseContentType(String type) {
    switch (type) {
      case 'text':
        return ContentType.text;
      case 'video':
        return ContentType.video;
      case 'image':
        return ContentType.image;
      default:
        return ContentType.text;
    }
  }
}
