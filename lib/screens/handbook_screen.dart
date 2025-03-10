import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/screens/handbook_chapter_screen.dart';

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
      header: json['header'],
      subHeader: json['subHeader'],
      content: json['content'],
    );
  }
}

class HandbookScreen extends StatefulWidget {
  const HandbookScreen({Key? key}) : super(key: key);

  @override
  State<HandbookScreen> createState() => _HandbookScreenState();
}

class _HandbookScreenState extends State<HandbookScreen> {
  HandbookData? _handbookData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHandbookData();
  }

  Future<void> _loadHandbookData() async {
    try {
      final String jsonString =
          await rootBundle.loadString('assets/classes/handbook_geogebra.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      setState(() {
        _handbookData = HandbookData.fromJson(jsonData);
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading handbook data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: _handbookData?.handbookTitle ?? "GeoGebra-Handbuch",
        showLeading: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _handbookData == null
              ? const Center(child: Text('Fehler beim Laden des Handbuchs'))
              : Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _handbookData!.handbookDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Kapitel',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _handbookData!.chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = _handbookData!.chapters[index];
                            return Card(
                              elevation: 2,
                              margin: const EdgeInsets.only(bottom: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 16),
                                title: Text(
                                  chapter.chapterTitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                subtitle: Text(
                                  chapter.shortDescription,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios,
                                    size: 18),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HandbookChapterScreen(
                                        chapter: chapter,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}