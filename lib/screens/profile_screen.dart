import 'package:flutter/material.dart';

// import "../widgets/defaultappbar_widget.dart";
import '../widgets/bottombar_widget.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar does not work as expected, dont care enough so this is it for now
      //FIXME: AppBar dropdown user selection
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 5,
        title: SizedBox(
          width: 200,
          height: 40,
          child: Center(
            child: DropdownButton<String>(
              value: "Jens",
              dropdownColor: Theme.of(context).colorScheme.primary,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              underline: Container(),
              icon: const Icon(Icons.arrow_drop_down),
              selectedItemBuilder: (BuildContext context) {
                return [
                  const Center(
                    child: Text(
                      "Jens",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ];
              },
              items: [
                DropdownMenuItem<String>(
                  value: 'Jens',
                  child: const Text(
                    'Jens',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
              onChanged: (String? newValue) {},
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),

      // Temporary content
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
              const Text(
                'Profil',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BottomBarWidget(
        currentIndex: 1,
      ),
    );
  }
}
