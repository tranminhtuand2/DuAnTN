import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BrightnessController extends GetxController {
  var isDarkMode = false.obs;
  @override
  void onInit() {
    super.onInit();
    getDarkModeFromSharedPreferences();
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
  }

  Future<void> getDarkModeFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool initialDarkMode = prefs.getBool('isDarkMode') ?? false;
    if (initialDarkMode) {
      isDarkMode.value = initialDarkMode;
    }
  }
}
