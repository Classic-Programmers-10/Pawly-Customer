// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class ForgetPasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController emailCont = TextEditingController();

  saveForm() async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      'email': emailCont.text.trim(),
    };

    await AuthServiceApis.forgotPasswordAPI(request: req).then((value) async {
      isLoading(false);
      Get.back();
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
