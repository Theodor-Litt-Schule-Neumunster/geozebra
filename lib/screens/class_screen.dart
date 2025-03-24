import 'package:flutter/material.dart';
import 'package:geozebra_app/models/class_model.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/services/lessons_service.dart';
import 'lesson_screen.dart';

class ClassScreen extends StatefulWidget {
  final ClassModel classModel;

  const ClassScreen({super.key, required this.classModel});

  @override
  _ClassScreenState createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  final LessonService _lessonService = LessonService();
  bool _isEnrolled = false;
  Map<String, int> _lessonProgress = {};

  @override
  void initState() {
    super.initState();
    _checkEnrollmentStatus();
    _loadLessonProgress();
  }

  Future<void> _checkEnrollmentStatus() async {
    final enrolledClasses = await _lessonService.getEnrolledClasses();
    setState(() {
      _isEnrolled = enrolledClasses.contains(widget.classModel.classId);
    });
  }

  Future<void> _loadLessonProgress() async {
    // Get progress for all lessons in this class
    final allProgress = await _lessonService.getAllLessonsProgress();

    Map<String, int> progress = {};
    // Filter progress entries that belong to this class
    for (var entry in allProgress) {
      if (entry['classId'] == widget.classModel.classId) {
        progress[entry['lessonId']] = entry['completionPercent'];
      }
    }

    setState(() {
      _lessonProgress = progress;
    });
  }

  Future<void> _enrollInClass() async {
    await _lessonService.enrollInClass(widget.classModel.classId);
    setState(() {
      _isEnrolled = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content:
              Text('Du bist "${widget.classModel.className}" beigetreten')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        title: widget.classModel.className,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'bookmark') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bookmarked')),
                );
              } else if (value == 'share') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Shared')),
                );
              } else if (value == 'leave') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Du hast "${widget.classModel.className}" verlassen.'),
                  ),
                );
                await _lessonService
                    .unenrollFromClass(widget.classModel.classId);
                setState(() {
                  _isEnrolled = false;
                });
              } else if (value == 'report') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Reported')),
                );
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'bookmark',
                  child: ListTile(
                    leading: Icon(Icons.bookmark_border),
                    title: Text('Favoritisieren'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'share',
                  child: ListTile(
                    leading: Icon(Icons.share),
                    title: Text('Teilen'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'leave',
                  child: ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('Verlassen'),
                  ),
                ),
                const PopupMenuItem<String>(
                  value: 'report',
                  child: ListTile(
                    leading: Icon(Icons.report),
                    title: Text('Melden'),
                  ),
                ),
              ];
            },
            icon: const Icon(Icons.more_vert),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star,
                        size: 20, color: Colors.orangeAccent),
                    const SizedBox(width: 6),
                    Text(
                      "0",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.emoji_events,
                        size: 20, color: Colors.orangeAccent),
                    const SizedBox(width: 6),
                    Text(
                      "0",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                Row(
                  children: const [],
                ),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1.0,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.classModel.classShortDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),

                if (!_isEnrolled)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _enrollInClass,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        // backgroundColor: Theme.of(context).colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Kurs beitreten",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      "Du bist diesem Kurs bereits beigetreten.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: Colors.green),
                    ),
                  ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: widget.classModel.lessons.length,
              itemBuilder: (context, index) {
                final lesson = widget.classModel.lessons[index];
                // Get progress for this lesson if available
                final progress = _lessonProgress[lesson.lessonId] ?? 0;

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
                      lesson.lessonTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(lesson.shortDescription),
                        if (progress > 0)
                          LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                          ),
                      ],
                    ),
                    trailing: progress > 0
                        ? Text('$progress%')
                        : null,
                    onTap: () {
                      if (_isEnrolled) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LessonScreen(
                              lesson: lesson,
                              classId: widget.classModel.classId,
                            ),
                          ),
                        ).then((_) {
                          // Reload progress when we return from lesson screen
                          _loadLessonProgress();
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Du musst diesem Kurs erst beitreten, bevor du Lektionen starten kannst."),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
