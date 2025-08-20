import 'package:get/get.dart';

import 'package:pawlly/configs.dart';
import 'package:pawlly/utils/library.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final SignInController signInController = Get.put(SignInController());
  final GlobalKey<FormState> _signInformKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      hideAppBar: true,
      isLoading: signInController.isLoading,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  65.height,
                  Image.asset(
                    Assets.authImagesSignin,
                    height: Constants.appLogoSignIn,
                    width: Constants.appLogoSignIn,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const AppLogoWidget(),
                  ),
                  16.height,
                  Text(
                    '${locale.value.hello} ${signInController.userName.value.isNotEmpty ? signInController.userName.value : locale.value.guest}!',
                    style: primaryTextStyle(size: 24),
                  ),
                  8.height,
                  Text(
                    signInController.userName.value.isNotEmpty
                        ? '${locale.value.welcomeBackToThe}  $APP_NAME  ${locale.value.app}'
                        : '${locale.value.welcomeToThe} $APP_NAME ${locale.value.care}',
                    style: secondaryTextStyle(size: 14),
                  ),
                  50.height,
                  Form(
                    key: _signInformKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => AppTextField(
                            title: locale.value.email,
                            textStyle: primaryTextStyle(size: 12),
                            controller: signInController.emailCont,
                            focus: signInController.emailFocus,
                            nextFocus: signInController.passwordFocus,
                            textFieldType: TextFieldType.EMAIL,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText:
                                  "${locale.value.eG} merry_456@gmail.com",
                            ),
                            onTap: () {
                              signInController.hasPasswordFocus(false);
                              signInController.hasEmailFocus(true);
                            },
                            suffix: Assets.iconsIcMail
                                .iconImage(
                                    fit: BoxFit.contain,
                                    color: signInController.hasEmailFocus.value
                                        ? primaryColor
                                        : null)
                                .paddingAll(14),
                          ),
                        ),
                        16.height,
                        Obx(
                          () => AppTextField(
                            title: locale.value.password,
                            textStyle: primaryTextStyle(size: 12),
                            controller: signInController.passwordCont,
                            focus: signInController.passwordFocus,
                            // Optional
                            textFieldType: TextFieldType.PASSWORD,
                            decoration: inputDecoration(
                              context,
                              fillColor: context.cardColor,
                              filled: true,
                              hintText: "••••••••",
                            ),
                            onTap: () {
                              signInController.hasEmailFocus(false);
                              signInController.hasPasswordFocus(true);
                            },
                            suffixPasswordVisibleWidget: commonLeadingWid(
                              imgPath: Assets.iconsIcEye,
                              icon: Icons.password_outlined,
                              color: signInController.hasPasswordFocus.value
                                  ? primaryColor
                                  : null,
                              size: 14,
                            ).paddingAll(12),
                            suffixPasswordInvisibleWidget: commonLeadingWid(
                              imgPath: Assets.iconsIcEyeSlash,
                              icon: Icons.password_outlined,
                              color: signInController.hasPasswordFocus.value
                                  ? primaryColor
                                  : null,
                              size: 14,
                            ).paddingAll(12),
                          ),
                        ),
                        8.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(
                              () => InkWell(
                                onTap: signInController.toggleSwitch,
                                borderRadius: radius(),
                                child: Row(
                                  children: [
                                    Transform.scale(
                                      scale: 0.75,
                                      child: Switch(
                                        activeTrackColor:
                                            switchActiveTrackColor,
                                        value:
                                            signInController.isRememberMe.value,
                                        activeColor: switchActiveColor,
                                        inactiveTrackColor:
                                            switchColor.withOpacity(0.2),
                                        onChanged: (bool value) {
                                          signInController.toggleSwitch();
                                        },
                                      ),
                                    ),
                                    Text(
                                      locale.value.rememberMe,
                                      style: secondaryTextStyle(
                                          color: darkGrayGeneral),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.to(() => ForgetPassword());
                              },
                              child: Text(
                                locale.value.forgotPassword,
                                style: primaryTextStyle(
                                  size: 12,
                                  color: primaryColor,
                                  decoration: TextDecoration.underline,
                                  fontStyle: FontStyle.italic,
                                  decorationColor: primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        32.height,
                        AppButton(
                          width: Get.width,
                          text: locale.value.signIn,
                          textStyle: appButtonTextStyleWhite,
                          onTap: () {
                            if (_signInformKey.currentState!.validate()) {
                              _signInformKey.currentState!.save();
                              signInController.saveForm();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  8.height,
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(locale.value.notRegistered,
                          style: secondaryTextStyle()),
                      4.width,
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: Text(
                          locale.value.registerNow,
                          style: primaryTextStyle(
                            size: 12,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: primaryColor,
                          ),
                        ).paddingSymmetric(horizontal: 8),
                      ),
                    ],
                  ),
                  16.height,
                  if (appConfigs.value.googleLoginStatus == 1 && isAndroid ||
                      (isApple && appConfigs.value.googleLoginStatus == 1 ||
                          isApple && appConfigs.value.appleLoginStatus == 1))
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 10.0),
                          child: const Divider(color: borderColor),
                        ).expand(),
                        Text(locale.value.orSignInWith,
                                style: primaryTextStyle(
                                    color: secondaryTextColor, size: 14))
                            .paddingSymmetric(horizontal: 20),
                        Container(
                          margin: const EdgeInsets.only(right: 10.0),
                          child: const Divider(
                            color: borderColor,
                          ),
                        ).expand(),
                      ],
                    ),
                  16.height,
                  if (appConfigs.value.googleLoginStatus == 1)
                    AppButton(
                      width: Get.width,
                      color: context.cardColor,
                      text: "",
                      textStyle: appButtonFontColorText,
                      onTap: () {
                        signInController.googleSignIn();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesGoogleLogo,
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.g_mobiledata_rounded),
                          ),
                          8.width,
                          Text(
                            locale.value.signInWithGoogle,
                            style: primaryTextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  if (appConfigs.value.appleLoginStatus == 1)
                    AppButton(
                      width: Get.width,
                      color: context.cardColor,
                      text: "",
                      textStyle: appButtonFontColorText,
                      onTap: () {
                        signInController.appleSignIn();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            Assets.imagesAppleLogo,
                            height: 20,
                            width: 20,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.g_mobiledata_rounded),
                          ),
                          8.width,
                          Text(
                            locale.value.signInWithApple,
                            style: primaryTextStyle(),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ).paddingTop(16).visible(isApple),
                ],
              ),
            ),
            Positioned(
              top: 40,
              child: Container(
                margin: const EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: context.cardColor),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_outlined, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
