import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class EmployeeDetailController extends GetxController {
  Rx<Future<GetUserProfileResponse>> getUserProfileDetail =
      Future(() => GetUserProfileResponse(data: UData(userSetting: UserSetting(), profile: Profile()))).obs;
  Rx<Future<EmployeeReviewRes>> getUserProfileRating =
      Future(() => EmployeeReviewRes(reviewData: <EmployeeReviewData>[])).obs;
  RxBool isLoading = false.obs;
  RxBool isLastPage = false.obs;
  RxInt employeeId = 0.obs;

  @override
  void onInit() {
    if (Get.arguments is int && Get.arguments > 0) {
      employeeId(Get.arguments as int);
      init();
    } else {
      Get.back();
    }
    super.onInit();
  }

  void init({bool showloader = true}) {
    if (showloader) {
      isLoading(true);
    }
    getUserProfileDetail(AuthServiceApis.viewProfile(
      id: employeeId.value,
    )).whenComplete(() => isLoading(false));
    getUserProfileRating(BookingServiceApis.getEmployeeReviews(
      empId: employeeId.value,
    ));
  }
}
