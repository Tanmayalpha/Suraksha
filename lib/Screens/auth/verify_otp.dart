import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/Screens/Home.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/api_services/apiStrings.dart';
import 'package:suraksha/Services/payment_service/cashFree_pay.dart';
import 'package:suraksha/Services/payment_service/razor_pay.dart';
import 'package:suraksha/model/apply_promo_response.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/app_images.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_bar.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/app_textField.dart';

class VerifyOtp extends StatefulWidget {
  String? otp;
  String? mobile;

  VerifyOtp({this.otp, this.mobile});

  // final otp, email;
  //  final bool signUp;
  //  VerifyOtp({Key? key, this.otp, this.email, required this.signUp}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  var apiOtp;
  var inputOtp;

  // ProgressDialog? pr;

  // final pinController = OTPTextField();
  OtpFieldController otpController = OtpFieldController();

  final focusNode = FocusNode();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Map? jsonResponse;

  String PIN = '';

  LoginResponse? loginResponse;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanCost();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: myAppBar(title: 'Verification', context: context),
      backgroundColor: CustomColors.primaryColor,
      body: Form(
        key: _formKey,
        child: Container(
          // decoration: BoxDecoration().myBoxDecoration(),
          color: CustomColors.whiteColor,
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                "Code has sent to",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColors.blackTemp,
                    fontWeight: FontWeight.w400,
                    fontSize: 20),
              ),
              const SizedBox(
                height: 9,
              ),
              Text(
                "+91${widget.mobile}",
                style: const TextStyle(
                    color: CustomColors.blackTemp,
                    fontWeight: FontWeight.w700,
                    fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${widget.otp}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: CustomColors.blackTemp,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20),
                child: OTPTextField(
                  controller: otpController,
                  length: 4,
                  otpFieldStyle: OtpFieldStyle(
                    borderColor: CustomColors.primaryColor,
                    disabledBorderColor: CustomColors.grayColor,
                    enabledBorderColor: CustomColors.primaryColor,
                  ),
                  width: MediaQuery.of(context).size.width,
                  fieldWidth: 60,
                  style: const TextStyle(
                      fontSize: 17, color: CustomColors.blackTemp),
                  textFieldAlignment: MainAxisAlignment.spaceAround,
                  fieldStyle: FieldStyle.box,
                  onChanged: (pin) {
                    PIN = pin;
                  },
                  onCompleted: (pin) {
                    PIN = pin;
                  },
                ),
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Haven't received the verification code? ",
                    style: TextStyle(
                        color: CustomColors.blackTemp,
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                    // textAlign: TextAlign.center,
                  ),
                  // Text("${widget.otp}")
                  TextButton(
                    onPressed: () {
                      // loginWithOtp();
                      resendOtp();
                    },
                    child: const Text(
                      "Resend",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: CustomColors.primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              AppButton(
                title: 'Verify',
                onTab: () {
                  if (_formKey.currentState!.validate()) {
                    verifyOTP();
                  } else {
                    // setState((){
                    //   isLoading =false;
                    // });
                    //Fluttertoast.showToast(msg: "Pls Enter Otp!");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verifyOTP() async {
    String? token = await FirebaseMessaging.instance.getToken();

    var param = {"mobile": widget.mobile, "otp": PIN, "fcm_id": token};

    apiBaseHelper.postAPICall(getVerifyOtp, param).then((getData) async {
      bool status = getData['status'];
      String msg = '';
      if (getData['message'].runtimeType == String) {
        msg = getData['message'];
      } else {
        msg = getData['message']['otp'];
      }
      if (status) {
        loginResponse = LoginResponse.fromJson(getData);

        if (loginResponse?.data?.user?.planStatus == '0') {
          Fluttertoast.showToast(msg: 'You are unSubscribed user');

          showDialogForPayment();
        } else {
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString(
              'token', loginResponse?.data?.user?.token ?? '');

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        }
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });
  }

  bool isLoadingbtn = false;
  Function? dialogStateMain;

  String? discount;

  TextEditingController refController = TextEditingController();

  showDialogForPayment() async {
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, dialogState) {
          dialogStateMain = dialogState;
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Image.asset(Images.splashLogo),
            actions: [
              Text('*You will have to pay INR ${setupCost}/-incl GST',
                  style: TextStyle(fontSize: 16)),
            ],
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: AppTextField(
                        controller: refController,
                        prefixIcon: Icons.vpn_key,
                        hint: "Promo Code",
                        inputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                          onTap: () {
                            dialogState(() {
                              applyPromo();
                            });
                          },
                          child: Container(
                            height: 30,
                            // width: 10,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  CustomColors.primaryColor,
                                  CustomColors.secondaryColor
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      CustomColors.blackTemp.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.check,
                              size: 25,
                              color: CustomColors.whiteColor,
                            ),
                          )),
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                isLoadingbtn
                    ? Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.primaryColor,
                        ),
                      )
                    : AppButton(
                        title: 'Pay & Login',
                        onTab: () async {
                          dialogState(() {
                            isLoadingbtn = true;
                          });

                          await getPaymentId(
                            name: loginResponse?.data?.user?.fullName,
                            email: loginResponse?.data?.user?.email,
                            id: loginResponse?.data?.user?.suraksha_code,
                            mobile: loginResponse?.data?.user?.mobile,
                            amount: setupCost
                          );

                          CashFreeHelper razorPay = CashFreeHelper(
                              orderId ?? '1', context,paymentSessionId, (result) async {
                            if (result != "error") {
                              //payOrder(widget.model.bookingId, result);
                              // buySubscription(index, result.toString());
                              await addTransaction(
                                  transactionId: '${result}',
                                  promo: refController.text,
                                  token: '${loginResponse?.data?.user?.token}',
                                  amount: '${setupCost}',
                                  discount: discount ?? '0');

                              if (true) {
                                SharedPreferences preferences =
                                    await SharedPreferences.getInstance();
                                preferences.setString('token',
                                    loginResponse?.data?.user?.token ?? '');

                                dialogState(() {
                                  isLoadingbtn = false;
                                });

                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ));
                              } else {
                                Navigator.pop(context);
                              }
                            } else {
                              dialogState(() {
                                isLoadingbtn = false;
                                Navigator.pop(context);
                              });
                            }
                          });

                          razorPay.init();
                        }),
              ],
            ),
          );
        },
      ),
    );
  }

  String? monthRenewalCost;
  String? quarterlyRenewalCost;
  String? yearlyRenewalCost;
  String? setupCost;

  Future<void> getPlanCost() async {
    apiBaseHelper.getAPICall(getPlanCostApi).then((value) async {
      setupCost = value['data']['plan_details']['setup_cost'] ?? '';
      print(setupCost);
      monthRenewalCost =
          value['data']['plan_details']['monthly_renewal_cost'] ?? '';
      quarterlyRenewalCost =
          value['data']['plan_details']['quaterly_renewal_cost'] ?? '';
      yearlyRenewalCost =
          value['data']['plan_details']['yearly_renewal_cost'] ?? '';

      setState(() {});
    });
  }

  Future<void> resendOtp() async {
    var prm = {
      "mobile": widget.mobile,
    };

    apiBaseHelper.postAPICall(getSendOtp, prm).then((getData) {
      bool status = getData['status'];
      String msg = getData['message'];

      if (status) {
        Fluttertoast.showToast(msg: msg);
        widget.otp = getData['data']['otp'].toString();
        setState(() {});
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });
  }

  Future<void> applyPromo() async {
    var param = {"code": refController.text.trim()};

    apiBaseHelper.postAPICall(applyPromoApi, param).then((getData) async {
      bool status = getData['status'] ?? true;
      String msg = getData['message'] ?? '';

      if (status) {
        Fluttertoast.showToast(
            msg: '${getData['data']['discount_amount']}/- discount ${msg}');

        discount = getData['data']['discount_amount'].toString();

        var data = ApplyCouponResponse.fromJson(getData);
        setupCost = data.data?.updatedPrice.toString();
        dialogStateMain!(() {});
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });
  }

  String? orderId;
  String? paymentSessionId;

  Future<void> getPaymentId(
      {String? name,
      String? email,
      String? mobile,
      String? amount,
      String? id}) async {
    var headers = {'Content-Type': 'application/json'};
    var request =
        http.Request('POST', Uri.parse('${baseUrl}createOrderSession'));
    request.body = json.encode({
      "customer_id": id ?? "1",
      "customer_name": name ?? "Shubham",
      "customer_email": email ?? "shubhamsamnotra@gmail.com",
      "customer_phone": mobile ?? "9149970345",
      "order_amount": amount ?? 1
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var result = await response.stream.bytesToString();
      var finalResult = jsonDecode(result);

      orderId = finalResult['data']['response']['order_id'];
      paymentSessionId = finalResult['data']['response']['payment_session_id'];
    } else {
      print(response.reasonPhrase);
    }
  }
}
