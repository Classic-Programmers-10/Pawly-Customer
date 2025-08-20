import 'package:pawlly/utils/library.dart';

class OrderInformationComponent extends StatelessWidget {
  final OrderListData orderData;

  const OrderInformationComponent({super.key, required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.value.orderDetail, style: primaryTextStyle()),
        8.height,
        Container(
          decoration: boxDecorationDefault(color: context.cardColor),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              16.height,
              detailWidget(
                title: locale.value.orderDate,
                value: orderData.orderingDate,
                textStyle: primaryTextStyle(
                  size: 12,
                  color: textPrimaryColorGlobal,
                  fontFamily: fontFamilyFontWeight600,
                ),
              ),
              detailWidget(
                title: locale.value.expectedOn,
                value: orderData
                        .orderDetails.productDetails.deliveredDate.isNotEmpty
                    ? orderData.orderDetails.productDetails.deliveredDate
                        .dateInDMMMyyyyFormat
                    : orderData.orderDetails.productDetails.deliveringDate,
                textStyle: primaryTextStyle(
                  size: 12,
                  color: textPrimaryColorGlobal,
                  fontFamily: fontFamilyFontWeight600,
                ),
              ),
              detailWidget(
                title: locale.value.paymentMethod,
                value: orderData.paymentMethod.capitalizeFirstLetter(),
                textStyle: primaryTextStyle(
                  size: 12,
                  color: textPrimaryColorGlobal,
                  fontFamily: fontFamilyFontWeight600,
                ),
              ),
              detailWidget(
                title: locale.value.deliveryStatus,
                value: getOrderStatus(status: orderData.deliveryStatus),
                textStyle: primaryTextStyle(
                  size: 12,
                  color: getOrderStatusColor(status: orderData.deliveryStatus),
                  fontFamily: fontFamilyFontWeight600,
                ),
              ),
              6.height,
            ],
          ),
        ),
        16.height,
      ],
    );
  }
}
