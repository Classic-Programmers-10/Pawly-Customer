import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class OrderReviewComponent extends StatelessWidget {
  final String? deliveryStatus;
  final CartListData productData;

  const OrderReviewComponent(
      {super.key, this.deliveryStatus, required this.productData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (deliveryStatus == OrderStatusConst.DELIVERED)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!productData.productReviewData.id
                  .validate(value: -1)
                  .isNegative)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    16.height,
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: boxDecorationDefault(
                          color: context.cardColor,
                          border: Border.all(color: context.dividerColor)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(locale.value.yourReview,
                                  style: primaryTextStyle(size: 14)),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  try {
                                    final OrderDetailController
                                        orderDetailController = Get.find();
                                    orderDetailController
                                        .selectedOrderData(productData);
                                    orderDetailController.selectedRating(
                                        productData.productReviewData.rating
                                            .validate()
                                            .toDouble());
                                    orderDetailController.reviewCont.text =
                                        productData.productReviewData.reviewMsg
                                            .validate();
                                    showInDialog(
                                      context,
                                      contentPadding: EdgeInsets.zero,
                                      builder: (p0) {
                                        return ProductReviewDialog(false);
                                      },
                                    );
                                  } catch (e) {
                                    toast(e.toString(), print: true);
                                  }
                                },
                                child: TextIcon(
                                  text: locale.value.edit,
                                  textStyle: secondaryTextStyle(),
                                  prefix: commonLeadingWid(
                                      imgPath: Assets.iconsIcEditReview,
                                      icon: Icons.edit_outlined,
                                      size: 15),
                                  edgeInsets: EdgeInsets.zero,
                                ),
                              ),
                              16.width,
                              GestureDetector(
                                onTap: () {
                                  showConfirmDialogCustom(
                                    context,
                                    title: locale.value.deleteReview,
                                    subTitle:
                                        locale.value.doYouWantToDeleteReview,
                                    positiveText: locale.value.yes,
                                    negativeText: locale.value.no,
                                    dialogType: DialogType.DELETE,
                                    onAccept: (p0) async {
                                      try {
                                        final OrderDetailController
                                            orderDetailController = Get.find();
                                        orderDetailController
                                            .selectedOrderData(productData);

                                        orderDetailController
                                            .deleteOrderReview();
                                      } catch (e) {
                                        toast(e.toString(), print: true);
                                      }
                                    },
                                  );
                                },
                                child: TextIcon(
                                  text: locale.value.delete,
                                  textStyle: secondaryTextStyle(
                                      color: cancelStatusColor),
                                  prefix: commonLeadingWid(
                                      imgPath: Assets.iconsIcDelete,
                                      icon: Icons.delete,
                                      color: cancelStatusColor,
                                      size: 15),
                                  edgeInsets: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                          8.height,
                          Row(
                            children: [
                              Icon(Icons.star,
                                  size: 14,
                                  color: getRatingBarColor(productData
                                      .productReviewData.rating
                                      .validate()
                                      .toInt())),
                              4.width,
                              Text(
                                productData.productReviewData.rating
                                    .validate()
                                    .toStringAsFixed(1)
                                    .toString(),
                                style: primaryTextStyle(
                                    color: getRatingBarColor(productData
                                        .productReviewData.rating
                                        .validate()
                                        .toInt()),
                                    size: 14,
                                    fontFamily: fontFamilyFontWeight600),
                              ),
                            ],
                          ),
                          if (productData.productReviewData.reviewMsg
                              .validate()
                              .isNotEmpty)
                            Text(
                              productData.productReviewData.reviewMsg!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: secondaryTextStyle(),
                            ).paddingTop(6),
                        ],
                      ),
                    ),
                    AnimatedWrap(
                      spacing: 10,
                      runSpacing: 10,
                      itemCount: productData.productReviewData.gallery
                          .validate()
                          .take(3)
                          .length,
                      itemBuilder: (ctx, index) {
                        ReviewGallaryData galleryData = productData
                            .productReviewData.gallery
                            .validate()[index];

                        return CachedImageWidget(
                          url: galleryData.fullUrl.validate(),
                          width: 45,
                          height: 45,
                          fit: BoxFit.cover,
                          radius: defaultRadius,
                        ).onTap(() {
                          if (galleryData.fullUrl.validate().isNotEmpty) {
                            ZoomImageScreen(
                              galleryImages: productData
                                  .productReviewData.gallery
                                  .validate()
                                  .map((e) => e.fullUrl.validate())
                                  .toList(),
                              index: index,
                            ).launch(context);
                          }
                        });
                      },
                    ),
                  ],
                )
              else
                AppButton(
                  width: Get.width,
                  text: locale.value.addReview,
                  textStyle: appButtonTextStyleWhite,
                  onTap: () async {
                    try {
                      final OrderDetailController orderDetailController =
                          Get.find();
                      orderDetailController.selectedOrderData(productData);
                      orderDetailController.selectedRating(0);
                      orderDetailController.reviewCont.clear();
                      orderDetailController.pickedFile = RxList();
                      showInDialog(
                        context,
                        contentPadding: EdgeInsets.zero,
                        builder: (p0) {
                          return ProductReviewDialog(true);
                        },
                      );
                    } catch (e) {
                      toast(e.toString(), print: true);
                    }
                  },
                ).paddingOnly(top: 16),
              8.height,
            ],
          ),
      ],
    );
  }
}
