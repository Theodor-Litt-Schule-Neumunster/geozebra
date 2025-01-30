import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/defaultappbar_widget.dart';
import '../services/async_service.dart';
import '../providers/theme_provider.dart';

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

  final List<String> _themes = ["Light", "Light Color", "Dark"];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    String username = await SettingsService.loadSetting<String>("username", "");
    String selectedTheme =
        await SettingsService.loadSetting<String>("theme", "light");

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
    await SettingsService.saveSetting("displayname", value);
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
    default:
      themeKey = "light";
  }

  await SettingsService.saveSetting("theme", themeKey);

  Provider.of<ThemeProvider>(context, listen: false).setTheme(themeKey);

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
          ],
        ),
      ),
    );
  }
}
