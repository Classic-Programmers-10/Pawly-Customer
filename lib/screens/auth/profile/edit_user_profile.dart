import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class EditUserProfileScreen extends StatelessWidget {
  EditUserProfileScreen({super.key});

  final EditUserProfileController editUserProfileController =
      Get.put(EditUserProfileController());
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ValueNotifier _valueNotifier = ValueNotifier(true);
  Country selectedCountry = defaultCountry;

  String buildMobileNumber() {
    if (editUserProfileController.mobileCont.text.isEmpty) {
      return '';
    } else {
      return '${selectedCountry.phoneCode}-${editUserProfileController.mobileCont.text.trim()}';
    }
  }

  Future<void> changeCountry(BuildContext context) async {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        textStyle: secondaryTextStyle(color: textSecondaryColorGlobal),
        searchTextStyle: primaryTextStyle(),
        inputDecoration: InputDecoration(
          labelText: "search",
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),

      showPhoneCode: true,
      // optional. Shows phone code before the country name.
      onSelect: (Country country) {
        selectedCountry = country;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppScaffold(
        appBartitleText: locale.value.editProfile,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Obx(() => ProfilePicWidget(
                          heroTag: editUserProfileController
                                  .imageFile.value.path.isNotEmpty
                              ? editUserProfileController.imageFile.value.path
                              : loginUserData.value.profileImage.isNotEmpty
                                  ? loginUserData.value.profileImage
                                  : loginUserData.value.profileImage,
                          profileImage: editUserProfileController
                                  .imageFile.value.path.isNotEmpty
                              ? editUserProfileController.imageFile.value.path
                              : loginUserData.value.profileImage.isNotEmpty
                                  ? loginUserData.value.profileImage
                                  : loginUserData.value.profileImage,
                          firstName: loginUserData.value.firstName,
                          lastName: loginUserData.value.lastName,
                          userName: loginUserData.value.userName,
                          showBgCurves: false,
                          showOnlyPhoto: true,
                          onCameraTap: () {
                            editUserProfileController.showBottomSheet(context);
                          },
                          onPicTap: () {
                            editUserProfileController.showBottomSheet(context);
                          },
                        )),
                    32.height,
                    AppTextField(
                      title: locale.value.firstName,
                      textStyle: primaryTextStyle(size: 12),
                      controller: editUserProfileController.fNameCont,
                      focus: editUserProfileController.fNameFocus,
                      nextFocus: editUserProfileController.lNameFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(
                        context,
                        hintText: "${locale.value.eG}  ${locale.value.merry}",
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: Assets.profileIconsIcUserOutlined
                          .iconImage(fit: BoxFit.contain)
                          .paddingAll(14),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      title: locale.value.lastName,
                      textStyle: primaryTextStyle(size: 12),
                      controller: editUserProfileController.lNameCont,
                      focus: editUserProfileController.lNameFocus,
                      nextFocus: editUserProfileController.emailFocus,
                      textFieldType: TextFieldType.NAME,
                      decoration: inputDecoration(
                        context,
                        hintText: "${locale.value.eG}  ${locale.value.doe}",
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: Assets.profileIconsIcUserOutlined
                          .iconImage(fit: BoxFit.contain)
                          .paddingAll(14),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      title: locale.value.email,
                      textStyle: primaryTextStyle(size: 12),
                      controller: editUserProfileController.emailCont,
                      focus: editUserProfileController.emailFocus,
                      nextFocus: editUserProfileController.mobileFocus,
                      textFieldType: TextFieldType.EMAIL,
                      readOnly: true,
                      enabled: false,
                      decoration: inputDecoration(
                        context,
                        hintText: "${locale.value.eG} merry_456@gmail.com",
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                      suffix: Assets.iconsIcMail
                          .iconImage(fit: BoxFit.contain)
                          .paddingAll(14),
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    Text(locale.value.contactNumber, style: primaryTextStyle())
                        .paddingSymmetric(horizontal: 16),
                    4.height,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Country code ...
                        Container(
                          height: 48.0,
                          decoration: BoxDecoration(
                            color: context.cardColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Center(
                            child: ValueListenableBuilder(
                              valueListenable: _valueNotifier,
                              builder: (context, value, child) => Row(
                                children: [
                                  Text(
                                    "+${selectedCountry.phoneCode}",
                                    style: primaryTextStyle(size: 12),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: textSecondaryColorGlobal,
                                  )
                                ],
                              ).paddingOnly(left: 8),
                            ),
                          ),
                        ).onTap(() => changeCountry(context)),
                        10.width,
                        // Mobile number text field...
                        AppTextField(
                          textFieldType: isAndroid
                              ? TextFieldType.PHONE
                              : TextFieldType.NAME,
                          controller: editUserProfileController.mobileCont,
                          focus: editUserProfileController.mobileFocus,
                          nextFocus: editUserProfileController.addressFocus,
                          errorThisFieldRequired:
                              locale.value.thisFieldIsRequired,
                          isValidationRequired: false,
                          maxLength: 15,
                          suffix: Assets.iconsIcCall
                              .iconImage(fit: BoxFit.contain)
                              .paddingAll(14),
                          decoration: inputDecoration(
                            context,
                            hintText: "${locale.value.eG}  1-2188219848",
                            fillColor: context.cardColor,
                            filled: true,
                          ),
                        ).expand(),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                    16.height,
                    AppTextField(
                      isValidationRequired: false,
                      title: locale.value.address,
                      textStyle: primaryTextStyle(size: 12),
                      textFieldType: TextFieldType.MULTILINE,
                      controller: editUserProfileController.addressCont,
                      focus: editUserProfileController.addressFocus,
                      errorThisFieldRequired: locale.value.thisFieldIsRequired,
                      decoration: inputDecoration(
                        context,
                        hintText:
                            "${locale.value.eG} 123, ${locale.value.mainStreet}",
                        fillColor: context.cardColor,
                        filled: true,
                      ),
                    ).paddingSymmetric(horizontal: 16),
                    32.height,
                    AppButton(
                      width: Get.width,
                      text: locale.value.update,
                      textStyle: appButtonTextStyleWhite,
                      onTap: () async {
                        ifNotTester(() async {
                          if (await isNetworkAvailable()) {
                            editUserProfileController.updateUserProfile();
                          } else {
                            toast(locale.value.yourInternetIsNotWorking);
                          }
                        });
                      },
                    ).paddingSymmetric(horizontal: 16),
                    24.height,
                  ],
                ),
              ),
            ),
            Obx(() => const LoaderWidget()
                .visible(editUserProfileController.isLoading.value)),
          ],
        ),
      ),
    );
  }
}
