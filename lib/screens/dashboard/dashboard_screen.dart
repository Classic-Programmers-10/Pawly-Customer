import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final DashboardController dashboardController =
      Get.put(DashboardController());

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: locale.value.pressBackAgainToExitApp,
      child: AppScaffold(
        hideAppBar: true,
        body: Obx(() =>
            dashboardController.screen[dashboardController.currentIndex.value]),
        bottomNavBar: Obx(
          () => NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: context.cardColor,
              indicatorColor: context.primaryColor.withOpacity(0.1),
              labelTextStyle:
                  WidgetStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: dashboardController.currentIndex.value,
              onDestinationSelected: (v) {
                if (!isLoggedIn.value && v == 1) {
                  doIfLoggedIn(context, () {
                    dashboardController.currentIndex(v);
                  });
                } else {
                  dashboardController.currentIndex(v);
                }
                try {
                  if (v == 0) {
                    HomeScreenController hCont = Get.find();
                    hCont.getDashboardDetail(isFromSwipRefresh: true);
                  } else if (isLoggedIn.value && v == 1) {
                    BookingsController bCont = Get.find();
                    bCont.getBookingList(showloader: false);
                  } else if (v == 2) {
                    ShopDashboardController sCont = Get.find();
                    sCont.pCont.searchCont.clear();
                    sCont.pCont.isSearchText(
                        sCont.pCont.searchCont.text.trim().isNotEmpty);
                    sCont.getShopDashboardDetail(isFromSwipRefresh: true);
                  }
                } catch (e) {
                  log('onItemSelected Err: $e');
                }
              },
              destinations: [
                tab(
                  iconData: Assets.navigationIcHomeOutlined
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcHomeFilled
                      .iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.home,
                ),
                tab(
                  iconData: Assets.navigationIcCalendarOutlined
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcCalenderFilled
                      .iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.bookings,
                ),
                tab(
                  iconData: Assets.navigationIcShopOutlined
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: Assets.navigationIcShopFilled
                      .iconImage(color: context.primaryColor, size: 22),
                  tabName: locale.value.shop,
                ),
                tab(
                  iconData: (isLoggedIn.value
                          ? Assets.navigationIcUserOutlined
                          : Assets.profileIconsIcSettingOutlined)
                      .iconImage(color: darkGray, size: 22),
                  activeIconData: isLoggedIn.value
                      ? Assets.navigationIcUserFilled
                          .iconImage(color: context.primaryColor, size: 22)
                      : Icon(
                          Icons.settings,
                          color: context.primaryColor,
                          size: 22,
                        ),
                  tabName: isLoggedIn.value
                      ? locale.value.profile
                      : locale.value.settings,
                ),
              ],
            ),
          ).visible(!updateUi.value),
        ),
      ),
    );
  }

  NavigationDestination tab(
      {required Widget iconData,
      required Widget activeIconData,
      required String tabName}) {
    return NavigationDestination(
      icon: iconData,
      selectedIcon: activeIconData,
      label: tabName,
    );
  }
}
