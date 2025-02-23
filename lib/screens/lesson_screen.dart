import 'package:flutter/material.dart';

class LessonScreen extends StatefulWidget {
  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final List<Map<String, String>> lessons = [
    {
      'title': 'Lektion 1: Einführung',
      'description': 'Lerne die grundlegenden Konzepte der Mathematik.',
    },
    {
      'title': 'Lektion 2: Addieren und Subtrahieren',
      'description': 'Verstehe die Addition und Subtraktion von Zahlen.',
    },
    {
      'title': 'Lektion 3: Multiplikation',
      'description': 'Erkunde die Grundlagen der Multiplikation.',
    },
    {
      'title': 'Lektion 4: Geometrie',
      'description': 'Lerne die verschiedenen geometrischen Formen kennen.',
    },
    {
      'title': 'Lektion 5: Algebra',
      'description': 'Einführung in algebraische Ausdrücke und Gleichungen.',
    },
    {
      'title': 'Lektion 6: Trigonometrie',
      'description': 'Verstehe die Grundbegriffe der Trigonometrie.',
    },
  ];

  List<bool> lessonProgress = [false, false, false, false, false, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wähle ein Thema'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: lessons.length,
          itemBuilder: (context, index) {
            var lesson = lessons[index];

            bool isLessonAvailable = index == 0 || lessonProgress[index - 1];

            return GestureDetector(
              onTap: () {
                if (isLessonAvailable) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LessonDetailScreen(
                        title: lesson['title']!,
                        description: lesson['description']!,
                        onLessonCompleted: () {
                          setState(() {
                            lessonProgress[index] = true;
                          });
                        },
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Bitte schließe die vorherige Lektion ab.'),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isLessonAvailable ? Colors.white : Colors.grey[300],
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          lesson['title']!,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          lesson['description']!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    if (!isLessonAvailable)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.lock,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class LessonDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onLessonCompleted;

  LessonDetailScreen({
    required this.title,
    required this.description,
    required this.onLessonCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              description,
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                onLessonCompleted();
                Navigator.pop(context);
              },
              child: Text('Lektion abschließen'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

