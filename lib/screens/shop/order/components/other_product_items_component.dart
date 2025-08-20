import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class OtherProductItemsComponent extends StatelessWidget {
  final List<OtherOrderItems> otherProductItemList;

  const OtherProductItemsComponent(
      {super.key, required this.otherProductItemList});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.otherItemsInProduct, style: primaryTextStyle()),
        8.height,
        AnimatedWrap(
          runSpacing: 16,
          itemCount: otherProductItemList.length,
          itemBuilder: (context, index) {
            OtherOrderItems otherItemsData = otherProductItemList[index];

            return GestureDetector(
              onTap: () {
                Get.to(() => ProductDetail(),
                    arguments: otherItemsData.productDetails.productId);
              },
              child: Container(
                decoration: boxDecorationDefault(color: context.cardColor),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedImageWidget(
                          url: otherItemsData.productDetails.productImage,
                          height: 75,
                          width: 75,
                          fit: BoxFit.cover,
                          radius: defaultRadius,
                        ),
                        12.width,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(otherItemsData.productDetails.productName,
                                style: primaryTextStyle(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            Row(
                              children: [
                                Text(
                                  '${locale.value.soldBy} : ',
                                  style: secondaryTextStyle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  otherItemsData.productDetails.soldBy,
                                  style: primaryTextStyle(
                                      fontFamily: fontFamilyFontWeight600,
                                      size: 12,
                                      color: primaryColor),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ).visible(otherItemsData
                                    .productDetails.soldBy.isNotEmpty &&
                                !(otherItemsData.productDetails.soldBy ==
                                    UNKNOWN)),
                            if (otherItemsData
                                .productDetails.productVariationType.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                      '${otherItemsData.productDetails.productVariationType} : ',
                                      style: secondaryTextStyle()),
                                  Text(
                                      otherItemsData
                                          .productDetails.productVariationName,
                                      style: primaryTextStyle(
                                          size: 12,
                                          color: textPrimaryColorGlobal,
                                          fontFamily: fontFamilyFontWeight600)),
                                ],
                              ),
                            Row(
                              children: [
                                Text('${locale.value.qty} : ',
                                    style: secondaryTextStyle()),
                                Text(
                                    otherItemsData.productDetails.qty
                                        .toString(),
                                    style: primaryTextStyle(
                                        size: 12,
                                        color: textPrimaryColorGlobal,
                                        fontFamily: fontFamilyFontWeight600)),
                              ],
                            ),
                            PriceWidget(
                                price:
                                    otherItemsData.productDetails.totalAmount,
                                size: 12),
                          ],
                        ).expand(),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
