import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class ProductCategoryScreen extends StatelessWidget {
  final ProductCategoryScreenController productCategoryScreenController = Get.put(ProductCategoryScreenController());

  ProductCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.allCategories,
      isLoading: productCategoryScreenController.isLoading,
      body: Obx(
        () => SnapHelperWidget(
          future: productCategoryScreenController.future.value,
          errorBuilder: (error) {
            return NoDataWidget(
              title: error,
              retryText: locale.value.reload,
              imageWidget: const ErrorStateWidget(),
              onRetry: () {
                productCategoryScreenController.page(1);
                productCategoryScreenController.isLoading(true);
                productCategoryScreenController.init();
              },
            ).paddingSymmetric(horizontal: 16);
          },
          loadingWidget: const LoaderWidget(),
          onSuccess: (category) {
            if (category.isEmpty) {
              return NoDataWidget(
                title: locale.value.noCategoryFound,
                retryText: locale.value.reload,
                onRetry: () {
                  productCategoryScreenController.page(1);
                  productCategoryScreenController.isLoading(true);
                  productCategoryScreenController.init();
                },
              );
            }
            return AnimatedScrollView(
              onSwipeRefresh: () async {
                productCategoryScreenController.page(1);
                return await productCategoryScreenController.init();
              },
              physics: const AlwaysScrollableScrollPhysics(),
              listAnimationType: ListAnimationType.Scale,
              padding: const EdgeInsets.all(16),
              onNextPage: () {
                if (!productCategoryScreenController.isLastPage.value) {
                  productCategoryScreenController.page(productCategoryScreenController.page.value + 1);
                  productCategoryScreenController.init();
                }
              },
              children: [
                AnimatedWrap(
                  runSpacing: 16,
                  spacing: 16,
                  itemCount: category.length,
                  listAnimationType: ListAnimationType.Scale,
                  itemBuilder: (_, index) {
                    CategoryData? data = category[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(
                          () => ProductListScreen(
                            title: data.name,
                          ),
                          arguments: ProductStatusModel(
                            productCategoryID: data.id.toString(),
                          ),
                        );
                      },
                      child: CategoryItemComponents(categoryData: data, width: Get.width / 3 - 22),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
