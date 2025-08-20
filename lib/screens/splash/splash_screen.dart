import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class SplashScreen extends StatelessWidget {
  final SplashScreenController splashController = Get.put(SplashScreenController());
  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    isDarkMode.value
        ? setStatusBarColor(scaffoldDarkColor, statusBarIconBrightness: Brightness.light, statusBarBrightness: Brightness.light)
        : setStatusBarColor(context.scaffoldBackgroundColor, statusBarIconBrightness: Brightness.dark, statusBarBrightness: Brightness.light);
    return AppScaffold(
      hideAppBar: true,
      scaffoldBackgroundColor: isDarkMode.value ? const Color(0xFF0C0910) : const Color(0xFFFCFCFC),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDarkMode.value ? Assets.imagesPawllyLoaderDark : Assets.imagesPawllyLoaderLight,
              height: Constants.appLogoSize,
              width: Constants.appLogoSize,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const AppLogoWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
