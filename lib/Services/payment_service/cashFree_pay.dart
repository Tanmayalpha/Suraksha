import 'package:flutter/cupertino.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfcard/cfcardwidget.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';

class CashFreeHelper {

  String? orderId;
  String? paymentSessionId;
  BuildContext context;
  ValueChanged onResult;

  CashFreeHelper(this.orderId, this.context, this.paymentSessionId, this.onResult) ;

  var cfPaymentGatewayService = CFPaymentGatewayService();

  CFCardWidget? cfCardWidget;
  CFEnvironment environment = CFEnvironment.SANDBOX;


  init() {
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
   // var session = createSession();
    webCheckout();
    /*_razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    openCheckout();*/
  }

  void verifyPayment(String orderId) {
    onResult(orderId);
    print("Verify Payment");
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print(errorResponse.getMessage());
    print('______________________');
    onResult("error");
  }

  webCheckout() async {
    try {
      var session = createSession();
      var theme = CFThemeBuilder().setNavigationBarBackgroundColorColor("#ff00ff").setNavigationBarTextColor("#ffffff").build();
      var cfWebCheckout = CFWebCheckoutPaymentBuilder().setSession(session!).setTheme(theme).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print(e.message);
    }

  }

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder().setEnvironment(environment).setOrderId(orderId ?? '').setPaymentSessionId(paymentSessionId ?? '').build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }
}