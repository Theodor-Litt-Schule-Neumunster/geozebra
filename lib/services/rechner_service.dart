import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';

class RechnerService {
  static const String _geoGebraKey = 'geogebra_state';
  static Timer? _autoSaveTimer;

  /// Saves the GeoGebra state as a Base64 string in SharedPreferences
  static Future<void> saveGeoGebraState(String base64) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_geoGebraKey, base64);
  }

  /// Loads the saved GeoGebra state from SharedPreferences
  static Future<String?> loadGeoGebraState() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_geoGebraKey);
  }

  /// Injects JavaScript for saving and loading GeoGebra state
  static void injectJavaScript(WebViewController controller) {
    controller.runJavaScript("""
      function saveGeoGebraState() {
          var base64 = ggbApplet.getBase64();
          SaveGeoGebraState.postMessage(base64);
      }
      function loadGeoGebraState(state) {
          ggbApplet.setBase64(state);
      }
    """);
  }

  /// Starts an autosave process every 2 minutes
  static void startAutoSave(WebViewController controller) {
    _autoSaveTimer?.cancel(); // Cancel previous timer if exists
    _autoSaveTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      controller.runJavaScript("saveGeoGebraState();");
    });
  }

  /// Stops the autosave process
  static void stopAutoSave() {
    _autoSaveTimer?.cancel();
  }

  static Future<void> saveOnExit(WebViewController controller) async {
  try {
    await Future.delayed(Duration(seconds: 2)); // Give time for WebView to load
    final String? base64 = await controller.runJavaScriptReturningResult("""
      if (window.isGeoGebraReady && typeof ggbApplet !== 'undefined') {
          ggbApplet.getBase64();
      } else {
          null;
      }
    """) as String?;
    
    if (base64 != null) {
      await saveGeoGebraState(base64);
      print("Successfully saved GeoGebra state on exit.");
    } else {
      print("GeoGebra was not ready when trying to save on exit.");
    }
  } catch (e) {
    print("Error saving state on exit: $e");
  }
}

}
