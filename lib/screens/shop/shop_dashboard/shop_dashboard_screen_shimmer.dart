import 'package:pawlly/utils/library.dart';
class ShopDashboardScreenShimmer extends StatelessWidget {
  final bool isSearch;
  const ShopDashboardScreenShimmer({Key? key, this.isSearch = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isSearch) {
      return buildSearchShopHomeComponentShimmer();
    } else {
      return buildShopHomeComponentShimmer();
    }
  }

  Widget buildShopHomeComponentShimmer() {
    return AnimatedScrollView(
      listAnimationType: ListAnimationType.FadeIn,
      padding: const EdgeInsets.only(bottom: 20),
      children: [
        16.height,
        const DashboardCategoryComponentsShimmer(showLabel: true),
        36.height,
        const DashboardFeaturedComponentsShimmer(),
        16.height,
        const BestSellerComponentsShimmer(),
        16.height,
      ],
    );
  }

  Widget buildSearchShopHomeComponentShimmer() {
    return Container();
  }
}
