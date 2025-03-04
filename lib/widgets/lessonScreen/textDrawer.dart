import 'package:flutter/material.dart';
import 'package:geozebra_app/models/class_model.dart';

class TextDrawer extends StatefulWidget {
  final List<TextSection> textSections;
  final Function(int) onTextSectionSelected;

  const TextDrawer({
    Key? key,
    required this.textSections,
    required this.onTextSectionSelected,
  }) : super(key: key);

  @override
  State<TextDrawer> createState() => _TextDrawerState();
}

class _TextDrawerState extends State<TextDrawer> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  bool _searchInContent = false;

  List<TextSection> get filteredSections {
    if (_searchQuery.isEmpty) {
      return widget.textSections;
    }

    final query = _searchQuery.toLowerCase();

    return widget.textSections.where((section) {
      final matchesHeader = section.header.toLowerCase().contains(query);
      final matchesSubheader = section.subHeader.toLowerCase().contains(query);

      final matchesContent = _searchInContent
          ? section.content.toLowerCase().contains(query)
          : false;

      return matchesHeader || matchesSubheader || matchesContent;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Text("Inhalt durchsuchen"),
                Checkbox(
                  value: _searchInContent,
                  onChanged: (bool? value) {
                    setState(() {
                      _searchInContent = value ?? false;
                    });
                  },
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredSections.length,
              itemBuilder: (context, index) {
                final section = filteredSections[index];

                return ListTile(
                  title: Text(section.header),
                  subtitle: Text(section.subHeader),
                  onTap: () {
                    final actualIndex = widget.textSections.indexOf(section);
                    widget.onTextSectionSelected(actualIndex);

                    Navigator.pop(context);
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
