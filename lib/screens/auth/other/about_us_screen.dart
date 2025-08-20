import 'package:pawlly/utils/library.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.aboutApp,
      body: Column(
        children: [
          ListView.separated(
            itemCount: aboutPages.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (aboutPages[index].name.isEmpty ||
                  aboutPages[index].url.isEmpty) {
                return const SizedBox();
              } else {
                return SettingItemWidget(
                  title: aboutPages[index].name,
                  onTap: () {
                    commonLaunchUrl(aboutPages[index].url.trim(),
                        launchMode: LaunchMode.externalApplication);
                  },
                  titleTextStyle: primaryTextStyle(),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  // leading: commonLeadingWid(imgPath: Assets.iconsIcLock, icon: Icons.lock_outline_sharp, color: primaryColor),
                );
              }
            },
            separatorBuilder: (context, index) => commonDivider,
          ),
        ],
      ),
    );
  }
}
