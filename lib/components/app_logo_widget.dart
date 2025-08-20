import '../configs.dart';
import 'package:pawlly/utils/library.dart';

class AppLogoWidget extends StatelessWidget {
  const AppLogoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Constants.appLogoSize,
      width: Constants.appLogoSize,
      alignment: Alignment.center,
      decoration: boxDecorationDefault(
        shape: BoxShape.circle,
        color: primaryColor,
      ),
      child: Text(APP_NAME.toUpperCase(),
          style: boldTextStyle(color: white, letterSpacing: 10)),
    );
  }
}
