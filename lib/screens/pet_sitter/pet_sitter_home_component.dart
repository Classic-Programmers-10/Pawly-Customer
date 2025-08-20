import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class ChoosePetSitterComponents extends StatelessWidget {
  ChoosePetSitterComponents({Key? key}) : super(key: key);
  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.height,
        ViewAllLabel(
          label: locale.value.petSitter,
          list: homeScreenController.dashboardData.value.petSitter,
          onTap: () {
            Get.to(() => PetSitterListScreen());
          },
        )
            .visible(
                homeScreenController.dashboardData.value.petSitter.isNotEmpty)
            .paddingOnly(left: 16, right: 8),
        8.height,
        HorizontalList(
          runSpacing: 16,
          spacing: 16,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: homeScreenController.dashboardData.value.petSitter.length,
          itemBuilder: (context, index) {
            return PetSitterItemComponent(
                petSitter:
                    homeScreenController.dashboardData.value.petSitter[index]);
          },
        ),
      ],
    );
  }
}
