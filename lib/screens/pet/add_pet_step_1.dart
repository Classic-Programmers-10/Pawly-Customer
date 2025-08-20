import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class AddPetStep1Screen extends StatelessWidget {
  AddPetStep1Screen({Key? key}) : super(key: key);

  final AddPetInfoController addPetInfoController =
      Get.put(AddPetInfoController());

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        16.height,
        Obx(
          () => AnimatedWrap(
            runSpacing: 16,
            spacing: 16,
            children: List.generate(
              addPetInfoController.petTypeList.length,
              (index) {
                ChoosePetModel choosePet =
                    addPetInfoController.petTypeList[index];

                return ChoosePet(choosePet: choosePet);
              },
            ),
          ),
        )
      ],
    ).paddingOnly(left: 16);
  }
}
