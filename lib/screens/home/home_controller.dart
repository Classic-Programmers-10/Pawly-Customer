import 'package:get/get.dart';
import '../../utils/local_storage.dart';
import '../dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';

class HomeScreenController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isRefresh = false.obs;
  TextEditingController searchCont = TextEditingController();
  Rx<Future<DashboardRes>> getDashboardDetailFuture = Future(() => DashboardRes(
      data: DashboardData(
          upcommingBooking: BookingDataModel(
              service: SystemService(),
              payment: PaymentDetails(),
              training: Training())))).obs;

  Rx<DashboardData> dashboardData = DashboardData(
          upcommingBooking: BookingDataModel(
              service: SystemService(),
              payment: PaymentDetails(),
              training: Training()))
      .obs;

  @override
  void onReady() {
    init();
    super.onReady();
  }

  void init() {
    getDashboardDetail();
  }

  ///Get ChooseService List
  getDashboardDetail({bool isFromSwipRefresh = false}) async {
    if (!isFromSwipRefresh) {
      isLoading(true);
    }
    getAppConfigurations(forceConfigSync: isFromSwipRefresh);
    await getDashboardDetailFuture(HomeServiceApis.getDashboard())
        .then((value) {
      handleDashboardRes(value);
      try {
        setValueToLocal(APICacheConst.DASHBOARD_RESPONSE, value.toJson());
      } catch (e) {
        log('store DASHBOARD_RESPONSE E: $e');
      }
    }).whenComplete(() => isLoading(false));
  }

  void handleDashboardRes(DashboardRes value) {
    dashboardData(value.data);
    isRefresh(true);
    isRefresh(false);
    serviceList(value.data.systemService);
    taxPercentage(value.data.taxPercentage);

    weightUnits(value.data.weightUnit);
    heightUnits(value.data.heightUnit);
    if (weightUnits.isEmpty) {
      weightUnits = [defaulWEIGHT.value].obs;
    } else {
      defaulWEIGHT(weightUnits.first);
    }
    if (heightUnits.isEmpty) {
      heightUnits = [defaulHEIGHT.value].obs;
    } else {
      defaulHEIGHT(heightUnits.first);
    }
  }
}
