import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class ChooseServiceComponents extends StatelessWidget {
  ChooseServiceComponents({super.key});

  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          16.height,
          ViewAllLabel(
            label: locale.value.chooseService,
            onTap: () {
              Get.to(() => ChooseService(),
                  duration: const Duration(milliseconds: 800));
            },
            trailingText: locale.value.explore,
          ).paddingOnly(left: 16, right: 8),
          6.height,
          Obx(
            () => HorizontalList(
              runSpacing: 16,
              spacing: 16,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              wrapAlignment: WrapAlignment.start,
              itemCount:
                  homeScreenController.dashboardData.value.systemService.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    hideKeyboard(context);
                    navigateToService(homeScreenController
                        .dashboardData.value.systemService[index]);
                  },
                  borderRadius: radius(),
                  child: ServiceCard(
                    service: homeScreenController
                        .dashboardData.value.systemService[index],
                  ),
                );
              },
            ),
          ),
        ],
      ).visible(
          homeScreenController.dashboardData.value.systemService.isNotEmpty),
    );
  }
}
