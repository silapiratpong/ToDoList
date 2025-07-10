import 'package:get/get.dart';

class TaskController extends GetxController{
  var isPrivate = false.obs;

  void togglePrivacy(bool? value)
  {
    isPrivate.value = value ?? false;
  }
  void reset()
  {
    isPrivate.value = false;
  }
}