import 'package:get/get.dart';
import '../shop_dashboard/model/product_list_response.dart';
import 'package:pawlly/utils/library.dart';
class ProductDetailController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController pinCodeCont = TextEditingController();
  RxInt qtyCount = 1.obs;
  Rx<Future<ProductDetailRes>> productDetailsFuture = Future(() => ProductDetailRes(data: ProductItemData(inWishlist: false.obs))).obs;
  Rx<ProductDetailRes> productDetailRes = ProductDetailRes(data: ProductItemData(inWishlist: false.obs)).obs;
  RxList<ProductReviewDataModel> allReviewList = RxList();
  Rx<Future<List<ProductReviewDataModel>>> getreview = Future(() => <ProductReviewDataModel>[]).obs;
  PageController pageController = PageController(keepPage: true, initialPage: 0);
  int page = 1;
  RxBool isLastPage = false.obs;
  Rx<VariationData> selectedVariationData = VariationData(inCart: false.obs).obs;
  RxInt productId = (-1).obs;
  RxBool isAddToCartButtonEnabled = true.obs;
  @override
  void onInit() {
    init();
    super.onInit();
  }

  void init() {
    if (Get.arguments is int) {
      productId(Get.arguments as int);
      getProductDetails(isFromSwipeRefresh: true);
      getReviewList();
    }
  }

  getProductDetails({bool isFromSwipeRefresh = false}) {
    if (!isFromSwipeRefresh) {
      isLoading(true);
    }

    productDetailsFuture(ShopApi.getProductDetails(productId: productId.value)).then((value) {
      productDetailRes(value);
      if (productDetailRes.value.data.variationData.isNotEmpty) {
        selectedVariationData(productDetailRes.value.data.variationData.first);
      }
    }).whenComplete(() => isLoading(false));
  }

  getReviewList() {
    getreview(ShopApi.productAllReviews(
      productId: productId.value,
      page: page,
      list: allReviewList,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    ));
  }

  Future<void> addProductToCart() async {
    isAddToCartButtonEnabled(false);
    isLoading(true);

    Map request = {
      ProductModelKey.productId: productId.value,
      ProductModelKey.productVariationId: selectedVariationData.value.id,
      ProductModelKey.qty: 1,
      ProductModelKey.locationId: 1,
    };

    await ProductCartApi.addToCart(request).then((value) {
      toast(value.message);
      cartItemCount(cartItemCount.value + 1);
      isLoading(false);
      selectedVariationData.value.inCart(true);
      init();
    }).catchError((error) {
      isLoading(false);
      toast(error.toString());
    })
        .whenComplete(() {
      isLoading(false);
      isAddToCartButtonEnabled(true);
    });
  }
}

class DummyController extends GetxController {}
