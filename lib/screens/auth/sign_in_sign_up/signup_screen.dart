import 'package:get/get.dart';
import '../../../configs.dart';
import 'package:pawlly/utils/library.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);
  final SignUpController signUpController = Get.put(SignUpController());
  final GlobalKey<FormState> _signUpformKey = GlobalKey();

  ValueNotifier _valueNotifier = ValueNotifier(true);

  Country selectedCountry = defaultCountry;

  String buildMobileNumber() {
    if (signUpController.mobileCont.text.isEmpty) {
      return '';
    } else {
      return '${selectedCountry.phoneCode}-${signUpController.mobileCont.text.trim()}';
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
    return AppScaffold(
      hideAppBar: true,
      body: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.only(
                  left: 16, right: 16, top: 10, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  50.height,
                  Image.asset(
                    Assets.authImagesCreateYourAccount,
                    height: Constants.appLogoSignUp,
                    width: Constants.appLogoSignUp,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const AppLogoWidget(),
                  ),
                  2.height,
                  Text(
                    locale.value.createYourAccount,
                    style: primaryTextStyle(size: 24),
                  ),
                  8.height,
                  Text(
                    locale.value.createYourAccountFor,
                    style: secondaryTextStyle(size: 14),
                  ),
                  30.height,
                  Form(
                    key: _signUpformKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        16.height,
                        AppTextField(
                          title: locale.value.firstName,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.fisrtNameCont,
                          focus: signUpController.fisrtNameFocus,
                          nextFocus: signUpController.lastNameFocus,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText:
                                "${locale.value.eG} ${locale.value.merry}",
                          ),
                          suffix: Assets.profileIconsIcUserOutlined
                              .iconImage(fit: BoxFit.contain)
                              .paddingAll(14),
                        ),
                        16.height,
                        AppTextField(
                          title: locale.value.lastName,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.lastNameCont,
                          focus: signUpController.lastNameFocus,
                          nextFocus: signUpController.emailFocus,
                          textFieldType: TextFieldType.NAME,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG}  ${locale.value.doe}",
                          ),
                          suffix: Assets.profileIconsIcUserOutlined
                              .iconImage(fit: BoxFit.contain)
                              .paddingAll(14),
                        ),
                        16.height,
                        AppTextField(
                          title: locale.value.email,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.emailCont,
                          focus: signUpController.emailFocus,
                          nextFocus: signUpController.passwordFocus,
                          textFieldType: TextFieldType.EMAIL_ENHANCED,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} merry_456@gmail.com",
                          ),
                          suffix: Assets.iconsIcMail
                              .iconImage(fit: BoxFit.contain)
                              .paddingAll(14),
                        ),
                        16.height,
                        AppTextField(
                          title: locale.value.password,
                          textStyle: primaryTextStyle(size: 12),
                          controller: signUpController.passwordCont,
                          focus: signUpController.passwordFocus,
                          nextFocus: signUpController.mobileFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          decoration: inputDecoration(
                            context,
                            fillColor: context.cardColor,
                            filled: true,
                            hintText: "${locale.value.eG} #123@156",
                          ),
                          suffixPasswordVisibleWidget: commonLeadingWid(
                                  imgPath: Assets.iconsIcEye,
                                  icon: Icons.password_outlined,
                                  size: 14)
                              .paddingAll(12),
                          suffixPasswordInvisibleWidget: commonLeadingWid(
                                  imgPath: Assets.iconsIcEyeSlash,
                                  icon: Icons.password_outlined,
                                  size: 14)
                              .paddingAll(12),
                        ),
                        16.height,
                        Text(locale.value.contactNumber,
                            style: primaryTextStyle()),
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

                            /// Mobile number text field...
                            AppTextField(
                              textFieldType: isAndroid
                                  ? TextFieldType.PHONE
                                  : TextFieldType.NAME,
                              controller: signUpController.mobileCont,
                              focus: signUpController.mobileFocus,
                              isValidationRequired: false,
                              maxLength: 15,
                              suffix: Assets.iconsIcCall
                                  .iconImage(fit: BoxFit.contain)
                                  .paddingAll(14),
                              buildCounter: (context,
                                      {required currentLength,
                                      required isFocused,
                                      required maxLength}) =>
                                  Offstage(),
                              decoration: inputDecoration(
                                context,
                                hintText: "${locale.value.eG}  1-2188219848",
                                fillColor: context.cardColor,
                                filled: true,
                              ),
                            ).expand(),
                          ],
                        ),
                        16.height,
                        Obx(
                          () => CheckboxListTile(
                            checkColor: whiteColor,
                            value: signUpController.isAcceptedTc.value,
                            activeColor: primaryColor,
                            visualDensity: VisualDensity.compact,
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: EdgeInsets.zero,
                            onChanged: (val) async {
                              signUpController.isAcceptedTc.value =
                                  !signUpController.isAcceptedTc.value;
                            },
                            checkboxShape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5))),
                            side: const BorderSide(
                                color: secondaryTextColor, width: 1.5),
                            title: RichTextWidget(
                              list: [
                                TextSpan(
                                    text: '${locale.value.iAgreeToThe} ',
                                    style: secondaryTextStyle()),
                                TextSpan(
                                  text: locale.value.termsOfService,
                                  style: primaryTextStyle(
                                      color: primaryColor,
                                      size: 12,
                                      decoration: TextDecoration.underline,
                                      decorationColor: primaryColor),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      commonLaunchUrl(TERMS_CONDITION_URL,
                                          launchMode:
                                              LaunchMode.externalApplication);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        16.height,
                        AppButton(
                          width: Get.width,
                          text: locale.value.signUp,
                          textStyle: const TextStyle(
                              fontSize: 14, color: containerColor),
                          onTap: () {
                            if (_signUpformKey.currentState!.validate()) {
                              _signUpformKey.currentState!.save();
                              signUpController.saveForm();
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
                      Text(locale.value.alreadyHaveAnAccount,
                          style: secondaryTextStyle()),
                      4.width,
                      TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            alignment: Alignment.centerLeft),
                        onPressed: () {
                          Get.back();
                          // Get.offUntil(GetPageRoute(page: () => SignInScreen()), (route) => route.isFirst || route.settings.name == '/OptionScreen');
                        },
                        child: Text(
                          locale.value.signIn,
                          style: primaryTextStyle(
                            color: primaryColor,
                            size: 12,
                            decoration: TextDecoration.underline,
                            decorationColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Obx(() => const LoaderWidget()
                .center()
                .visible(signUpController.isLoading.value)),
          ],
        ),
      ),
    );
  }
}
