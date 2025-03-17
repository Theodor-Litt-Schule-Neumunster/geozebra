import 'package:flutter/material.dart';
import 'package:geozebra_app/screens/notification_screen.dart';
import 'package:provider/provider.dart';
import 'package:geozebra_app/widgets/defaultappbar_widget.dart';
import 'package:geozebra_app/services/settings_service.dart';
import 'package:geozebra_app/providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  String _username = "";
  String _selectedTheme = "Light";
  bool _isEditingUsername = false;
  final List<String> _themes = ["Light", "Light Color", "Dark", "Dark Color", "Purple"];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    String username = await SettingsService().getValue<String>("username", "");
    String selectedTheme =
        await SettingsService().getValue<String>("theme", "light");

    String displayTheme;
    switch (selectedTheme) {
      case "light":
        displayTheme = "Light";
        break;
      case "lightColor":
        displayTheme = "Light Color";
        break;
      case "dark":
        displayTheme = "Dark";
        break;
      case "darkColor":
        displayTheme = "Dark Color";
        break;
      case "purple":
        displayTheme = "Purple";
        break;
      default:
        displayTheme = "Light";
    }

    setState(() {
      _username = username;
      _selectedTheme = displayTheme;
      _usernameController.text = username;
    });
  }

  Future<void> _updateUsername(String value) async {
    await SettingsService().setValue("displayname", value);
    Provider.of<SettingsProvider>(context, listen: false).setUsername(value);

    setState(() {
      _username = value;
      _usernameController.text = value;
      _isEditingUsername = false;
    });
  }

  Future<void> _updateTheme(String value) async {
    String themeKey;
    switch (value) {
      case "Light":
        themeKey = "light";
        break;
      case "Light Color":
        themeKey = "lightColor";
        break;
      case "Dark":
        themeKey = "dark";
        break;
      case "Dark Color":
        themeKey = "darkColor";
        break;
      case "Purple":
        themeKey = "purple";
        break;
      default:
        themeKey = "light";
    }

    if (themeKey != "light") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Hinweis"),
            content: Text(
                "Der GeoGebra Rechner unterstützt aktuell keine Farbänderungen. Die Farbanpassung beeinflusst die Darstellung des Rechners nicht."),
            actions: [
              TextButton(
                child: Text(
                  "OK",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    await SettingsService().setValue("theme", themeKey);
    Provider.of<SettingsProvider>(context, listen: false).setTheme(themeKey);

    setState(() {
      _selectedTheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(
        title: "Einstellungen",
        showLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _isEditingUsername
                      ? TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: "Benutzername",
                            border: OutlineInputBorder(),
                          ),
                          onFieldSubmitted: (value) => _updateUsername(value),
                        )
                      : Text(
                          _username.isNotEmpty
                              ? _username
                              : "Kein Benutzername",
                          style: const TextStyle(fontSize: 16),
                        ),
                ),
                IconButton(
                  icon: Icon(_isEditingUsername ? Icons.check : Icons.edit),
                  onPressed: () {
                    if (_isEditingUsername) {
                      _updateUsername(_usernameController.text);
                    } else {
                      setState(() {
                        _isEditingUsername = true;
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedTheme,
              decoration: const InputDecoration(
                labelText: "Theme",
                border: OutlineInputBorder(),
              ),
              items: _themes
                  .map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(theme),
                      ))
                  .toList(),
              onChanged: (value) => _updateTheme(value!),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Benachrichtigungen"),
              subtitle: Text("Verwalte deine Benachrichtigungen"),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()),
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                ),
                onPressed: () async {
                  bool? confirm = await showDialog<bool>(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Bestätigung"),
                        content: Text(
                            "Möchtest du die App zurücksetzen? \nEs werden alle Daten unwiederkehrbar gelöscht."),
                        actions: [
                          TextButton(
                            child: Text(
                              "Abbrechen",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          TextButton(
                            child: Text(
                              "Ja",
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary),
                            ),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await Provider.of<SettingsProvider>(context, listen: false)
                        .clearAllData();
                    setState(() {
                      _username = "";
                      _selectedTheme = "Light";
                      _usernameController.clear();
                    });
                  }
                },
                child: const Text("App zurücksetzen"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
