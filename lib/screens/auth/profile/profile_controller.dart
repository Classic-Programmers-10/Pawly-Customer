// ignore_for_file: depend_on_referenced_packages

import 'package:get/get.dart';
import '../../../utils/local_storage.dart';
import 'package:pawlly/utils/library.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    try {
      final aboutPageResFromLocal =
          getValueFromLocal(APICacheConst.ABOUT_RESPONSE);
      if (aboutPageResFromLocal != null) {
        aboutPages(AboutPageRes.fromJson(aboutPageResFromLocal).data);
      }
    } catch (e) {
      log('aboutPageResFromLocal from cache E: $e');
    }
    getAboutPageData();
  }

  handleLogout() async {
    if (isLoading.value) return;
    isLoading(true);
    log('HANDLELOGOUT: called');
    await AuthServiceApis.logoutApi().then((value) async {
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString());
    }).whenComplete(() {
      AuthServiceApis.clearData();
      AuthServiceApis.getAppConfigurations(forceConfigSync: true)
          .onError((error, stackTrace) {
        log('profileController: ${error.toString()}');
      });
      Get.offAll(() => DashboardScreen(), binding: BindingsBuilder(() {
        Get.put(HomeScreenController());
      }));
    });
  }

  String getAboutSubtitle() {
    List subtitle = [];
    String text = "";
    if (getPrivacyPolicySubtitle().isNotEmpty) {
      subtitle.add(getPrivacyPolicySubtitle());
    }
    if (getTermsAndConditionSubtitle().isNotEmpty) {
      subtitle.add(getTermsAndConditionSubtitle());
    }

    if (subtitle.length > 1) {
      text = subtitle.join(", ");
    } else {
      text = subtitle.join();
    }
    return text;
  }

  String getPrivacyPolicySubtitle() {
    String text = "";
    for (var element in aboutPages) {
      if (element.slug == PageType.PrivacyPolicy) {
        text = locale.value.privacyPolicy;
        break;
      } else {
        text = "";
      }
    }
    return text;
  }

  String getTermsAndConditionSubtitle() {
    String text = "";
    for (var element in aboutPages) {
      if (element.slug == PageType.TermsAndCondition) {
        text = locale.value.termsConditions;
        break;
      } else {
        text = "";
      }
    }
    return text;
  }

  ///Get ChooseService List
  getAboutPageData({bool isFromSwipRefresh = false}) {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }
    isLoading(true);
    HomeServiceApis.getAboutPageData().then((value) {
      isLoading(false);
      aboutPages(value.data);
      setValueToLocal(APICacheConst.ABOUT_RESPONSE, value.toJson());
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }
}
