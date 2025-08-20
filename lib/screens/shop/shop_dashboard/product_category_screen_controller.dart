import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class ProductCategoryScreenController extends GetxController {
  Rx<Future<List<CategoryData>>> future = Future(() => <CategoryData>[]).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxList<CategoryData> categoryList = RxList();
  RxInt page = 1.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    await future(DashboardShopApi.getCategory(
      page: page.value,
      category: categoryList,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    ).whenComplete(
      () => isLoading(false),
    ));
  }
}
