import 'package:get/get.dart';
import '../configs.dart';
import '../screens/dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';
bool isIqonicProduct = DOMAIN_URL.contains("apps.iqonic.design")
    || DOMAIN_URL.contains("innoquad.in")
    || DOMAIN_URL.contains("laratest.iqonic.design");

RxString selectedLanguageCode = DEFAULT_LANGUAGE.obs;
RxBool isLoggedIn = false.obs;
Rx<UserData> loginUserData = UserData().obs;
RxBool isDarkMode = false.obs;

// Firebase Constants
String get appNameTopic => APP_NAME.toLowerCase().replaceAll(' ', '_');
//endregion

Rx<Currency> appCurrency = Currency().obs;
Rx<ConfigurationResponse> appConfigs = ConfigurationResponse(
  currency: Currency(),
  onesignalCustomerApp: OnesignalCustomerApp(),
  razorPay: RazorPay(),
  stripePay: StripePay(),
  customerAppUrl: CustomerAppUrl(),
  paystackPay: PaystackPay(),
  paypalPay: PaypalPay(),
  flutterwavePay: FlutterwavePay(),
  airtelMoney: AirtelMoney(),
  phonepe: Phonepe(),
  midtransPay: MidtransPay(),
  cinetPay: CinetPay(),
  sadadPay: SadadPay(),
  zoom: ZoomConfig(),
).obs;

//DashBoard var
Rx<SystemService> currentSelectedService = SystemService().obs;
RxList<SystemService> serviceList = RxList();
RxList<StatusModel> allStatus = RxList();
RxList<OrderStatusData> allOrderStatus = RxList();
RxList<AboutDataModel> aboutPages = RxList();
RxList<UnitModel> weightUnits = RxList();
RxList<UnitModel> heightUnits = RxList();
Rx<PetCenterDetail> petCenterDetail = PetCenterDetail().obs;
//
//
//Booking Success
RxString bookingSuccessDate = "".obs;
Rx<SaveBookingRes> saveBookingRes = SaveBookingRes().obs;
//
//
//Bookings var
// Rx<AllBookingLists> cacheAllBookingLists = AllBookingLists().obs;

//region Tax CalCulation
RxList<TaxPercentage> taxPercentage = RxList();

double get fixedTaxAmount => taxPercentage.where((element) => element.type.toLowerCase().contains(TaxType.FIXED.toLowerCase())).sumByDouble((p0) => p0.value.validate());

///Note:don't forget to set currentSelectedService.value.serviceAmount in onInit of That service
double get percentTaxAmount => taxPercentage.where((element) => element.type.toLowerCase().contains(TaxType.PERCENT.toLowerCase())).sumByDouble((p0) => ((currentSelectedService.value.serviceAmount * p0.value.validate()) / 100));

num get totalTax => (fixedTaxAmount + percentTaxAmount).toStringAsFixed(Constants.DECIMAL_POINT).toDouble();

num get totalAmount => (currentSelectedService.value.serviceAmount + totalTax);
//endregion

// Currency position common
bool get isCurrencyPositionLeft => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT;

bool get isCurrencyPositionLeftWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_LEFT_WITH_SPACE;

bool get isCurrencyPositionRightWithSpace => appCurrency.value.currencyPosition == CurrencyPosition.CURRENCY_POSITION_RIGHT_WITH_SPACE;
//endregion

RxBool updateUi = false.obs;

//ORDER MOUDLE
RxInt cartItemCount = 0.obs;
//ORDER Success
RxString orderID = "".obs;
//
