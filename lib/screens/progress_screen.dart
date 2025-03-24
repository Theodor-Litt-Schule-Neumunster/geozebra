import 'package:flutter/material.dart';
import 'package:geozebra_app/services/lessons_service.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:geozebra_app/providers/lessons_provider.dart';
import 'package:geozebra_app/models/class_model.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final LessonService _lessonService = LessonService();
  final lessonsProvider = LessonsProvider();
  
  List<Map<String, dynamic>> progressData = [];
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadProgressData();
  }
  
  Future<void> _loadProgressData() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      // Load all lesson progress from database
      final allProgress = await _lessonService.getAllLessonsProgress();
      
      // Get all class files to lookup class and lesson names
      List<String> classFiles = lessonsProvider.getAllClassFiles();
      Map<String, ClassModel> classesMap = {};
      
      // Load all class data
      for (String file in classFiles) {
        try {
          String jsonString = await rootBundle.loadString(file);
          Map<String, dynamic> jsonData = jsonDecode(jsonString);
          ClassModel classModel = ClassModel.fromJson(jsonData);
          classesMap[classModel.classId] = classModel;
        } catch (e) {
          debugPrint("Error loading file $file: $e");
        }
      }
      
      // Map database progress to rich progress data with names
      List<Map<String, dynamic>> richProgress = [];
      
      for (var progress in allProgress) {
        String classId = progress['classId'];
        String lessonId = progress['lessonId'];
        int completionPercent = progress['completionPercent'];
        
        // Find the class and lesson
        if (classesMap.containsKey(classId)) {
          final classModel = classesMap[classId]!;
          
          // Find the lesson in this class
          final lesson = classModel.lessons.firstWhere(
            (l) => l.lessonId == lessonId,
            orElse: () => Lesson(
              lessonId: lessonId,
              lessonTitle: 'Unknown Lesson',
              description: 'No description available',
              shortDescription: 'No short description available',
              showRechner: false,
              tasks: [],
              textSections: [],
            ),
          );
          
          richProgress.add({
            'classId': classId,
            'className': classModel.className,
            'lessonId': lessonId,
            'lessonTitle': lesson.lessonTitle,
            'completionPercent': completionPercent,
            'lastAccessed': progress['lastAccessed'],
          });
        }
      }
      
      // Sort by last accessed (most recent first)
      richProgress.sort((a, b) {
        return (b['lastAccessed'] ?? '').compareTo(a['lastAccessed'] ?? '');
      });
      
      setState(() {
        progressData = richProgress;
        isLoading = false;
      });
      
    } catch (e) {
      print('Error loading progress data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mein Fortschritt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadProgressData,
          ),
        ],
      ),
      body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : progressData.isEmpty
          ? const Center(child: Text('Noch kein Fortschritt vorhanden'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: progressData.length,
              itemBuilder: (context, index) {
                final progress = progressData[index];
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          progress['className'] ?? 'Unknown Class',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          progress['lessonTitle'] ?? 'Unknown Lesson',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress['completionPercent'] / 100,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${progress['completionPercent']}% abgeschlossen'),
                            Text(
                              _formatDate(progress['lastAccessed']),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
  
  String _formatDate(String? isoDate) {
    if (isoDate == null) return '';
    
    try {
      final date = DateTime.parse(isoDate);
      return '${date.day}.${date.month}.${date.year}';
    } catch (e) {
      return '';
    }
  }
}
