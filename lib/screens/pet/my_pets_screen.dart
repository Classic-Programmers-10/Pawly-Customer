import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.myPets,
      actions: [
        TextButton(
          onPressed: () {
            Get.to(() => AddPetInfoScreen());
          },
          child: Text(
            locale.value.addPet,
            style: secondaryTextStyle(
              color: primaryColor,
              decorationColor: primaryColor,
            ),
          ).paddingSymmetric(horizontal: 8),
        )
      ],
      isLoading: myPetsScreenController.isLoading,
      body: RefreshIndicator(
        onRefresh: () async {
          myPetsScreenController.init();
          return await Future.delayed(const Duration(seconds: 3));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Obx(
            () => SnapHelperWidget(
              future: myPetsScreenController.getPets.value,
              errorBuilder: (error) {
                return SizedBox(
                  height: Get.height * 0.7,
                  child: NoDataWidget(
                    title: error,
                    retryText: locale.value.reload,
                    imageWidget: const ErrorStateWidget(),
                    onRetry: () {
                      myPetsScreenController.init();
                    },
                  ).paddingSymmetric(horizontal: 16),
                );
              },
              loadingWidget: const MyPetsScreenShimmer().paddingTop(16),
              onSuccess: (pets) {
                return pets.isEmpty
                    ? SizedBox(
                        height: Get.height * 0.7,
                        child: NoDataWidget(
                          title: locale.value.looksLikeYouHavenT,
                          imageWidget: const EmptyStateWidget(),
                          subTitle: locale.value.addYourFirstPet,
                          retryText: locale.value.addYourPet,
                          onRetry: () {
                            Get.to(() => AddPetInfoScreen());
                          },
                        ).paddingSymmetric(horizontal: 16),
                      )
                    : AnimatedScrollView(
                        listAnimationType: ListAnimationType.None,
                        padding: const EdgeInsets.only(bottom: 50),
                        children: [
                          16.height,
                          AnimatedWrap(
                            runSpacing: 16,
                            spacing: 16,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: List.generate(pets.length, (index) {
                              PetData editProfile = pets[index];
                              return InkWell(
                                onTap: () {
                                  myPetsScreenController
                                      .selectedPetProfile(pets[index]);
                                  log('SELECTED PET PROFILE: ${myPetsScreenController.selectedPetProfile.toJson()}');
                                  Get.to(() => PetProfileScreen());
                                },
                                borderRadius: radius(),
                                child: PetCard(editProfile: editProfile),
                              );
                            }),
                          ),
                        ],
                      );
              },
            ),
          ),
        ),
      ),
    );
  }
}
