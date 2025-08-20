import 'package:get/get.dart';
import '../../utils/local_storage.dart';
import 'package:pawlly/utils/library.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxBool isLoading = false.obs;

  RxList<StatelessWidget> screen = [
    HomeScreen(),
    BookingsScreen(),
    ShopDashboardScreen(),
    isLoggedIn.value ? ProfileScreen() : SettingScreen(),
  ].obs;

  @override
  void onInit() {
    myPetsScreenController.init();
    if (!isLoggedIn.value) {
      ProfileController().getAboutPageData();
    }
    init();
    super.onInit();
  }

  @override
  void onReady() {
    if (Get.context != null) {
      View.of(Get.context!).platformDispatcher.onPlatformBrightnessChanged =
          () {
        WidgetsBinding.instance.handlePlatformBrightnessChanged();
        try {
          final getThemeFromLocal =
              getValueFromLocal(SettingsLocalConst.THEME_MODE);
          if (getThemeFromLocal is int) {
            toggleThemeMode(themeId: getThemeFromLocal);
          }
        } catch (e) {
          log('getThemeFromLocal from cache E: $e');
        }
      };
    }
    Future.delayed(const Duration(seconds: 2), () {
      if (Get.context != null) {
        showForceUpdateDialog(Get.context!);
      }
    });
    super.onReady();
  }

  void reloadBottomTabs() {
    screen(<StatelessWidget>[
      HomeScreen(),
      BookingsScreen(),
      ShopDashboardScreen(),
      isLoggedIn.value ? ProfileScreen() : SettingScreen(),
    ]);
  }

  void init() {
    try {
      final statusListResFromLocal =
          getValueFromLocal(APICacheConst.STATUS_RESPONSE);
      if (statusListResFromLocal != null) {
        allStatus(StatusListRes.fromJson(statusListResFromLocal).data);
      }
    } catch (e) {
      log('statusListResFromLocal from cache E: $e');
    }
    try {
      final petCenterResFromLocal =
          getValueFromLocal(APICacheConst.PET_CENTER_RESPONSE);
      if (petCenterResFromLocal != null) {
        petCenterDetail(PetCenterRes.fromJson(petCenterResFromLocal).data);
      }
    } catch (e) {
      log('petCenterResFromLocal from cache E: $e');
    }
    getAllStatusUsedForBooking();
    getPetCenterDetail();
    getAppConfigurations(isFromDashboard: true);
    getAllStatusUsedForOrder();
  }

  ///Get ChooseService List
  getAllStatusUsedForBooking() {
    isLoading(true);
    HomeServiceApis.getAllStatusUsedForBooking().then((value) {
      isLoading(false);
      allStatus(value.data);
      setValueToLocal(APICacheConst.STATUS_RESPONSE, value.toJson());
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  getAllStatusUsedForOrder() {
    isLoading(true);
    OrderApis.getOrderFilterStatus().then((value) {
      isLoading(false);
      allOrderStatus(value.data);
      setValueToLocal(APICacheConst.STATUS_RESPONSE, value.toJson());
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }

  ///Get ChooseService List
  getPetCenterDetail() {
    isLoading(true);
    HomeServiceApis.getPetCenterDetail().then((value) {
      isLoading(false);
      petCenterDetail(value.data);
      setValueToLocal(APICacheConst.PET_CENTER_RESPONSE, value.toJson());
    }).onError((error, stackTrace) {
      isLoading(false);
      toast(error.toString());
    });
  }
}

///Get ChooseService List
getAppConfigurations(
    {bool isFromDashboard = false, bool forceConfigSync = false}) {
  AuthServiceApis.getAppConfigurations(
          forceConfigSync: forceConfigSync, isFromDashboard: isFromDashboard)
      .onError((error, stackTrace) {
    toast(error.toString());
  });
}
