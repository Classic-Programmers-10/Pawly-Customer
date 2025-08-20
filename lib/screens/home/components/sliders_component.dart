import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class SlidersComponent extends StatefulWidget {
  const SlidersComponent({super.key});

  @override
  State<SlidersComponent> createState() => _SlidersComponentState();
}

class _SlidersComponentState extends State<SlidersComponent> {
  final HomeScreenController dashboardController = Get.find();
  PageController pageController =
      PageController(keepPage: true, initialPage: 0);
  int currentPage = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    if (getBoolAsync(SharedPreferenceConst.AUTO_SLIDER_STATUS,
            defaultValue: true) &&
        dashboardController.dashboardData.value.slider.length >= 2) {
      timer = Timer.periodic(
          const Duration(seconds: DASHBOARD_AUTO_SLIDER_SECOND), (Timer timer) {
        if (currentPage <
            dashboardController.dashboardData.value.slider.length - 1) {
          currentPage++;
        } else {
          currentPage = 0;
        }
        pageController.animateToPage(currentPage,
            duration: const Duration(milliseconds: 950),
            curve: Curves.easeOutQuart);
      });

      pageController.addListener(() {
        currentPage = pageController.page!.toInt();
      });
    }
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (dashboardController.dashboardData.value.slider.isEmpty)
      return const Offstage();

    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            reverse: false,
            itemCount: dashboardController.dashboardData.value.slider.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (dashboardController
                      .dashboardData.value.slider[index].link.isURL) {
                    commonLaunchUrl(
                        dashboardController
                            .dashboardData.value.slider[index].link,
                        launchMode: LaunchMode.externalApplication);
                  }
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  color: Colors.transparent,
                  width: Get.width,
                  child: CachedImageWidget(
                    url: dashboardController
                        .dashboardData.value.slider[index].sliderImage,
                    fit: BoxFit.fitWidth,
                    usePlaceholderIfUrlEmpty: false,
                    width: Get.width,
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 28,
            left: 16,
            child: DotIndicator(
              pageController: pageController,
              pages: dashboardController.dashboardData.value.slider,
              indicatorColor: containerColor,
              unselectedIndicatorColor: lightPrimaryColor,
              currentDotSize: 26,
              dotSize: 6,
              boxShape: BoxShape.rectangle,
              currentBoxShape: BoxShape.rectangle,
              currentBorderRadius: radius(8),
              borderRadius: radius(8),
              currentDotWidth: 8,
            ),
          ),
        ],
      ),
    );
  }
}
