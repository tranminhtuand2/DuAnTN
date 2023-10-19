import 'package:get/get.dart';

class NavigatePanelController extends GetxController {
  var indexPage = 0.obs;

  void navigatePage(int index) {
    indexPage.value = index;
  }
}
