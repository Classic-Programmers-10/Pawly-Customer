import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class QtyComponents extends StatelessWidget {
  final ProductDetailController productController;

  const QtyComponents({super.key, required this.productController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        8.height,
        ViewAllLabel(label: locale.value.quantity, isShowAll: false).paddingSymmetric(horizontal: 16),
        Container(
          decoration: boxDecorationDefault(color: context.cardColor, shape: BoxShape.rectangle),
          width: Get.width * 0.35,
          height: 40,
          child: Obx(
            () => Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (productController.qtyCount.value > 1) {
                      productController.qtyCount.value--;
                    }
                  },
                  icon: Icon(Icons.remove, color: isDarkMode.value ? Colors.white : iconColor, size: 15),
                ),
                Text(
                  '${productController.qtyCount}',
                  style: primaryTextStyle(size: 12),
                ),
                IconButton(
                  onPressed: () {
                    if (productController.qtyCount.value < productController.selectedVariationData.value.productStockQty) {
                      productController.qtyCount.value++;
                    } else {
                      Fluttertoast.cancel();
                      toast("${locale.value.outOfStock}!!!");
                    }
                  },
                  icon: Icon(Icons.add, color: isDarkMode.value ? Colors.white : iconColor, size: 15),
                ),
              ],
            ),
          ),
        ).paddingSymmetric(horizontal: 16),
      ],
    );
  }
}
