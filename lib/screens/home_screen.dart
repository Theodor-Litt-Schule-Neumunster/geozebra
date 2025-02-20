// OLD VERSION OF THE HOME SCREEN, KEPT FOR REFERENCE
import 'package:flutter/material.dart';

import 'package:geozebra_app/services/settings_service.dart';
import 'package:geozebra_app/widgets/bottombar_widget.dart';
import 'package:geozebra_app/cards/home_card.dart';
import 'search_screen.dart';
import 'notification_screen.dart';
import 'rechner_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _savedName = "Der Jens";

  Future<String> _loadUserName() async {
    _savedName =
        await SettingsService().getValue<String>("displayname", "Der Jens");
    setState(() {});
    return _savedName;
  }

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context).brightness == Brightness.dark ? 'Dark' : 'Light';

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
                              );
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
                      'Fortsetzen',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    GestureDetector(
                      onTap: () {
                        // Handle tap
                      },
                      child: Text(
                        'Alle',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
                ScreenCard(
                  iconData: Icons.book,
                  title: 'Kurs: Analysis 1',
                  subtitle: 'Kapitel 3: Integralrechnung',
                  onTap: () {
                    // Handle tap
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
