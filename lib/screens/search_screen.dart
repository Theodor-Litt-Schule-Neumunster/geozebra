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
    String jsonString = await rootBundle.loadString('assets/classes/basic_geogebra.json');
    Map<String, dynamic> jsonData = jsonDecode(jsonString);
    setState(() {
      allClasses = [ClassModel.fromJson(jsonData)];
      filteredClasses = allClasses;
    });
  }

  void _filterClasses(String query) {
    setState(() {
      filteredClasses = allClasses
          .where((cls) => cls.className.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Suchen", showLeading: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: "Suchen...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterClasses,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredClasses.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(filteredClasses[index].className),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClassScreen(classModel: filteredClasses[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
