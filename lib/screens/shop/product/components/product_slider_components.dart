import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class ProductSlider extends StatelessWidget {
  final List<String> productGallaryData;
  final ProductDetailController productController;

  const ProductSlider({super.key, required this.productController, required this.productGallaryData});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 330,
      child: Stack(
        children: [
          PageView.builder(
            controller: productController.pageController,
            reverse: false,
            itemCount: productGallaryData.length,
            itemBuilder: (_, i) {
              return CachedImageWidget(url: productGallaryData[i].toString(), height: 330, width: Get.width, fit: BoxFit.cover).onTap(() {
                if (productGallaryData.isNotEmpty) {
                  ZoomImageScreen(
                    galleryImages: productGallaryData.map((e) => e).toList(),
                    index: 0,
                  ).launch(context);
                }
              });
            },
          ),
          Positioned(
            bottom: 8,
            width: Get.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Blur(
                  blur: 8,
                  color: primaryColor.withOpacity(0.2),
                  height: 16,
                  borderRadius: radius(16),
                  child: DotIndicator(
                    pageController: productController.pageController,
                    pages: productGallaryData,
                    indicatorColor: primaryColor,
                    unselectedIndicatorColor: primaryColor.withOpacity(0.6),
                    currentBoxShape: BoxShape.rectangle,
                    boxShape: BoxShape.rectangle,
                    currentBorderRadius: radius(8),
                    borderRadius: radius(8),
                    currentDotSize: 26,
                    currentDotWidth: 6,
                    dotSize: 8,
                  ),
                ),
              ],
            ),
          ).visible(productGallaryData.length >= 2),
        ],
      ),
    );
  }
}
