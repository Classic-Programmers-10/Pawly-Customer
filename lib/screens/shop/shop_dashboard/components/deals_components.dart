import 'package:get/get.dart';
import '../model/product_list_response.dart';
import 'package:pawlly/utils/library.dart';
class DealsComponents extends StatelessWidget {
  final List<ProductItemData> discountProductList;

  DealsComponents({super.key, required this.discountProductList});

  final ShopDashboardController shopDashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    if (discountProductList.isEmpty) return const Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: locale.value.dealsForYou,
          onTap: () {
            hideKeyboard(context);
            Get.to(() => ProductListScreen(title: locale.value.dealsForYou), arguments: ProductStatusModel(isDeal: "1"));
          },
        ).paddingOnly(left: 16, right: 8),
        8.height,
        HorizontalList(
          itemCount: discountProductList.length,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 30),
          crossAxisAlignment: WrapCrossAlignment.start,
          itemBuilder: (context, i) {
            return ProductItemComponents(productListData: discountProductList[i]).paddingRight(8);
          },
        )
      ],
    );
  }
}
