import 'package:get/get.dart';
import '../../configs.dart';
import '../dashboard/dashboard_res_model.dart';
import 'package:pawlly/utils/library.dart';

PaymentController paymentController = PaymentController();

class PaymentController extends GetxController {
  //
  SystemService? bookingService;
  bool isFromBookingDetail;
  num? amount;
  num? tax;
  int? bid;
  int paymentID;

  PaymentController({
    this.bookingService,
    this.isFromBookingDetail = false,
    this.amount,
    this.tax,
    this.bid,
    this.paymentID = -1,
  });

  //
  RxString paymentOption = PaymentMethods.PAYMENT_METHOD_CASH.obs;
  TextEditingController optionalCont = TextEditingController();
  RxBool isLoading = false.obs;
  RazorPayService razorPayService = RazorPayService();
  PayStackService paystackServices = PayStackService();
  FlutterWaveService flutterWaveServices = FlutterWaveService();
  MidtransService midtransPay = MidtransService();

  savePaymentApi(
      {required int bid,
      required String txnId,
      required String paymentType,
      required int paymentStatus}) {
    isLoading(true);
    hideKeyBoardWithoutContext();
    PetServiceFormApis.savePayment(
      request: SavePaymentReq(
        bookingId: bid,
        externalTransactionId: txnId,
        paymentID: paymentID,
        transactionType: paymentType,
        taxPercentage: taxPercentage,
        paymentStatus: paymentStatus,
        totalAmount: isFromBookingDetail && amount.validate() > 0
            ? amount.validate().toStringAsFixed(2).toDouble()
            : totalAmount.toStringAsFixed(2).toDouble(),
      ).toJson(),
    ).then((value) async {
      if (isFromBookingDetail) {
        Get.back(result: true);
      } else {
        onPaymentSuccess(
            bookingType: bookingService != null
                ? getServiceKeyByServiceElement(bookingService!)
                : getServiceKeyByServiceElement(currentSelectedService.value));
      }

      isLoading(false);
    }).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    }); //
  }

  handleBookNowClick(BuildContext context) {
    if (isFromBookingDetail) {
      payWithSelectedOption(context, isCashPayment: false);
    } else {
      showInDialog(
        context,
        contentPadding: EdgeInsets.zero,
        builder: (context) {
          return ConfirmBookingDialog(
            titleText: locale.value.confirmBooking,
            subTitleText: locale.value.doYouConfirmThisPayment,
            changeToastMessage: locale.value.pleaseAcceptBookingConfirmation,
            onConfirm: () {
              Get.back();
              if (saveBookingRes.value.bookingId.isNegative) {
                saveBooking(context);
              } else {
                payWithSelectedOption(context);
              }
            },
          );
        },
      );
    }
  }

  void payWithSelectedOption(BuildContext context,
      {bool isCashPayment = true}) {
    if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
      payWithStripe();
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
      payWithRazorPay();
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
      payWithPayStack();
    } else if (paymentOption.value ==
        PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
      payWithFlutterWave(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYPAL) {
      payWithPaypal(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_AIRTEL) {
      payWithAirtelMoney(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PHONEPE) {
      payWithPhonepe(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_MIDTRANS) {
      payWithMidtrans();
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_SADAD) {
      payWithSadad(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CINETPAY) {
      payWithCinetPay(context);
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CASH &&
        isCashPayment) {
      payWithCash();
    }
  }

  payWithStripe() async {
    await StripeServices.stripePaymentMethod(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      amount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      onComplete: (res) {
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
  }

  payWithFlutterWave(BuildContext context) async {
    isLoading(true);
    flutterWaveServices.checkout(
      ctx: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      bookingId: isFromBookingDetail && bid.validate() > 0
          ? bid.validate()
          : saveBookingRes.value.bookingId,
      isTestMode: appConfigs.value.flutterwavePay.flutterwavePublickey
          .toLowerCase()
          .contains("test"),
      onComplete: (res) {
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
  }

  payWithPaypal(BuildContext context) {
    isLoading(true);
    PayPalService.paypalCheckOut(
      context: context,
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      onComplete: (res) {
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
  }

  payWithPayStack() async {
    isLoading(true);
    await paystackServices.init(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      bookingId: isFromBookingDetail && bid.validate() > 0
          ? bid.validate()
          : saveBookingRes.value.bookingId,
      onComplete: (res) {
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    isLoading(false);
    if (Get.context != null) {
      paystackServices.checkout(Get.context!);
      isLoading(false);
    } else {
      toast("context not found!!!!");
      isLoading(false);
    }
  }

  payWithRazorPay() async {
    isLoading(true);
    razorPayService.init(
      razorKey: appConfigs.value.razorPay.razorpaySecretkey,
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      onComplete: (res) {
        log("txn id: $res");
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    razorPayService.razorPayCheckout();
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);
  }

  payWithAirtelMoney(BuildContext context) async {
    isLoading(true);
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      barrierDismissible: false,
      builder: (context) {
        return AppCommonDialog(
          title: "Airtel Money Payment",
          child: AirtelMoneyDialog(
            amount: totalAmount,
            reference: APP_NAME,
            bookingId: isFromBookingDetail && bid.validate() > 0
                ? bid.validate()
                : saveBookingRes.value.bookingId,
            onComplete: (res) {
              log('RES: $res');
              savePaymentApi(
                bid: isFromBookingDetail && bid.validate() > 0
                    ? bid.validate()
                    : saveBookingRes.value.bookingId,
                paymentType: PaymentMethods.PAYMENT_METHOD_AIRTEL,
                txnId: res["transaction_id"],
                paymentStatus: 1,
              );
            },
          ),
        );
      },
    ).then((value) => isLoading(false));
  }

  payWithPhonepe(BuildContext context) async {
    PhonePeServices peServices = PhonePeServices(
      totalAmount: totalAmount.toDouble(),
      bookingId: isFromBookingDetail && bid.validate() > 0
          ? bid.validate()
          : saveBookingRes.value.bookingId,
      onComplete: (res) {
        log('RES: $res');
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_PHONEPE,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );

    peServices.phonePeCheckout(context);
  }

  void payWithMidtrans() async {
    isLoading(true);
    midtransPay.initialize(
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      onComplete: (res) {
        log("txn id: $res");
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_MIDTRANS,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
      loaderOnOFF: (v) {
        isLoading(v);
      },
    );
    await Future.delayed(const Duration(seconds: 1));
    midtransPay.midtransPaymentCheckout();
    await Future.delayed(const Duration(seconds: 2));
    isLoading(false);
  }

  void payWithSadad(BuildContext context) async {
    SadadServices sadadServices = SadadServices(
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      onComplete: (res) {
        log("txn id: $res");
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_SADAD,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
    sadadServices.payWithSadad(context);
  }

  void payWithCinetPay(BuildContext context) async {
    CinetPayServices cinetPay = CinetPayServices(
      totalAmount: isFromBookingDetail && amount.validate() > 0
          ? amount.validate()
          : totalAmount,
      onComplete: (res) {
        log("txn id: $res");
        savePaymentApi(
          bid: isFromBookingDetail && bid.validate() > 0
              ? bid.validate()
              : saveBookingRes.value.bookingId,
          paymentType: PaymentMethods.PAYMENT_METHOD_CINETPAY,
          txnId: res["transaction_id"],
          paymentStatus: 1,
        );
      },
    );
    cinetPay.payWithCinetPay(context: context);
  }

  payWithCash() async {
    savePaymentApi(
      bid: isFromBookingDetail && bid.validate() > 0
          ? bid.validate()
          : saveBookingRes.value.bookingId,
      paymentType: PaymentMethods.PAYMENT_METHOD_CASH,
      txnId:
          isFromBookingDetail && bid.validate() > 0 ? "#${bid.validate()}" : "",
      paymentStatus: isFromBookingDetail && bid.validate() > 0 ? 1 : 0,
    );
  }

  saveBooking(BuildContext context, {List<PlatformFile>? files}) {
    isLoading(true);
    final req = getBookingReqByServiceType(
        serviceType: bookingService != null
            ? getServiceKeyByServiceElement(bookingService!)
            : getServiceKeyByServiceElement(currentSelectedService.value));
    log('req.\$1: ${req.$1}');
    log('req.\$2: ${req.$2}');
    PetServiceFormApis.bookServiceApi(
      request: req.$1,
      files: req.$2,
      onSuccess: () {
        payWithSelectedOption(context);
        isLoading(false);
      },
      loaderOff: () {
        isLoading(false);
      },
    ).then((value) {}).catchError((e) {
      isLoading(false);
      toast(e.toString(), print: true);
    }); //
  }
}
