import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/screens/handbook_screen.dart';

class HandbookChapterScreen extends StatelessWidget {
  final HandbookChapter chapter;

  const HandbookChapterScreen({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: chapter.chapterTitle,
        automaticallyImplyLeading: true,
      ),
      body: Container(
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
                chapter.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              ...chapter.textSections.map((section) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    if (section.header.isNotEmpty) Text(
                      section.header,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (section.subHeader.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        section.subHeader,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                    const SizedBox(height: 12),
                    if (section.content.isNotEmpty) Html(
                      data: section.content,
                      style: {
                        "body": Style(
                          margin: Margins.all(0),
                          padding: HtmlPaddings.all(0),
                          fontSize: FontSize(16),
                          fontFamily: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.fontFamily,
                        ),
                        "li": Style(
                          margin: Margins.only(bottom: 8),
                        ),
                      },
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}