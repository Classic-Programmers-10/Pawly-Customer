import 'package:get/get.dart';

import 'package:pawlly/utils/library.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({Key? key}) : super(key: key);
  final ChangePassController changePassController =
      Get.put(ChangePassController());
  final GlobalKey<FormState> _changePassformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      isCenterTitle: true,
      appBartitleText: locale.value.changePassword,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _changePassformKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                Assets.authImagesChangePassword1,
                height: Constants.appLogoSignUp,
                width: Constants.appLogoSignUp,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const AppLogoWidget(),
              ).paddingTop(2),
              2.height,
              SizedBox(
                width: Get.width * 0.8,
                child: Text(
                  locale.value.yourNewPasswordMust,
                  style: secondaryTextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              40.height,
              AppTextField(
                title: locale.value.oldPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: changePassController.oldPasswordCont,
                // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: "${locale.value.eG} #123@156"),
                suffixPasswordVisibleWidget: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(
                        imgPath: Assets.iconsIcEyeSlash,
                        icon: Icons.password_outlined,
                        color: borderColor)
                    .paddingAll(12),
              ),
              16.height,
              AppTextField(
                title: locale.value.newPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: changePassController.newpasswordCont,
                // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: "${locale.value.eG}  #123@156"),
                suffixPasswordVisibleWidget: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(
                        imgPath: Assets.iconsIcEyeSlash,
                        icon: Icons.password_outlined,
                        color: borderColor)
                    .paddingAll(12),
              ),
              16.height,
              AppTextField(
                title: locale.value.confirmNewPassword,
                textStyle: primaryTextStyle(size: 12),
                controller: changePassController.confirmPasswordCont,
                // Optional
                textFieldType: TextFieldType.PASSWORD,
                decoration: inputDecoration(context,
                    fillColor: context.cardColor,
                    filled: true,
                    hintText: "${locale.value.eG}  #123@156"),
                suffixPasswordVisibleWidget: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: borderColor),
                suffixPasswordInvisibleWidget: commonLeadingWid(
                        imgPath: Assets.iconsIcEyeSlash,
                        icon: Icons.password_outlined,
                        color: borderColor)
                    .paddingAll(12),
              ),
              64.height,
              AppButton(
                width: Get.width,
                text: locale.value.submit,
                textStyle: appButtonTextStyleWhite,
                onTap: () async {
                  ifNotTester(() async {
                    if (await isNetworkAvailable()) {
                      if (_changePassformKey.currentState!.validate()) {
                        _changePassformKey.currentState!.save();
                        changePassController.saveForm();
                      }
                    } else {
                      toast(locale.value.yourInternetIsNotWorking);
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
