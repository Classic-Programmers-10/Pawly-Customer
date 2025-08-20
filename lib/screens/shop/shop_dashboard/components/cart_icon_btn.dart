import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class CartIconBtn extends StatelessWidget {
  final bool showBGCardColor;
  final ShopDashboardController? shopDashboardController;

  const CartIconBtn({super.key, this.showBGCardColor = false, this.shopDashboardController});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: showBGCardColor ? 42 : null,
        decoration: showBGCardColor ? boxDecorationWithShadow(boxShape: BoxShape.circle, backgroundColor: cardColor) : null,
        child: Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: switchColor, size: 25),
              onPressed: () {
                hideKeyboard(context);

                /// Clear search when redirect to other screen
                if (shopDashboardController != null) {
                  if (shopDashboardController!.pCont.searchCont.text.trim().isNotEmpty) {
                    shopDashboardController?.pCont.searchCont.clear();
                    shopDashboardController?.pCont.isSearchText(shopDashboardController?.pCont.searchCont.text.trim().isNotEmpty);
                    shopDashboardController?.pCont.handleSearch();
                  }
                }

                doIfLoggedIn(context, () {
                  Get.to(() => CartScreen());
                });
              },
            ).paddingRight(cartItemCount.value > 0 ? 5 : 0),
            Positioned(
              top: cartItemCount.value < 10 ? 0 : 4,
              right: cartItemCount.value < 10 ? 12 : 10,
              child: Obx(() => Container(
                    padding: const EdgeInsets.all(4),
                    decoration: boxDecorationDefault(color: primaryColor, shape: BoxShape.circle),
                    child: Text(
                      '${cartItemCount.value}',
                      style: primaryTextStyle(size: cartItemCount.value < 10 ? 12 : 8, color: white),
                    ),
                  ).visible(cartItemCount.value > 0)),
            ),
          ],
        ),
      ),
    );
  }
}
