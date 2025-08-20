import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class DashboardCategoryComponents extends StatelessWidget {
  final List<CategoryData> productCategoryList;

  DashboardCategoryComponents({super.key, required this.productCategoryList});

  final ShopDashboardController shopDashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (productCategoryList.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: NoDataWidget(
          title: locale.value.noCategoryFound,
          imageWidget: const EmptyStateWidget(),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.value.category,
          list: productCategoryList,
          onTap: () {
            hideKeyboard(context);
            Get.to(() => ProductCategoryScreen())?.then((value) {
              setStatusBarColor(Colors.transparent);
            });
          },
        ).paddingOnly(left: 16, right: 8),
        8.height,
        AnimatedWrap(
          runSpacing: 16,
          spacing: 16,
          columnCount: 2,
          itemCount: productCategoryList.take(6).length,
          listAnimationType: ListAnimationType.FadeIn,
          itemBuilder: (_, index) {
            CategoryData data = productCategoryList[index];
            return GestureDetector(
              onTap: () {
                hideKeyboard(context);
                Get.to(() => ProductListScreen(title: data.name),
                    arguments: ProductStatusModel(
                        productCategoryID: data.id.toString()));
              },
              child: CategoryItemComponents(
                  categoryData: data, width: Get.width / 3 - 22),
            );
          },
        ).paddingOnly(top: 10, left: 16, right: 16, bottom: 16)
      ],
    );
  }
}
