import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:googleapis/calendar/v3.dart';
import '../configs.dart';
import 'package:pawlly/utils/library.dart';

class PayStackService {
  PaystackPlugin paystackPlugin = PaystackPlugin();
  num totalAmount = 0;
  int bookingId = 0;
  late Function(Map<String, dynamic>) onComplete;
  late Function(bool) loderOnOFF;

  init(
      {required num totalAmount,
      required int bookingId,
      required Function(Map<String, dynamic>) onComplete,
      required Function(bool) loderOnOFF}) {
    paystackPlugin.initialize(
        publicKey: appConfigs.value.paystackPay.paystackPublickey);
    this.totalAmount = totalAmount;
    this.bookingId = bookingId;
    this.onComplete = onComplete;
    this.loderOnOFF = loderOnOFF;
  }

  Future checkout(BuildContext context) async {
    loderOnOFF(true);
    int price = totalAmount.toInt() * 100;
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now().millisecondsSinceEpoch}'
      ..email = loginUserData.value.email
      ..currency =
          isIqonicProduct ? payStackCurrency : appCurrency.value.currencyCode;

    CheckoutResponse response = await paystackPlugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
      isDarkMode: isDarkMode.value,
      darkModeTextColor: containerColor,
    );

    log('Response: $response');

    if (response.status == true) {
      log('Response $response');
      onComplete.call({
        'transaction_id': response.reference.validate(value: "#$bookingId"),
      });
      loderOnOFF(false);
      log('Payment was successful. Ref: ${response.reference}');
    } else {
      toast(response.message, print: true);
    }
  }
}
