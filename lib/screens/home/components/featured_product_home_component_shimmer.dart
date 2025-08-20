import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class FeaturedProductHomeComponentShimmer extends StatelessWidget {
  const FeaturedProductHomeComponentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      direction: Axis.vertical,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ShimmerWidget(
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 8)),
            ShimmerWidget(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 8)),
          ],
        ).paddingOnly(left: 16, right: 16),
        24.height,
        AnimatedWrap(
          runSpacing: 16,
          spacing: 16,
          columnCount: 2,
          itemCount: 6,
          itemBuilder: (p0, p1) {
            return const FeaturedProductItemComponentShimmer();
          },
        ).paddingSymmetric(horizontal: 16)
      ],
    ).paddingTop(16);
  }
}
