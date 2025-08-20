import 'package:get/get.dart';
import '../model/product_list_response.dart';
import 'package:pawlly/utils/library.dart';
class ProductItemComponents extends StatelessWidget {
  final ProductItemData productListData;
  final bool isFromWishList;

  ProductItemComponents({super.key, required this.productListData, this.isFromWishList = false});

  final ShopDashboardController shopDashboardController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        hideKeyboard(context);

        /// Clear search when redirect to other screen
        if (shopDashboardController.pCont.searchCont.text.trim().isNotEmpty) {
          shopDashboardController.pCont.searchCont.clear();
          shopDashboardController.pCont.isSearchText(shopDashboardController.pCont.searchCont.text.trim().isNotEmpty);
          shopDashboardController.pCont.handleSearch();
        }

        final isAddedToWishList = await Get.to(() => ProductDetail(), arguments: isFromWishList ? productListData.productId : productListData.id);
        if (isAddedToWishList is bool) {
          productListData.inWishlist(isAddedToWishList);
        }
      },
      child: Container(
        width: Get.width / 2 - 24,
        decoration: boxDecorationDefault(
          color: context.cardColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius),
                  child: CachedImageWidget(
                    url: productListData.productImage,
                    width: Get.width,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Obx(
                        () => Container(
                      padding: const EdgeInsets.all(4),
                      decoration: boxDecorationWithShadow(
                        boxShape: BoxShape.rectangle,
                        backgroundColor: secondaryColor,
                        borderRadius: radiusOnly(topLeft: defaultRadius, bottomRight: 8),
                      ),
                      child: Marquee(child: Text(locale.value.outOfStock, style: boldTextStyle(size: 10, color: Colors.white))),
                    ).visible(productListData.stockQty == 0),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Obx(() {
                    return GestureDetector(
                      onTap: () {

                        if ((isFromWishList ? Get.find<WishlistController>().isLoading.value : shopDashboardController.isLoading.value)) {
                          return;
                        }

                        if (isFromWishList) {
                          try {
                            WishlistController wLCont = Get.find();
                            doIfLoggedIn(context, () async {
                              wLCont.isLoading(true);
                              WishListApis.onTapFavourite(favdata: productListData).whenComplete(() => wLCont.isLoading(false));
                            });
                          } catch (e) {
                            log('wLCont = Get.find(); E: $e');
                          }
                        } else {
                          doIfLoggedIn(context, () async {
                            shopDashboardController.isLoading(true);
                            WishListApis.onTapFavourite(favdata: productListData).whenComplete(() => shopDashboardController.isLoading(false));
                          });
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: boxDecorationWithShadow(
                          boxShape: BoxShape.circle,
                          backgroundColor: context.cardColor,
                        ),
                        child: productListData.inWishlist.value
                            ? const Icon(Icons.favorite, size: 15, color: redColor)
                            : Icon(
                          Icons.favorite,
                          size: 15,
                          color: textSecondaryColorGlobal,
                        ),
                      ),
                    );
                  }),
                ),

              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(isFromWishList ? productListData.productName : productListData.name, style: primaryTextStyle(size: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                6.height,
                Marquee(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (productListData.isDiscount) PriceWidget(price: productListData.variationData.validate().first.discountedProductPrice),
                      if (productListData.isDiscount) 4.width,
                      PriceWidget(
                        price: productListData.variationData.first.taxIncludeProductPrice,
                        isLineThroughEnabled: productListData.isDiscount ? true : false,
                        isBoldText: productListData.isDiscount ? false : true,
                        size: productListData.isDiscount ? 12 : 16,
                        color: productListData.isDiscount ? textSecondaryColorGlobal : null,
                      ).visible(productListData.variationData.isNotEmpty),
                    ],
                  ),
                ),
                Marquee(
                  child: Row(
                    children: [
                      Text(
                        '${locale.value.soldBy}: ',
                        style: secondaryTextStyle(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        productListData.soldBy,
                        style: primaryTextStyle(fontFamily: fontFamilyFontWeight600, size: 12, color: secondaryColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ).paddingOnly(top: 6).visible(productListData.soldBy.isNotEmpty && !(productListData.soldBy == UNKNOWN)),
                6.height,
              ],
            ).paddingAll(16),
          ],
        ),
      ),
    );
  }
}
