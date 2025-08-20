// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import '../../utils/local_storage.dart';
import 'package:pawlly/utils/library.dart';
class SplashScreenController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    init();
    try {
      final getThemeFromLocal = getValueFromLocal(SettingsLocalConst.THEME_MODE);
      if (getThemeFromLocal is int) {
        toggleThemeMode(themeId: getThemeFromLocal);
      } else {
        toggleThemeMode(themeId: THEME_MODE_SYSTEM);
      }
    } catch (e) {
      log('getThemeFromLocal from cache E: $e');
    }
    super.onReady();
  }

  void init() {
    getAppConfigurations();
  }

  ///Get ChooseService List
  getAppConfigurations() {
    AuthServiceApis.getAppConfigurations(forceConfigSync: true).onError((error, stackTrace) {
      toast(error.toString());
    }).whenComplete(() => navigationLogic());
  }

  void navigationLogic() {
    if ((getValueFromLocal(SharedPreferenceConst.FIRST_TIME) ?? false) == false) {
      Get.offAll(() => WalkthroughScreen());
    } else if (getValueFromLocal(SharedPreferenceConst.IS_LOGGED_IN) == true) {
      try {
        final userData = getValueFromLocal(SharedPreferenceConst.USER_DATA);
        isLoggedIn(true);
        loginUserData(UserData.fromJson(userData));
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeScreenController());
        }));
      } catch (e) {
        log('SplashScreenController Err: $e');
        Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
          Get.put(HomeScreenController());
        }));
      }
    } else {
      Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
        Get.put(HomeScreenController());
      }));
    }
  }
}
