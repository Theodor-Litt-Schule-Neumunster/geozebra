import 'package:flutter/material.dart';

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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),

        // AppBar does not work as expected, dont care enough so this is it for now
        child: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          elevation: 5,
          flexibleSpace: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
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
                Row(
                  children: [
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
              ],
            ),
          ),
        ),
      ),
      // Temporary content
      body: const Center(
        child: Text(
          'Profil',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      bottomNavigationBar: const BottomBarWidget(
        currentIndex: 1,
      ),
    );
  }
}
