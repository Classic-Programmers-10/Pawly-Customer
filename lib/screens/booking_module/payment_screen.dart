import 'package:get/get.dart';
import 'package:pawlly/utils/library.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBartitleText: locale.value.payment,
      isLoading: paymentController.isLoading,
      body: Stack(
        fit: StackFit.expand,
        children: [
          RefreshIndicator(
            onRefresh: () async {
              getAppConfigurations();
              return await Future.delayed(const Duration(seconds: 2));
            },
            child: Obx(
              () => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    commonDivider,
                    8.height,
                    Text(locale.value.choosePaymentMethod,
                            style: primaryTextStyle())
                        .paddingSymmetric(horizontal: 16),
                    8.height,
                    Text(locale.value.chooseYourConvenientPaymentOptions,
                            style: secondaryTextStyle())
                        .paddingSymmetric(horizontal: 16),
                    32.height,
                    if (!paymentController.isFromBookingDetail)
                      cashAfterService(context),
                    stripePaymentWidget(context).paddingTop(8).visible(
                        appConfigs.value.stripePay.stripePublickey.isNotEmpty &&
                            appConfigs
                                .value.stripePay.stripeSecretkey.isNotEmpty),
                    razorPaymentWidget(context).paddingTop(8).visible(
                        appConfigs.value.razorPay.razorpaySecretkey.isNotEmpty),
                    payStackPaymentWidget(context).paddingTop(8).visible(
                        appConfigs.value.paystackPay.paystackPublickey
                                .isNotEmpty &&
                            appConfigs.value.paystackPay.paystackSecretkey
                                .isNotEmpty),
                    payPalPaymentWidget(context).paddingTop(8).visible(
                        appConfigs.value.paypalPay.paypalSecretkey.isNotEmpty),
                    flutterWavePaymentWidget(context).paddingTop(8).visible(
                        appConfigs.value.flutterwavePay.flutterwaveSecretkey
                                .isNotEmpty &&
                            appConfigs.value.flutterwavePay.flutterwavePublickey
                                .isNotEmpty),
                    airtelMoneyPaymentWidget(context).paddingTop(8).visible(
                        appConfigs
                                .value.airtelMoney.airtelClientid.isNotEmpty &&
                            appConfigs
                                .value.airtelMoney.airtelSecretkey.isNotEmpty),
                    phonePayPaymentWidget(context).paddingTop(8).visible(
                          appConfigs.value.phonepe.phonepeAppId.isNotEmpty &&
                              appConfigs
                                  .value.phonepe.phonepeMerchantId.isNotEmpty &&
                              appConfigs
                                  .value.phonepe.phonepeSaltKey.isNotEmpty &&
                              appConfigs
                                  .value.phonepe.phonepeSaltIndex.isNotEmpty,
                        ),
                    midtransPay(context).paddingTop(8).visible(appConfigs
                        .value.midtransPay.midtransClientId.isNotEmpty),
                    sadadPay(context).paddingTop(8).visible(
                        appConfigs.value.sadadPay.sadadSecretKey.isNotEmpty &&
                            appConfigs.value.sadadPay.sadadId.isNotEmpty &&
                            appConfigs.value.sadadPay.sadadDomain.isNotEmpty),
                    cinetPay(context).paddingTop(8).visible(appConfigs
                            .value.cinetPay.siteId.isNotEmpty &&
                        appConfigs.value.cinetPay.cinetPayAPIKey.isNotEmpty),
                  ],
                ),
              ),
            ),
          ).paddingBottom(155),
          Positioned(
            bottom: 0,
            left: 16,
            right: 16,
            child: AppButtonWithPricing(
              buttonTitle: locale.value.payNow,
              price: paymentController.isFromBookingDetail
                  ? paymentController.amount
                      .validate()
                      .toStringAsFixed(2)
                      .toDouble()
                  : totalAmount.toStringAsFixed(2).toDouble(),
              tax: paymentController.isFromBookingDetail
                  ? paymentController.tax
                      .validate()
                      .toStringAsFixed(2)
                      .toDouble()
                  : totalTax.toStringAsFixed(2).toDouble(),
              items: paymentController.isFromBookingDetail &&
                      paymentController.bookingService != null
                  ? getServiceNameByServiceElement(
                      serviceSlug: paymentController.bookingService!.slug)
                  : getServiceNameByServiceElement(
                      serviceSlug: currentSelectedService.value.slug),
              serviceImg: paymentController.isFromBookingDetail &&
                      paymentController.bookingService != null
                  ? paymentController.bookingService!.serviceImage
                  : currentSelectedService.value.serviceImage,
              onTap: () {
                paymentController.handleBookNowClick(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget stripePaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesStripeLogo),
          height: 16,
          width: 22,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Stripe", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_STRIPE,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget razorPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesRazorpayLogo),
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Razor Pay", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_RAZORPAY,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget payStackPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPaystackLogo),
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Paystack", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PAYSTACK,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget payPalPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPaypalLogo),
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Paypal", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PAYPAL,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget flutterWavePaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesFlutterWaveLogo),
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Flutter Wave", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_FLUTTER_WAVE,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget airtelMoneyPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesAirtelLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Airtel Money", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_AIRTEL,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget phonePayPaymentWidget(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesPhonepeLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("PhonePe", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_PHONEPE,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget midtransPay(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesMidtransLogo),
          color: darkGrayGeneral,
          height: 24,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Midtrans", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_MIDTRANS,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget sadadPay(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          color: darkGrayGeneral,
          image: AssetImage(Assets.imagesSadadLogo),
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Sadad", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_SADAD,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget cinetPay(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.imagesCinetpayLogo),
          color: darkGrayGeneral,
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("CinetPay", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_CINETPAY,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }

  Widget cashAfterService(BuildContext context) {
    return Obx(
      () => RadioListTile(
        tileColor: context.cardColor,
        controlAffinity: ListTileControlAffinity.trailing,
        shape: RoundedRectangleBorder(borderRadius: radius()),
        secondary: const Image(
          image: AssetImage(Assets.iconsIcCash),
          color: completedStatusColor,
          height: 18,
          width: 24,
        ),
        fillColor: WidgetStateProperty.all(primaryColor),
        title: Text("Cash after service", style: primaryTextStyle()),
        value: PaymentMethods.PAYMENT_METHOD_CASH,
        groupValue: paymentController.paymentOption.value,
        onChanged: (value) {
          paymentController.paymentOption(value.toString());
        },
      ).paddingSymmetric(horizontal: 16),
    );
  }
}
