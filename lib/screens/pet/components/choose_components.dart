import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class ChoosePet extends StatelessWidget {
  ChoosePet({Key? key, required this.choosePet}) : super(key: key);
  final AddPetInfoController addPetInfoController =
      Get.put(AddPetInfoController());
  final ChoosePetModel choosePet;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 21,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
              onTap: () {
                addPetInfoController.addPetReq.pettypeId =
                    choosePet.id.toString();
                addPetInfoController.selectedPetType(choosePet);
                log('ADDPETINFOCONTROLLER.ADDPETREQ: ${addPetInfoController.addPetReq.toJson()}');
                addPetInfoController.getBreed();
                addPetInfoController.handleNext();
              },
              borderRadius: radius(),
              child: CachedImageWidget(
                url: choosePet.pettypeImage,
                height: 90,
                width: 90,
                radius: 8,
                fit: BoxFit.cover,
              )),
          8.height,
          Text(choosePet.name, style: primaryTextStyle()),
          16.height,
        ],
      ),
    );
  }
}
