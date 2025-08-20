import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class DashboardFeaturedComponentsShimmer extends StatelessWidget {
  const DashboardFeaturedComponentsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 16),
      width: Get.width,
      decoration: BoxDecoration(color: isDarkMode.value ? whiteColor.withOpacity(0.1) : lightPrimaryColor2),
      child: Wrap(
        direction: Axis.vertical,
        children: [
          SizedBox(
            width: Get.width,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget(padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8)),
                ShimmerWidget(padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8)),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
          24.height,
          HorizontalList(
            runSpacing: 16,
            spacing: 16,
            wrapAlignment: WrapAlignment.start,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: 4,
            itemBuilder: (context, index) {
              return const FeaturedProductItemComponentShimmer();
            },
          )
        ],
      ).paddingSymmetric(vertical: 16),
    );
  }
}
