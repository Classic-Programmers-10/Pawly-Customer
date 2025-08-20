import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class EventItemComponentShimmer extends StatelessWidget {
  final double? width;

  const EventItemComponentShimmer({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ShimmerWidget(
          baseColor: shimmerLightBaseColor,
          child: Container(
            width: width ?? Get.width - 32,
            height: 300,
            decoration: BoxDecoration(
                color: context.cardColor, borderRadius: radius(8)),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        ShimmerWidget(
                          baseColor: shimmerLightBaseColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 8),
                            decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: radius(8)),
                          ),
                        ),
                        ShimmerWidget(
                          baseColor: shimmerLightBaseColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 8),
                            decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: radius(8)),
                          ),
                        ).paddingTop(8)
                      ],
                    ),
                    ShimmerWidget(
                      baseColor: shimmerLightBaseColor,
                      child: VerticalDivider(color: shimmerLightBaseColor),
                    ),
                    Column(
                      children: [
                        ShimmerWidget(
                          baseColor: shimmerLightBaseColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 8),
                            decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: radius(8)),
                          ),
                        ),
                        ShimmerWidget(
                          baseColor: shimmerLightBaseColor,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 8),
                            decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: radius(8)),
                          ),
                        ),
                        ShimmerWidget(
                          baseColor: shimmerLightBaseColor,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 36, vertical: 8),
                            decoration: BoxDecoration(
                                color: context.cardColor,
                                borderRadius: radius(8)),
                          ),
                        )
                      ],
                    ).expand()
                  ],
                ),
              ),
              ShimmerWidget(
                baseColor: shimmerLightBaseColor,
                child: Container(
                  width: Get.width - 32,
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  decoration: BoxDecoration(
                      color: context.cardColor, borderRadius: radius(8)),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
