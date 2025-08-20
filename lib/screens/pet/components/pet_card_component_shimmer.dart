import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class PetCardComponentShimmer extends StatelessWidget {
  const PetCardComponentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width / 2 - 24,
      decoration: boxDecorationDefault(color: context.cardColor),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ShimmerWidget(
                baseColor: isDarkMode.value
                    ? shimmerDarkBaseColor
                    : shimmerLightBaseColor,
                child: const CircleWidget(height: 74, width: 74),
              ),
              ShimmerWidget(
                baseColor: isDarkMode.value
                    ? shimmerDarkBaseColor
                    : shimmerLightBaseColor,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                  decoration: boxDecorationDefault(),
                ),
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
        ],
      ),
    );
  }
}
