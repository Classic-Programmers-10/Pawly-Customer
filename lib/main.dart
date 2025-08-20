import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pawlly/locale/language_en.dart';
import 'configs.dart';
import 'firebase_options.dart';
import 'locale/app_localizations.dart';
import 'locale/languages.dart';
import 'utils/local_storage.dart';
import 'package:pawlly/utils/library.dart';
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log('${FirebaseTopicConst.notificationDataKey} : ${message.data}');
  log('${FirebaseTopicConst.notificationKey} : ${message.notification}');
  log('${FirebaseTopicConst.notificationTitleKey} : ${message.notification!.title}');
  log('${FirebaseTopicConst.notificationBodyKey} : ${message.notification!.body}');
}

Rx<BaseLanguage> locale = LanguageEn().obs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    PushNotificationService().setupFirebaseMessaging();
    if (kReleaseMode) FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  }).catchError(onError);
  // locale.value.LanguageList = languageList();

  await GetStorage.init();
  //
  fontFamilyPrimaryGlobal = GoogleFonts.beVietnamPro(fontWeight: FontWeight.w500).fontFamily;
  textPrimarySizeGlobal = 14;
  textPrimaryColorGlobal = primaryTextColor;
  fontFamilySecondaryGlobal = GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400).fontFamily;
  textSecondarySizeGlobal = 12;
  textSecondaryColorGlobal = secondaryTextColor;
  //
  defaultBlurRadius = 0;
  defaultRadius = 12;
  defaultSpreadRadius = 0;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  defaultAppButtonTextColorGlobal = Colors.white;
  passwordLengthGlobal = 8;

  await initialize(aLocaleLanguageList: languageList());

  selectedLanguageCode(getValueFromLocal(SELECTED_LANGUAGE_CODE) ?? DEFAULT_LANGUAGE);
  BaseLanguage temp = await const AppLocalizations().load(Locale(selectedLanguageCode.value));
  locale = temp.obs;
  locale.value = await const AppLocalizations().load(Locale(selectedLanguageCode.value));

  Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
    if (kReleaseMode) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
    }
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RestartAppWidget(
      child: Obx(
        () => GetMaterialApp(
          navigatorKey: navigatorKey,
          title: APP_NAME,
          debugShowCheckedModeBanner: false,
          supportedLocales: LanguageDataModel.languageLocales(),
          localizationsDelegates: const [
            AppLocalizations(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) => Locale(selectedLanguageCode.value),
          fallbackLocale: const Locale(DEFAULT_LANGUAGE),
          locale: Locale(selectedLanguageCode.value),
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
          initialBinding: BindingsBuilder(() {
            isDarkMode.value
                ? setStatusBarColor(scaffoldDarkColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light)
                : setStatusBarColor(context.scaffoldBackgroundColor, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light);
            if (isLoggedIn.value) {
              log('INITIALBINDING: called');
              Get.put<HomeScreenController>(HomeScreenController());
            }
          }),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
