import 'package:flutter/material.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/models/handbook_model.dart';
import 'package:geozebra_app/screens/handbookChapter_screen.dart';

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
      _handbookData = await HandbookData.loadFromAsset(
        'assets/classes/test_handbook.json',
      );
    } catch (e) {
      debugPrint('Error loading handbook data: $e');
    } finally {
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
        automaticallyImplyLeading: true,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFDFCFB),
              Color(0xFFF3F3F3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _handbookData == null
                ? const Center(
                    child: Text('Fehler beim Laden des Handbuchs'),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _handbookData!.handbookDescription,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),

                        Divider(
                          color: Theme.of(context).colorScheme.primary,
                          thickness: 2,
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Kapitel',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),

                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _handbookData!.chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = _handbookData!.chapters[index];
                            return GestureDetector(
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
                              child: Container(
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
                                child: ListTile(
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 16,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.primary,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
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
                                  trailing: const Icon(
                                    Icons.arrow_forward_ios,
                                    size: 18,
                                  ),
                                ),
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
