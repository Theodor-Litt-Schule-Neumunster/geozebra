import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geozebra_app/services/settings_service.dart';
import 'package:flutter/services.dart';
import 'package:geozebra_app/widgets/bottombar_widget.dart';
import 'package:geozebra_app/cards/home_card.dart';
import 'search_screen.dart';
import 'notification_screen.dart';
import 'rechner_screen.dart';
import 'package:geozebra_app/services/lessons_service.dart';
import 'package:geozebra_app/screens/class_screen.dart';
import 'package:geozebra_app/models/class_model.dart';
import 'package:geozebra_app/providers/lessons_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LessonService _lessonService = LessonService();
  final lessonsProvider = LessonsProvider();

  List<ClassModel> enrolledClasses = [];
  List<ClassModel> bookmarkedClasses = [];
  List<String> enrolledClassesString = [];
  List<String> classFiles = [];
  String _savedName = "";

  @override
  void initState() {
    super.initState();
    _loadUserName();
    _checkEnrolledClasses();
    _checkBookmarkedClasses();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkEnrolledClasses();
    _checkBookmarkedClasses();
  }

  Future<void> _loadUserName() async {
    _savedName = await SettingsService().getValue<String>("displayname", "");
    setState(() {});
    // return _savedName;
  }

  Future<void> _checkBookmarkedClasses() async {
    List<String> bookmarkedClassesString =
        await _lessonService.getBookmarkedClasses();
    List<ClassModel> loadedClasses = [];

    for (String file in classFiles) {
      try {
        String jsonString = await rootBundle.loadString(file);
        Map<String, dynamic> jsonData = jsonDecode(jsonString);

        if (jsonData['lessons'] != null) {
          for (int i = 0; i < jsonData['lessons'].length; i++) {
            var lesson = jsonData['lessons'][i];
            lesson['lessonId'] = 'lesson_$i';
            if (lesson['tasks'] != null) {
              for (int j = 0; j < lesson['tasks'].length; j++) {
                lesson['tasks'][j]['taskId'] = 'task_$j';
              }
            }
          }
        }

        ClassModel classModel = ClassModel.fromJson(jsonData);
        if (bookmarkedClassesString.contains(classModel.classId)) {
          loadedClasses.add(classModel);
        }
      } catch (e) {
        debugPrint("Error loading file $file: $e");
      }
    }

    setState(() {
      bookmarkedClasses = loadedClasses;
    });
  }

  Future<void> _checkEnrolledClasses() async {
    enrolledClassesString = await _lessonService.getEnrolledClasses();

    classFiles = lessonsProvider.getAllClassFiles();
    List<ClassModel> loadedClasses = [];

    for (String file in classFiles) {
      try {
        String jsonString = await rootBundle.loadString(file);
        Map<String, dynamic> jsonData = jsonDecode(jsonString);

        if (jsonData['lessons'] != null) {
          for (int i = 0; i < jsonData['lessons'].length; i++) {
            var lesson = jsonData['lessons'][i];
            lesson['lessonId'] = 'lesson_$i';
            if (lesson['tasks'] != null) {
              for (int j = 0; j < lesson['tasks'].length; j++) {
                lesson['tasks'][j]['taskId'] = 'task_$j';
              }
            }
          }
        }

        ClassModel classModel = ClassModel.fromJson(jsonData);
        if (enrolledClassesString.contains(classModel.classId)) {
          loadedClasses.add(classModel);
        }
      } catch (e) {
        debugPrint("Error loading file $file: $e");
      }
    }

    setState(() {
      enrolledClasses = loadedClasses;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPadding(
              padding: const EdgeInsets.only(top: 24.0),
              sliver: SliverAppBar(
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Moin!',
                            style: TextStyle(
                              fontSize: _savedName.isNotEmpty ? 20 : 26,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _savedName,
                            style: TextStyle(
                              fontSize: _savedName.isNotEmpty ? 14 : 0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SearchScreen(),
                                ),
                              ).then((result) {
                                if (result == true) {
                                  setState(() {
                                    _checkEnrolledClasses();
                                    _checkBookmarkedClasses();
                                  });
                                }
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
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
                ScreenCard(
                  iconData: Icons.location_on,
                  title: "Willkommen!",
                  subtitle: "Tippe um loszulegen",
                  onTap: () {
                    // Handle card tap
                  },
                ),
                ScreenCard(
                  iconData: Icons.map,
                  title: "GeoGebra Rechner",
                  subtitle: "Starte den GeoGebra Rechner",
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RechnerScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Favoriten',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //   },
                    //   child: Text(
                    //   'Alle',
                    //   style: TextStyle(
                    //     color: Theme.of(context).colorScheme.onSurface,
                    //     fontSize: 16,
                    //     decoration: TextDecoration.underline,
                    //   ),
                    //   ),
                    // ),
                  ],
                ),
                if (bookmarkedClasses.isEmpty)
                  Text("Hier werden deine Favoriten angezeigt"),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: bookmarkedClasses.length,
                  itemBuilder: (context, index) {
                    final cls = bookmarkedClasses[index];
                    return Card(
                      elevation: 1,
                      shape: Theme.of(context).cardTheme.shape,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cls.className,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cls.classShortDescription,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassScreen(
                                classModel: cls,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Fortsetzen',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    // GestureDetector(
                    //   onTap: () {
                    //   },
                    //   child: Text(
                    //   'Alle',
                    //   style: TextStyle(
                    //     color: Theme.of(context).colorScheme.onSurface,
                    //     fontSize: 16,
                    //     decoration: TextDecoration.underline,
                    //   ),
                    //   ),
                    // ),
                  ],
                ),
                if (enrolledClasses.isEmpty)
                  Text("Hier werden deine Kurse angezeigt"),
                ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: enrolledClasses.length,
                  itemBuilder: (context, index) {
                    final cls = enrolledClasses[index];
                    return Card(
                      elevation: 1,
                      shape: Theme.of(context).cardTheme.shape,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 16,
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cls.className,
                              style: Theme.of(context).textTheme.titleMedium,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cls.classShortDescription,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClassScreen(
                                classModel: cls,
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
      ),
      bottomNavigationBar: const BottomBarWidget(
        currentIndex: 0,
      ),
    );
  }
}
