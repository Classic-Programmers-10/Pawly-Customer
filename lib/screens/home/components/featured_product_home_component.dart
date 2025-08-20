import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class FeaturedProductsHomeComponent extends StatelessWidget {
  FeaturedProductsHomeComponent({super.key});

  final HomeScreenController homeScreenController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          ViewAllLabel(
            label: locale.value.featuredProducts,
            list: homeScreenController.dashboardData.value.featuresProduct,
            onTap: () {
              Get.to(
                  () => ProductListScreen(title: locale.value.featuredProducts),
                  arguments: ProductStatusModel(isFeatured: "1"));
            },
          ).paddingOnly(left: 16, right: 8),
          AnimatedWrap(
            runSpacing: 16,
            spacing: 16,
            columnCount: 2,
            itemCount: homeScreenController.dashboardData.value.featuresProduct
                .take(6)
                .length,
            listAnimationType: ListAnimationType.FadeIn,
            itemBuilder: (_, index) {
              return ProductItemComponents(
                  productListData: homeScreenController
                      .dashboardData.value.featuresProduct[index]);
            },
          ).paddingOnly(top: 10, left: 16, right: 16),
        ],
      ).visible(
          homeScreenController.dashboardData.value.featuresProduct.isNotEmpty),
    );
  }
}
