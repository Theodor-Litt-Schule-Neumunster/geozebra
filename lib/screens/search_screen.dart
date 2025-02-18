import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/class_model.dart';
import '../screens/class_screen.dart';
import '../widgets/defaultappbar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ClassModel> allClasses = [];
  List<ClassModel> filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
  }

  Future<void> _loadClasses() async {
    List<String> classFiles = [
      'assets/classes/basic_geogebra.json',
      'assets/classes/advanced_geogebra.json',
      'assets/classes/intermediate_geogebra.json',
    ];

    List<ClassModel> loadedClasses = [];

    for (String file in classFiles) {
      try {
        String jsonString = await rootBundle.loadString(file);
        Map<String, dynamic> jsonData = jsonDecode(jsonString);
        loadedClasses.add(ClassModel.fromJson(jsonData));
      } catch (e) {
        debugPrint("Error loading file $file: $e");
      }
    }

    setState(() {
      allClasses = loadedClasses;
      filteredClasses = allClasses;
    });
  }

  void _filterClasses(String query) {
    setState(() {
      filteredClasses = allClasses
          .where((cls) =>
              cls.className.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Suchen", showLeading: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
            Material(
              elevation: 1,
              borderRadius: BorderRadius.circular(8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Suchen...",
                  prefixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurface),
                  border: Theme.of(context).inputDecorationTheme.border,
                  focusedBorder: Theme.of(context).inputDecorationTheme.focusedBorder,
                ),
                onChanged: _filterClasses,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: filteredClasses.length,
                itemBuilder: (context, index) {
                  return Card(
                  elevation: 1,
                  shape: Theme.of(context).cardTheme.shape,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 16),
                    title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                        child: Text(
                          filteredClasses[index].className,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        ),
                        const SizedBox(width: 12),
                        Wrap(
                        spacing: 12,
                        children: [
                          Icon(Icons.play_circle_fill, color: Theme.of(context).colorScheme.onSurface),
                          Icon(Icons.bookmark_border, color: Theme.of(context).colorScheme.onSurface),
                          Icon(Icons.numbers, color: Theme.of(context).colorScheme.onSurface),
                        ],
                        ),
                      ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                      filteredClasses[index].classShortDescription,
                      style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    ),
                    onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                      builder: (context) =>
                        ClassScreen(classModel: filteredClasses[index]),
                      ),
                    );
                    },
                  ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
