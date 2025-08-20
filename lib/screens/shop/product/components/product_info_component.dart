import 'package:get/get.dart';
import '../../shop_dashboard/model/product_list_response.dart';
import 'package:pawlly/utils/library.dart';
class ProductInfoComponent extends StatelessWidget {
  final ProductItemData productData;
  final ProductDetailController productController;

  const ProductInfoComponent({super.key, required this.productController, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(productData.name, style: primaryTextStyle(fontFamily: fontFamilyFontWeight600, size: 15)),
            if (productData.shortDescription.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  6.height,
                  Text(productData.shortDescription, style: secondaryTextStyle()),
                ],
              ),
            if (productData.brandName.isNotEmpty)
              Row(
                children: [
                  Text(
                    '${locale.value.brand}: ',
                    style: secondaryTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(productData.brandName, style: primaryTextStyle(fontFamily: fontFamilyFontWeight600, size: 12, color: secondaryColor)),
                ],
              ).paddingOnly(top: 6),
            Row(
              children: [
                Row(
                  children: [
                    Text(
                      '${locale.value.soldBy}: ',
                      style: secondaryTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      productData.soldBy,
                      style: primaryTextStyle(fontFamily: fontFamilyFontWeight600, size: 12, color: primaryColor),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ).expand(),
                  ],
                ).paddingRight(16).expand().visible(productData.soldBy.isNotEmpty && !(productData.soldBy == UNKNOWN)),
                if (productController.selectedVariationData.value.isStockAvaible.validate() != 1)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: boxDecorationDefault(border: Border.all(color: Colors.red), borderRadius: radius(4)),
                    child: Text(
                      locale.value.outOfStock,
                      style: primaryTextStyle(color: cancelStatusColor),
                    ),
                  ),
              ],
            ).paddingOnly(top: 6),
            16.height,
            Obx(
              () => Row(
                children: [
                  PriceWidget(
                    price: productController.selectedVariationData.value.taxIncludeProductPrice,
                    isLineThroughEnabled: productData.isDiscount ? true : false,
                    isBoldText: productData.isDiscount ? false : true,
                    size: productData.isDiscount ? 14 : 16,
                    color: productData.isDiscount ? textSecondaryColorGlobal : null,
                  ),
                  if (productData.isDiscount)
                    Row(
                      children: [
                        PriceWidget(
                          price: productController.selectedVariationData.value.discountedProductPrice,
                        ).paddingLeft(4),
                        if (productData.discountType == TaxType.PERCENT)
                          Text(
                            '${productData.discountValue}%  ${locale.value.off}',
                            style: primaryTextStyle(color: greenColor),
                          ).paddingLeft(8)
                        else if (productData.discountType == TaxType.FIXED)
                          PriceWidget(
                            price: productData.discountValue,
                            color: greenColor,
                            size: 14,
                            isBoldText: false,
                            isDiscountedPrice: true,
                          ).paddingLeft(4),
                      ],
                    ),
                ],
              ),
            ),
            12.height,
            Row(
              children: [
                RatingBarWidget(
                  onRatingChanged: (rating) {},
                  disable: true,
                  activeColor: getRatingBarColor(productData.rating.toInt()),
                  inActiveColor: ratingBarColor,
                  rating: productData.rating.toDouble(),
                  size: 18,
                ),
                if (productData.rating != 0) 8.width,
                if (productData.rating != 0) Text('${productData.rating.toString()}  ${locale.value.ratings}', style: primaryTextStyle()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
