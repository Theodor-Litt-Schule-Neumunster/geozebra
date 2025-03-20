import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:geozebra_app/services/settings_service.dart';
import 'package:flutter/services.dart';
import 'package:geozebra_app/cards/home_card.dart';
import 'package:geozebra_app/screens/search_screen.dart';
import 'package:geozebra_app/screens/notification_screen.dart';
import 'package:geozebra_app/screens/rechner_screen.dart';
import 'package:geozebra_app/screens/handbook_screen.dart';
import 'package:geozebra_app/screens/settings_screen.dart';
import 'package:geozebra_app/services/lessons_service.dart';
import 'package:geozebra_app/providers/lessons_provider.dart';
import 'package:geozebra_app/models/class_model.dart';
import 'package:geozebra_app/screens/class_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            snap: true,
            elevation: 2,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double collapsePercent = (constraints.maxHeight - kToolbarHeight) / 
                    (120 - kToolbarHeight);
                final bool isCollapsed = collapsePercent < 0.5;
                
                return FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(
                    left: 16.0,
                    bottom: isCollapsed ? 16.0 : 20.0,
                  ),
                  title: AnimatedOpacity(
                    opacity: isCollapsed ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 250),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Moin!',
                          style: TextStyle(
                            fontSize: isCollapsed ? 16 : (_savedName.isNotEmpty ? 20 : 26),
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        if (_savedName.isNotEmpty)
                          Text(
                            _savedName,
                            style: TextStyle(
                              fontSize: isCollapsed ? 12 : 14,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                            ),
                          ),
                      ],
                    ),
                  ),
                  background: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 50.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 1),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.search, color: Theme.of(context).colorScheme.onPrimary),
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
                                icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onPrimary),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationScreen(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            actions: [
            ],
          ),
                    

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFeatureCard(
                          context,
                          title: "Willkommen!",
                          subtitle: "Tippe um loszulegen",
                          icon: Icons.location_on,
                          onTap: () {
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: "GeoGebra Rechner",
                          subtitle: "Starte den Rechner",
                          icon: Icons.calculate,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RechnerScreen(),
                              ),
                            );
                          },
                        ),
                        _buildFeatureCard(
                          context,
                          title: "Handbuch",
                          subtitle: "Tipps & Tricks",
                          icon: Icons.book,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HandbookScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    "Favoriten",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  _buildFavoritesSection(context),

                  const SizedBox(height: 24),

                  Text(
                    "Fortsetzen",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  _buildEnrolledSection(context),
                  
                  const SizedBox(height: 64),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SettingsScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Einstellungen",
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesSection(BuildContext context) {
    if (bookmarkedClasses.isEmpty) {
      return const Text("Hier werden deine Favoriten angezeigt.");
    }
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: bookmarkedClasses.length,
        itemBuilder: (context, index) {
          final cls = bookmarkedClasses[index];
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassScreen(classModel: cls),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cls.className,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        cls.classShortDescription,
                        style: Theme.of(context).textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnrolledSection(BuildContext context) {
    if (enrolledClasses.isEmpty) {
      return const Text("Hier werden deine Kurse angezeigt.");
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: enrolledClasses.length,
      itemBuilder: (context, index) {
        final cls = enrolledClasses[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 16,
            ),
            title: Text(
              cls.className,
              style: Theme.of(context).textTheme.titleMedium,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              cls.classShortDescription,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ClassScreen(classModel: cls),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
