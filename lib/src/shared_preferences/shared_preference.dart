import 'package:shared_preferences/shared_preferences.dart';

void saveBrightnessPreference(bool isDarkMode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('isDarkMode', isDarkMode);
}
