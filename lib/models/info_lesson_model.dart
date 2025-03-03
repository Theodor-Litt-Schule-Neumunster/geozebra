
class InfoLesson {
  final String id;
  final String title;
  final List<ContentSection> sections;

  const InfoLesson({
    required this.id,
    required this.title,
    required this.sections,
  });
}

class ContentSection {
  final String title;
  final ContentType type;
  final String content;
  bool isExpanded;

  ContentSection({
    required this.title,
    required this.type,
    required this.content,
    this.isExpanded = false,
  });
}

enum ContentType {
  text,
  video,
  image,
}
