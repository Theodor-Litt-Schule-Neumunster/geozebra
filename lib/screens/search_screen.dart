import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/class_model.dart';
import '../screens/class_screen.dart';
// import '../widgets/defaultappbar_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<ClassModel> allClasses = [];
  List<ClassModel> filteredClasses = [];

  @override
  void initState() {
    super.initState();
    _loadClasses();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
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
      appBar: AppBar(
        titleSpacing: 0,
        title: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Padding(
            // FIXME: Padding does not work, please fix UwU
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              cursorColor: Theme.of(context).colorScheme.onPrimary,
              decoration: InputDecoration(
                hintText: "Suchen...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
              ),
              onChanged: _filterClasses,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.tune, size: 24.0),
            onPressed: () {
              // TODO: Implement options menu
            },
          ),
        ],
        toolbarHeight: 40.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.0),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(
          children: [
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
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              Wrap(
                                spacing: 0,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.bookmark_border,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface),
                                    onPressed: () {
                                      // TODO: Implement bookmark action
                                    },
                                  ),
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
