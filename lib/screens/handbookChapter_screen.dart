import 'package:flutter/material.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/models/handbook_model.dart';
import 'package:geozebra_app/widgets/videoplayer_widget.dart';
import 'package:geozebra_app/widgets/fullscreenimage_widget.dart';

class HandbookChapterScreen extends StatelessWidget {
  final HandbookChapter chapter;

  const HandbookChapterScreen({
    Key? key,
    required this.chapter,
  }) : super(key: key);

  List<TextSpan> parseBoldText({
    required String text,
    required TextStyle normalStyle,
    required TextStyle boldStyle,
  }) {
    final spans = <TextSpan>[];

    var remainingText = text;
    var isBold = false;

    while (true) {
      final boldIndex = remainingText.indexOf('**');

      if (boldIndex < 0) {
        spans.add(
          TextSpan(
            text: remainingText,
            style: isBold ? boldStyle : normalStyle,
          ),
        );
        break;
      } else {
        final beforeBold = remainingText.substring(0, boldIndex);
        spans.add(
          TextSpan(
            text: beforeBold,
            style: isBold ? boldStyle : normalStyle,
          ),
        );

        remainingText = remainingText.substring(boldIndex + 2);
        isBold = !isBold;
      }
    }

    return spans;
  }

  List<Widget> parseContentToWidgets(String content, BuildContext context) {
    final lines = content.split('\n');
    final widgets = <Widget>[];

    final normalStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.3) ??
            const TextStyle();
    final boldStyle = normalStyle.copyWith(fontWeight: FontWeight.bold);

    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      final imageIndex = trimmedLine.indexOf('(image:');
      final videoIndex = trimmedLine.indexOf('(video:');

      final hasImage = imageIndex >= 0;
      final hasVideo = videoIndex >= 0;

      if (!hasImage && !hasVideo) {
        final spans = parseBoldText(
          text: trimmedLine,
          normalStyle: normalStyle,
          boldStyle: boldStyle,
        );

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(children: spans),
            ),
          ),
        );
        continue;
      }

      bool isImageFirst = false;
      int firstIndex = 0;

      if (hasImage && !hasVideo) {
        isImageFirst = true;
        firstIndex = imageIndex;
      } else if (!hasImage && hasVideo) {
        isImageFirst = false;
        firstIndex = videoIndex;
      } else {
        if (imageIndex < videoIndex) {
          isImageFirst = true;
          firstIndex = imageIndex;
        } else {
          isImageFirst = false;
          firstIndex = videoIndex;
        }
      }

      final beforeText = trimmedLine.substring(0, firstIndex).trim();
      if (beforeText.isNotEmpty) {
        final spans = parseBoldText(
          text: beforeText,
          normalStyle: normalStyle,
          boldStyle: boldStyle,
        );

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: RichText(
              text: TextSpan(children: spans),
            ),
          ),
        );
      }

      final startParenIndex = trimmedLine.indexOf('(', firstIndex);
      final colonIndex = trimmedLine.indexOf(':', startParenIndex);
      final endParenIndex = trimmedLine.indexOf(')', colonIndex);

      final path = trimmedLine.substring(colonIndex + 1, endParenIndex).trim();

      if (isImageFirst) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FullscreenImageViewer(
                    imagePath: path,
                  ),
                ));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  path,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 200,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: CustomVideoPlayer(videoUrl: path),
            ),
          ),
        );
      }

      final afterText = trimmedLine.substring(endParenIndex + 1).trim();
      if (afterText.isNotEmpty) {
        final spans = parseBoldText(
          text: afterText,
          normalStyle: normalStyle,
          boldStyle: boldStyle,
        );

        widgets.add(
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: RichText(
              text: TextSpan(children: spans),
            ),
          ),
        );
      }
    }

    return widgets;
  }

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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFDFCFB),
              Color(0xFFF3F3F3),
            ],
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                chapter.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 16,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 24),

              Divider(
                color: Theme.of(context).colorScheme.primary,
                thickness: 2,
              ),
              const SizedBox(height: 16),

              if (chapter.textSections.isNotEmpty)
                Text(
                  'Inhalt',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              const SizedBox(height: 16),

              ...chapter.textSections.asMap().entries.map(
                (entry) {
                  final index = entry.key + 1;
                  final section = entry.value;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.07),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        splashColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        collapsedIconColor:
                            Theme.of(context).colorScheme.primary,
                        iconColor: Theme.of(context).colorScheme.primary,
                        tilePadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        childrenPadding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        title: Text(
                          section.header.isNotEmpty
                              ? section.header
                              : 'Abschnitt $index',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        subtitle: section.subHeader.isNotEmpty
                            ? Text(
                                section.subHeader,
                                style: Theme.of(context).textTheme.bodyMedium,
                              )
                            : null,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: parseContentToWidgets(
                              section.content,
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ).toList(),
            ],
          ),
        ),
      ),
    );
  }
}
