import 'package:pawlly/utils/library.dart';

class GreetingsComponentShimmer extends StatelessWidget {
  const GreetingsComponentShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            const ShimmerWidget(
                padding: EdgeInsets.symmetric(horizontal: 108, vertical: 8)),
            4.height,
            const ShimmerWidget(
                padding: EdgeInsets.symmetric(horizontal: 108, vertical: 8)),
          ],
        ),
        ShimmerWidget(
          baseColor: shimmerLightBaseColor,
          child: const CircleWidget(height: 36, width: 36),
        )
      ],
    ).paddingSymmetric(horizontal: 16, vertical: 16).paddingTop(32);
  }
}
