import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';

class BoardingServiceController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool showBookBtn = false.obs;
  RxBool hasErrorFetchingBoarders = false.obs;
  RxString errorMessageBoarder = "".obs;
  BookBoardingReq bookBoardingReq = BookBoardingReq();
  RxInt serviceDaysCount = 0.obs;
  Rx<PetBoardingAmount> petBoardingAmount = PetBoardingAmount().obs;
  Rx<BookingDataModel> bookingFormData = BookingDataModel(
          service: SystemService(),
          payment: PaymentDetails(),
          training: Training())
      .obs;
  RxBool isUpdateForm = false.obs;
  RxBool isSelectedBoarderChange = false.obs;

  //
  Rx<EmployeeModel> selectedBoarder = EmployeeModel(profileImage: "".obs).obs;
  RxList<EmployeeModel> boardersList = RxList();

  //
  TextEditingController dropOffDateCont = TextEditingController();
  TextEditingController dropOfftimeCont = TextEditingController();
  TextEditingController pickUpDateCont = TextEditingController();
  TextEditingController pickUptimeCont = TextEditingController();
  TextEditingController dropAddressCont = TextEditingController();
  TextEditingController pickAddressCont = TextEditingController();
  TextEditingController boarderCont = TextEditingController();
  TextEditingController medicalReportCont = TextEditingController();
  TextEditingController additionalInfoCont = TextEditingController();

  Rx<Future<List<FacilityModel>>> getFacility =
      Future(() => <FacilityModel>[]).obs;
  RxList<FacilityModel> selectedFacilities = RxList();
  FilePickerResult? result;

  @override
  void onInit() {
    getBoarders();
    getPetBoardingAmount();
    getFacilityList(isBooking: 1);
    bookBoardingReq.systemServiceId = currentSelectedService.value.id;
    dropAddressCont.text = petCenterDetail.value.addressLine1;
    if (myPetsScreenController.myPets.length == 1) {
      /// Pet Selection When there is only single pet
      bookBoardingReq.petId = myPetsScreenController.myPets.first.id;
    }
    if (Get.arguments is BookingDataModel) {
      try {
        isUpdateForm(true);
        bookingFormData(Get.arguments as BookingDataModel);
        getFacility(PetServiceFormApis.getFacility(
          employeeId: bookingFormData.value.employeeId,
          isBooking: 1,
        )).then((fullList) {
          List<FacilityModel> previousSelected = fullList
              .where((item) => bookingFormData.value.additionalFacility
                  .map((e) => e.id)
                  .toList()
                  .contains(item.id))
              .toList();
          previousSelected.map((item) => item.isChecked(true)).toList();
          selectedFacilities(previousSelected);
        });
        additionalInfoCont.text = bookingFormData.value.note;
        selectedPet(myPetsScreenController.myPets.firstWhere(
            (element) =>
                element.name.toLowerCase() ==
                bookingFormData.value.petName.toLowerCase(),
            orElse: () => PetData()));
        bookBoardingReq.petId = selectedPet.value.id;
      } catch (e) {
        log('boarding book again E: $e');
      }
    }

    try {
      log('BookingDetailsController called init');
      BookingDetailsController bDetailCont = Get.find();
      currentSelectedService(bDetailCont.bookingDetail.value.service);
      dropOffDateCont.text = bDetailCont
          .bookingDetail.value.dropoffDateTime.dateInyyyyMMddHHmmFormat
          .formatDateDDMMYY();
      dropOfftimeCont.text = bDetailCont
          .bookingDetail.value.dropoffDateTime.dateInyyyyMMddHHmmFormat
          .formatTimeHHmmAMPM();
      pickUpDateCont.text = bDetailCont
          .bookingDetail.value.pickupDateTime.dateInyyyyMMddHHmmFormat
          .formatDateDDMMYY();
      pickUptimeCont.text = bDetailCont
          .bookingDetail.value.pickupDateTime.dateInyyyyMMddHHmmFormat
          .formatTimeHHmmAMPM();
      bookBoardingReq.dropoffDate = bDetailCont
          .bookingDetail.value.dropoffDateTime.dateInyyyyMMddFormat
          .formatDateYYYYmmdd();
      bookBoardingReq.dropoffTime = bDetailCont
          .bookingDetail.value.dropoffDateTime.dateInyyyyMMddHHmmFormat
          .formatTimeHHmm24hour()
          .toString();
      bookBoardingReq.pickupDate = bDetailCont
          .bookingDetail.value.pickupDateTime.dateInyyyyMMddFormat
          .formatDateYYYYmmdd();
      bookBoardingReq.pickupTime = bDetailCont
          .bookingDetail.value.pickupDateTime.dateInyyyyMMddHHmmFormat
          .formatTimeHHmm24hour()
          .toString();
    } catch (e) {
      log('boarding Reschedule init E: $e');
    }

    super.onInit();
  }

  void getPetBoardingAmount() {
    try {
      HomeScreenController homeController = Get.find();
      if (homeController.dashboardData.value.petBoardingAmount.isNotEmpty) {
        petBoardingAmount(
            homeController.dashboardData.value.petBoardingAmount.first);
      }
    } catch (e) {
      HomeScreenController homeController = HomeScreenController();
      homeController.getDashboardDetail();
      if (homeController.dashboardData.value.petBoardingAmount.isNotEmpty) {
        petBoardingAmount(
            homeController.dashboardData.value.petBoardingAmount.first);
      }
    }
  }

  void onDateTimeChanges() {
    try {
      serviceDaysCount(DateFormat(DateFormatConst.yyyy_MM_dd)
              .parse(getpickUpDateTime)
              .difference(DateFormat(DateFormatConst.yyyy_MM_dd)
                  .parse(getDropOFFDateTime))
              .inDays +
          1);
      log('SERVICEDAYSCOUNT: ${serviceDaysCount.value}');
      if (serviceDaysCount < 1) {
        serviceDaysCount(1);
      }
      bookBoardingReq.price = (isSelectedBoarderChange.value
              ? selectedBoarder.value.oneDayAmount
              : petBoardingAmount.value.val.toDouble()) *
          serviceDaysCount.value;
      currentSelectedService.value.serviceAmount = bookBoardingReq.price;

      ///calculationChecker();
      showBookBtn(false);
      showBookBtn(true);
    } catch (e) {
      log('On DateTimeChanges E: $e');
    }
  }

  ///To verify calculation use method below method;
  void calculationChecker() {
    log('SERVICE DAYS COUNT: $serviceDaysCount');
    log('BOOKBOARDINGREQ.PRICE: ${petBoardingAmount.value.val}');
    log('PRICE * Days: ${petBoardingAmount.value.val.toDouble() * serviceDaysCount.value}');
    log('percentTaxAmount: $percentTaxAmount');
    log('fixedTaxAmount: $fixedTaxAmount');
    log('totalAmount: $totalAmount');
    log('TOTAL AMOUNT: $totalAmount');
  }

  String get getDropOFFDateTime =>
      "${bookBoardingReq.dropoffDate.trim()} ${bookBoardingReq.dropoffTime.trim()}";

  String get getpickUpDateTime =>
      "${bookBoardingReq.pickupDate.trim()} ${bookBoardingReq.pickupTime.trim()}";

  void clearBoarderSelection() {
    boarderCont.clear();
    selectedBoarder(EmployeeModel(profileImage: "".obs));
    getFacilityList(isBooking: 1);
  }

  ///Get Facility List
  void getFacilityList({int employeeId = -1, int isBooking = 0}) {
    isLoading(true);

    getFacility(PetServiceFormApis.getFacility(
      employeeId: employeeId,
      isBooking: isBooking,
    )).then((value) {
      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      log('facilityListController Error: $e');
    }).whenComplete(() => isLoading(false));
  }

  ///Get Boarders List
  void getBoarders({String searchtext = ""}) {
    isLoading(true);
    PetServiceFormApis.getEmployee(
            role: EmployeeKeyConst.boarding, search: searchtext)
        .then((value) {
      isLoading(false);
      boardersList(value.data);
      log('BOARDERSLIST: ${boardersList.length}');
      hasErrorFetchingBoarders(false);
      if (isUpdateForm.value) {
        selectedBoarder(boardersList.firstWhere(
            (p0) => p0.id == bookingFormData.value.employeeId,
            orElse: () => EmployeeModel(profileImage: "".obs)));
        boarderCont.text = selectedBoarder.value.fullName;
        isSelectedBoarderChange(true);
        isUpdateForm(false);
      }
    }).onError((error, stackTrace) {
      hasErrorFetchingBoarders(true);
      errorMessageBoarder(error.toString());
      isLoading(false);
      // toast(error.toString());
    });
  }

  void handleBookNowClick({bool isFromReschedule = false}) {
    bookBoardingReq.dropoffAddress = dropAddressCont.text.trim();
    bookBoardingReq.pickupAddress = dropAddressCont.text.trim();
    bookBoardingReq.additionalInfo = additionalInfoCont.text.trim();
    bookBoardingReq.employeeId = selectedBoarder.value.id;
    bookBoardingReq.additionalFacility = selectedFacilities;
    bookBoardingReq.totalAmount = totalAmount;
    log('PERCENTTAXAMOUNT: $percentTaxAmount');
    bookingSuccessDate(getDropOFFDateTime);
    log('BOOKBOARDINGREQ.TOJSON(): ${bookBoardingReq.toJson()}');

    if (isFromReschedule) {
      try {
        BookingDetailsController bDetailCont = Get.find();
        Map<String, dynamic> req = {
          'id': bDetailCont.bookingDetail.value.id,
          'dropoff_date_time': getDropOFFDateTime.trim(),
          'pickup_date_time': getpickUpDateTime.trim(),
        };
        isLoading(true);
        BookingServiceApis.updateBooking(request: req).then((value) {
          bDetailCont.init(showLoader: false);
          Get.back();
        }).catchError((e) {
          toast(e.toString(), print: true);
        }).whenComplete(() => isLoading(false));
      } catch (e) {
        log('boarding Reschedule booking save E: $e');
      }
    } else {
      paymentController =
          PaymentController(bookingService: currentSelectedService.value);
      Get.to(() => const PaymentScreen(), binding: BindingsBuilder(() {
        getAppConfigurations();
      }));
    }
  }
}
