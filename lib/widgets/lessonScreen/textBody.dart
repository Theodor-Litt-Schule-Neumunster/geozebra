import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:geozebra_app/models/class_model.dart';

class TextBody extends StatelessWidget {
  final List<TextSection> textSections;
  final ScrollController scrollController;
  final List<GlobalKey> sectionKeys;

  const TextBody({
    Key? key,
    required this.textSections,
    required this.scrollController,
    required this.sectionKeys,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: scrollController,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < textSections.length; i++) ...[
            Container(
              key: sectionKeys[i],
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    textSections[i].header,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    textSections[i].subHeader,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  Html(data: textSections[i].content),
                  const SizedBox(height: 25),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
