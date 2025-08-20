import 'package:get/get.dart';
import 'dart:math';
import 'package:pawlly/utils/library.dart';

class GreetingsComponent extends StatelessWidget {
  GreetingsComponent({super.key});

  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                '${locale.value.hello}, ${loginUserData.value.userName.isNotEmpty ? loginUserData.value.userName : locale.value.guest} 👋',
                style: primaryTextStyle(size: 20),
              ),
            ).paddingTop(16),
            Obx(
              () => randomPetName.isNotEmpty
                  ? Container(
                      width: Get.width * 0.6,
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${locale.value.howS} $randomPetName ${locale.value.healthGoingOn}',
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  : const SizedBox(),
            )
          ],
        ),
        const Spacer(),
        Stack(
          children: [
            IconButton(
              onPressed: () {
                Get.to(() => NotificationScreen());
              },
              icon: Assets.iconsIcUnselectedBell
                  .iconImage(color: darkGray, size: 24),
            ).visible(isLoggedIn.value),
            Positioned(
              top: homeScreenController.dashboardData.value.notificationCount <
                      10
                  ? 5
                  : 4,
              right:
                  homeScreenController.dashboardData.value.notificationCount <
                          10
                      ? 12
                      : 10,
              child: Obx(() => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: boxDecorationDefault(
                        color: primaryColor, shape: BoxShape.circle),
                    child: Text(
                      '${homeScreenController.dashboardData.value.notificationCount}',
                      style: primaryTextStyle(
                          size: homeScreenController
                                      .dashboardData.value.notificationCount <
                                  10
                              ? 10
                              : 8,
                          color: white),
                    ),
                  ).visible(homeScreenController
                          .dashboardData.value.notificationCount >
                      0)),
            ),
          ],
        ).paddingTop(16),
      ],
    ).paddingSymmetric(horizontal: 16);
  }

  String get randomPetName {
    try {
      if (myPetsScreenController.myPets.isNotEmpty) {
        return myPetsScreenController
            .myPets[Random().nextInt(myPetsScreenController.myPets.length)]
            .name;
      } else {
        return "";
      }
    } catch (e) {
      log('randomPetName E: $e');
      return "";
    }
  }
}
