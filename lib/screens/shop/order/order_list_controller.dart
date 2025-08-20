import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
class OrderListController extends GetxController with GetSingleTickerProviderStateMixin {
  Rx<Future<List<CartListData>>> orderListFuture = Future(() => <CartListData>[]).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt page = 1.obs;
  List<CartListData> orders = [];
  TextEditingController searchCont = TextEditingController();
  RxList<OrderStatusData> statusList = RxList();
  RxList<OrderStatusData> statusFilterList = RxList();
  RxSet<String> selectedIndex = RxSet();
  RxBool isSearchText = false.obs;

  @override
  void onInit() {
    getOrderList(showLoader: false);
    super.onInit();
  }

  getOrderList({bool showLoader = true}) {
    if (showLoader) {
      isLoading(true);
    }
    orderListFuture(OrderApis.getOrderList(
      filterByStatus: selectedIndex.join(","),
      page: page.value,
      orders: orders,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  updateDeliveryStatus({required int orderId, required String status, VoidCallback? onUpdateDeliveryStatus}) async {
    isLoading(true);
    hideKeyBoardWithoutContext();

    Map<String, dynamic> req = {
      "order_id": orderId,
      "status": status,
    };

    await OrderApis.updateDeliveryStatus(request: req).then((value) {
      if (onUpdateDeliveryStatus != null) {
        onUpdateDeliveryStatus.call();
        toast(locale.value.theOrderHasBeen);
      }
      try {
        HomeScreenController hCont = Get.find();
        hCont.init();
      } catch (e) {
        log('onItemSelected Err: $e');
      }
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    });
  }
}
