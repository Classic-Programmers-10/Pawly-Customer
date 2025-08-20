import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';
import 'package:stream_transform/stream_transform.dart';

class PetSitterController extends GetxController {
  Rx<Future<RxList<EmployeeModel>>> getPetSitterList = Future(() => RxList<EmployeeModel>()).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxList<EmployeeModel> petSittersList = RxList();
  RxInt page = 1.obs;
  TextEditingController searchCont = TextEditingController();
  RxBool isSearchText = false.obs;
  StreamController<String> searchStream = StreamController<String>();
  final _scrollController = ScrollController();
  RxSet<String> selectedStatus = RxSet();
 String latitudeCont="";

  String longitudeCont="";

  @override
  void onInit() {
    initializeSearchStream();
    getDoctorList(showloader: false);
    super.onInit();
  }

  void handleSearch() async {
    page(1);
    getDoctorList(search: searchCont.text.trim());
  }

  Future<void> getDoctorList(
      {bool showloader = true, String search = "", bool searchByLocation = false}) async {
    if (showloader) {
      isLoading(true);
    }
    await getPetSitterList(PetServiceFormApis.getPetSitters(
      role: EmployeeKeyConst.petSitter,
      petSittersList: petSittersList,
      search: search,
      page: page.value,
      latitude: searchByLocation ? latitudeCont : "",
      longitude: searchByLocation ? longitudeCont : "",
      showNearby: searchByLocation,
      lastPageCallBack: (p0) {
        isLastPage(p0);
      },
    )).whenComplete(() => isLoading(false));
  }

  ///Search
  void initializeSearchStream() {
    _scrollController.addListener(() => Get.context != null ? hideKeyboard(Get.context) : null);
    searchStream.stream.debounce(const Duration(seconds: 1)).listen((s) {
      handleSearch();
    });
  }

  void disposeSearchStream() {
    searchStream.close();
    if (Get.context != null) {
      _scrollController.removeListener(() => hideKeyboard(Get.context));
    }
  }

  void handleCurrentLocationClick() async {
    isLoading(true);
    await getUserLocation().then((value) {
      latitudeCont = getDoubleAsync(LATITUDE).toString();
      longitudeCont = getDoubleAsync(LONGITUDE).toString();
      getDoctorList(searchByLocation: true).then((response){
        Get.back();
      });

    }).catchError((e) {
      log(e);
      toast(e.toString());
    });

    isLoading(false);
  }

  @override
  void onClose() {
    disposeSearchStream();
    super.onClose();
  }
}
