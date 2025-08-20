import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class SelectAddressController extends GetxController {
  RxBool isLoading = false.obs;

  Rx<Future<List<UserAddress>>> getAddresses =
      Future(() => <UserAddress>[]).obs;

  RxList<UserAddress> addressList = RxList();
  RxList<LogisticZoneData> logisticList = RxList();
  Rx<UserAddress> setSelectedAddressData = UserAddress(id: (-1).obs).obs;
  Rx<LogisticZoneData> setLogisticZoneData = LogisticZoneData().obs;

  RxInt page = 1.obs;

  RxBool isLastPage = false.obs;
  RxBool isSelectedLogistic = false.obs;

  @override
  void onInit() {
    init();
    super.onInit();
  }

  Future<void> init() async {
    await getAddresses(UserAddressesApis.getAddressList(
      page: page.value,
      addressList: addressList,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() async {
      isLoading(false);
      try {
        if (addressList.isNotEmpty) {
          setSelectedAddressData(addressList.firstWhere(
              (element) => element.isPrimary.getBoolInt(),
              orElse: () => addressList.isNotEmpty
                  ? addressList.first
                  : UserAddress(id: (-1).obs)));
          await getLogisticZoneApi(
              addressId: setSelectedAddressData.value.id.value);
        }
      } catch (e) {
        isLoading(false);
        log('Error defaultAddress: $e');
      }
    });
  }

  Future<void> getLogisticZoneApi({required int addressId}) async {
    isLoading(true);
    await UserAddressesApis.getLogisticZone(addressId: addressId)
        .then((value) async {
      logisticList.clear();
      logisticList.addAll(value);
    }).catchError((e) {
      toast(e.toString());
    }).whenComplete(() => isLoading(false));
  }
}
