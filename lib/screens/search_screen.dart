import "package:flutter/material.dart";

import "../widgets/defaultappbar_widget.dart";

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  bool _searchBarInFocus = false;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _searchBarInFocus = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const DefaultAppBar(
          title: "",
          showLeading: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onChanged: (value) {},
              ),
            ),
            _searchBarInFocus
                ? Expanded(
                    child: ListView(
                      children: [
                        ListTile(
                          title: Text('Recommendation 1'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Recommendation 2'),
                          onTap: () {},
                        ),
                        ListTile(
                          title: Text('Recommendation 3'),
                          onTap: () {},
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView(
                      children: [
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.map),
                            title: Text('Card 1'),
                            subtitle: Text('Description for Card 1'),
                            onTap: () {},
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.place),
                            title: Text('Card 2'),
                            subtitle: Text('Description for Card 2'),
                            onTap: () {},
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: Icon(Icons.location_city),
                            title: Text('Card 3'),
                            subtitle: Text('Description for Card 3'),
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                  ),
          ],
        ));
  }
}
