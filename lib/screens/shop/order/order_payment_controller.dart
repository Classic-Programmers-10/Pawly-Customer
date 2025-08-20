import 'package:get/get.dart';
import '../../../configs.dart';
import 'package:pawlly/utils/library.dart';
OrderPaymentController orderPaymentController = OrderPaymentController();

class OrderPaymentController {
  ///ORDER Module Params
  PlaceOrderReq? placeOrderReq;
  num? amount;

  OrderPaymentController({this.placeOrderReq, this.amount});

  //
  RxString paymentOption = PaymentMethods.PAYMENT_METHOD_CASH.obs;
  TextEditingController optionalCont = TextEditingController();
  RxBool isLoading = false.obs;
  RazorPayService razorPayService = RazorPayService();
  PayStackService paystackServices = PayStackService();
  FlutterWaveService flutterWaveServices = FlutterWaveService();
  MidtransService midtransPay = MidtransService();

  handlePayNowClick(BuildContext context) {
    showInDialog(
      context,
      contentPadding: EdgeInsets.zero,
      builder: (context) {
        return ConfirmBookingDialog(
          titleText: locale.value.confirmOrder,
          subTitleText: locale.value.doYouConfirmThisPayment,
          confirmText: locale.value.iHaveReadAllDetailFillFormOrder,
          changeToastMessage: locale.value.pleaseAcceptOrderConfirmation,
          onConfirm: () {
            Get.back();
            if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
              payWithStripe();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
              payWithRazorPay();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
              payWithPayStack();
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
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
            } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CASH) {
              payWithCash();
            }
          },
        );
      },
    );
  }

  void payWithSelectedOption(BuildContext context, {bool isCashPayment = true}) {
    if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_STRIPE) {
      payWithStripe();
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_RAZORPAY) {
      payWithRazorPay();
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_PAYSTACK) {
      payWithPayStack();
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE) {
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
    } else if (paymentOption.value == PaymentMethods.PAYMENT_METHOD_CASH && isCashPayment) {
      payWithCash();
    }
  }

  payWithStripe() async {
    await StripeServices.stripePaymentMethod(
      loderOnOFF: (p0) {
        isLoading(p0);
      },
      amount: amount.validate(),
      onComplete: (res) {
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_STRIPE,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
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
      totalAmount: amount.validate(),
      bookingId: 0,
      isTestMode: appConfigs.value.flutterwavePay.flutterwavePublickey.toLowerCase().contains("test"),
      onComplete: (res) {
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
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
      totalAmount: amount.validate(),
      onComplete: (res) {
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_PAYPAL,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
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
      totalAmount: amount.validate(),
      bookingId: 0,
      onComplete: (res) {
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
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
      totalAmount: amount.validate(),
      onComplete: (res) {
        log("txn id: $res");
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
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
            amount: amount.validate(),
            reference: APP_NAME,
            bookingId: 0,
            onComplete: (res) {
              log('RES: $res');
              placeOrder(
                paymentType: PaymentMethods.PAYMENT_METHOD_AIRTEL,
                txnId: res["transaction_id"],
                paymentStatus: PaymentStatus.PAID,
              );
            },
          ),
        );
      },
    ).then((value) => isLoading(false));
  }

  payWithPhonepe(BuildContext context) async {
    PhonePeServices peServices = PhonePeServices(
      totalAmount: amount.validate().toDouble(),
      onComplete: (res) {
        log('RES: $res');
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_PHONEPE,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
        );
      },
    );

    peServices.phonePeCheckout(context);
  }

  void payWithMidtrans() async {
    isLoading(true);
    midtransPay.initialize(
      totalAmount: amount.validate(),
      onComplete: (res) {
        log("txn id: $res");
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_MIDTRANS,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
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
      totalAmount: amount.validate(),
      onComplete: (res) {
        log("txn id: $res");
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_SADAD,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
        );
      },
    );
    sadadServices.payWithSadad(context);
  }

  void payWithCinetPay(BuildContext context) async {
    CinetPayServices cinetPay = CinetPayServices(
      totalAmount: amount.validate(),
      onComplete: (res) {
        log("txn id: $res");
        placeOrder(
          paymentType: PaymentMethods.PAYMENT_METHOD_CINETPAY,
          txnId: res["transaction_id"],
          paymentStatus: PaymentStatus.PAID,
        );
      },
    );
    cinetPay.payWithCinetPay(context: context);
  }

  payWithCash() async {
    placeOrder(paymentType: PaymentMethods.PAYMENT_METHOD_CASH, txnId: "", paymentStatus: PaymentStatus.pending);
  }

  ///SHOP MODULE PLACE ORDER API
  void placeOrder({required String txnId, required String paymentType, required String paymentStatus}) {
    log('PAYMENTSTATUS: $paymentStatus');
    hideKeyBoardWithoutContext();
    if (placeOrderReq == null) return;
    isLoading(true);
    placeOrderReq!.paymentDetails = txnId;
    placeOrderReq!.paymentMethod = paymentType;
    placeOrderReq!.paymentStatus = paymentStatus;
    log('PLACEORDERREQ!.TOJSON(): ${placeOrderReq!.toJson()}');

    /// Place Order API
    OrderApis.placeOrderAPI(placeOrderReq!.toJson()).then((value) async {
      log('ORDERLISTSCREEN:placeOrderAPI ');
      toast(value.message);
      cartItemCount(0);
      Get.offUntil(GetPageRoute(page: () => NewOrderScreen()), (route) => route.isFirst || route.settings.name == '/$DashboardScreen');
    }).catchError((e) {
      toast(e.toString(), print: true);
    }).whenComplete(() => isLoading(false));
  }
}
