import 'package:get/get.dart';
import 'package:pawlly/screens/pet_sitter/pet_sitter_model.dart';

import 'package:pawlly/utils/library.dart';

class PetSitterListScreen extends StatelessWidget {
  PetSitterListScreen({Key? key}) : super(key: key);
  final PetSitterController petSitterController =
      Get.put(PetSitterController());

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.petSitters,
      isLoading: petSitterController.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: petSitterController.getPetSitterList.value,
          errorBuilder: (error) {
            return SizedBox(
              height: Get.height * 0.7,
              child: NoDataWidget(
                title: error,
                retryText: locale.value.reload,
                imageWidget: const ErrorStateWidget(),
                onRetry: () {
                  petSitterController.getDoctorList();
                },
              ).paddingSymmetric(horizontal: 16),
            );
          },
          loadingWidget: const PetSitterListShimmer().paddingTop(16),
          onSuccess: (petSitters) {
            return AnimatedScrollView(
              padding: const EdgeInsets.only(bottom: 50, top: 16),
              listAnimationType: ListAnimationType.FadeIn,
              physics: const AlwaysScrollableScrollPhysics(),
              onSwipeRefresh: () async {
                petSitterController.page(1);
                return await petSitterController.getDoctorList(showloader: false);
              },
              onNextPage: () async {
                if (!petSitterController.isLastPage.value) {
                  petSitterController.page(petSitterController.page.value + 1);
                  petSitterController.getDoctorList();
                }
              },
              children: [
                SearchDoctorWidget(
                  doctorListController: petSitterController,
                  onClearButton: () {
                    petSitterController.handleSearch();
                  },
                  onFieldSubmitted: (p0) {
                    hideKeyboard(context);
                  },
                ).paddingSymmetric(horizontal: 16),
                8.height,
                Align(
                  alignment: Alignment.topCenter,
                  child: Obx(
                    () => Wrap(
                      runSpacing: 16,
                      spacing: 16,
                      children: List.generate(petSitters.length, (index) {
                        return PetSitterItemComponent(
                          petSitter: PetSitterItem(
                            id: petSitters[index].id,
                            fullName: petSitters[index].fullName,
                            email: petSitters[index].email,
                            mobile: petSitters[index].mobile,
                            profileImage: petSitters[index].profileImage.value,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
