import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class ServiceCardShimmer extends StatelessWidget {
  final double width;
  final double height;

  const ServiceCardShimmer({
    super.key,
    this.width = 130,
    this.height = 130,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerWidget(
                  baseColor: isDarkMode.value
                      ? shimmerDarkBaseColor
                      : shimmerLightBaseColor,
                  child: const CircleWidget(height: 64, width: 64),
                ),
                ShimmerWidget(
                  baseColor: isDarkMode.value
                      ? shimmerDarkBaseColor
                      : shimmerLightBaseColor,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                    decoration: boxDecorationDefault(),
                  ),
                )
              ],
            ).paddingSymmetric(horizontal: 16, vertical: 16),
          ),
        ],
      ),
    );
  }
}
