import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/Screens/Home.dart';
import 'package:suraksha/Screens/auth/signup.dart';
import 'package:suraksha/Screens/auth/verify_otp.dart';
import 'package:suraksha/Screens/subscription/subscription.dart';
import 'package:suraksha/Screens/test/test_payment.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/payment_service/cashFree_pay.dart';
import 'package:suraksha/Services/payment_service/razor_pay.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/app_images.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/app_textField.dart';

import '../../Services/api_services/apiStrings.dart';
import '../../model/apply_promo_response.dart';
import 'forget_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController refController = TextEditingController();
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanCost();
  }

  int _value = 1;
  bool isMobile = true;
  bool isLoading = false;
  var Otp;


  Map? jsonResponse;



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          //backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Container(
            decoration: BoxDecoration().myBoxDecoration(),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SizedBox(height: 20,),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Image.asset(
                        Images.homeLogo,
                        fit: BoxFit.contain,
                        width: 110,
                        height: 100,
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.70,
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              CustomColors.whiteColor,
                              CustomColors.whiteColor
                            ],
                          ),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(45),
                              topRight: Radius.circular(45))),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          const Text(
                            "Login",
                            style: TextStyle(
                              fontSize: 33,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Radio(
                                  value: 1,
                                  fillColor: MaterialStateColor.resolveWith(
                                      (states) => CustomColors.primaryColor),
                                  groupValue: _value,
                                  onChanged: (int? value) {
                                    setState(() {
                                      _value = value!;
                                      isMobile = true;
                                    });
                                  }),
                              // SizedBox(width: 10.0,),
                              const Text(
                                "Mobile No.",
                                style: TextStyle(
                                    color: CustomColors.blackTemp,
                                    fontSize: 16),
                              ),
                              Radio(
                                value: 2,
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => CustomColors.primaryColor),
                                activeColor: Colors.white,
                                groupValue: _value,
                                onChanged: (int? value) {
                                  setState(() {
                                    _value = value!;
                                    isMobile = false;
                                  });
                                },
                              ),
                              const Text(
                                "Email",
                                style: TextStyle(
                                    color: CustomColors.blackTemp,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                          !isMobile
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 20.0,
                                      bottom: 20,
                                      left: 20,
                                      right: 20),
                                  child: Column(
                                    children: [
                                      AppTextField(
                                        controller: emailController,
                                        prefixIcon: Icons.email,
                                        hint: "Enter Email",
                                        validator: emailValidator,
                                        inputType: TextInputType.emailAddress,
                                        inputFormatters: <TextInputFormatter>[
                                          //LengthLimitingTextInputFormatter(8),
                                          // FilteringTextInputFormatter.allow(
                                          // //  RegExp(r'[0-8]'),
                                          // ),
                                          // FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      AppTextField(
                                        controller: passwordController,
                                        prefixIcon: Icons.lock,
                                        hint: "Password",
                                        validator: passwordValidator,
                                        obscureText: true,
                                        inputType: TextInputType.text,
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(8),
                                          // FilteringTextInputFormatter.allow(
                                          // //  RegExp(r'[0-8]'),
                                          // ),
                                          // FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const ForgetPassword()));
                                          },
                                          child: const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Forgot Password?",
                                                style: TextStyle(
                                                    color:
                                                        CustomColors.whiteColor,
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 16),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 50.0,
                                      ),
                                      AppButton(
                                        title: 'Sign In',
                                        onTab: () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (emailController.text.isEmpty ||
                                                passwordController
                                                    .text.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      'Enter Email and Password');
                                            } else {
                                              loginWithEmailPasswordApi();
                                              // Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen()));
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Please fill all fields");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox.shrink(),
                          isMobile
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                  child: AppTextField(
                                    controller: mobileController,
                                    prefixIcon: Icons.call,
                                    hint: "Mobile Number",
                                    validator: mobileValidator,
                                    inputFormatters: <TextInputFormatter>[
                                      LengthLimitingTextInputFormatter(10),
                                      FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9]'),
                                      ),
                                      FilteringTextInputFormatter.digitsOnly
                                    ],
                                  ))
                              : const SizedBox.shrink(),
                          SizedBox(
                            height: isMobile ? 40 : 0,
                          ),
                          isMobile
                              ? AppButton(
                                  title: 'Send OTP',
                                  onTab: () {
                                    if (_formKey.currentState!.validate()) {
                                      // ScaffoldMessenger.of(context)
                                      //     .showSnackBar(
                                      //   const SnackBar(
                                      //       content: Text('Processing Data')),
                                      //  );
                                       loginWithMobile();

                                    } else {
                                      Fluttertoast.showToast(
                                          msg: 'Please enter Valid mobile no.');
                                    }
                                  },
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: isMobile ? 20 : 0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    color: CustomColors.blackTemp,
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              GestureDetector(
                                //   onTap: (){},
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                      color: CustomColors.primaryColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const SignUp()
                                        //     VendorRegisteration(
                                        //   role: "0",
                                        // ),
                                        ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  LoginResponse? loginResponse;
  bool status = false ;

  Future<void> loginWithEmailPasswordApi() async {
    String? token = await FirebaseMessaging.instance.getToken();
    var prm = {
      "email": emailController.text,
      "password": passwordController.text,
      "fcm_id":token
    };

    apiBaseHelper.postAPICall(getLogIn, prm).then((getData) async {

      bool status = getData['status'];
      String msg= getData['message'];

      if(status){
        Fluttertoast.showToast(msg: msg);
        loginResponse = LoginResponse.fromJson(getData);

        if(loginResponse?.data?.user?.planStatus == '0'){
          Fluttertoast.showToast(msg: 'You are unSubscribed user');
          /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));*/
            showDialogForPayment();
        }else if(loginResponse?.data?.user?.planStatus == '2'){
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SubscriptionScreen(token: loginResponse?.data?.user?.token,planStatus: loginResponse?.data?.user?.planStatus,userData: loginResponse,isFromLogin: true),
              ));
        } else{
          SharedPreferences preferences = await SharedPreferences.getInstance();
          preferences.setString('token', loginResponse?.data?.user?.token ?? '');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));
        }

      }else {
        Fluttertoast.showToast(msg: msg);
      }

    });
  }

  Future<void> loginWithMobile() async {

    var prm = {
      "mobile": mobileController.text,
    };

    apiBaseHelper.postAPICall(getSendOtp, prm).then((getData) {

      print('${getData}');

      bool status = getData['status'];
      String msg= getData['message'];

      if(status){
        Fluttertoast.showToast(msg: msg);
        Navigator.push(context, MaterialPageRoute(builder: (context) => VerifyOtp(mobile: mobileController.text,otp: getData['data']['otp'].toString(),)));
      }else {
        Fluttertoast.showToast(msg: msg);
      }

    });
  }


  bool isLoadingbtn = false ;
  Function ?dialogStateMain;
  showDialogForPayment() async {
    await showDialog(
      context: context,
      builder: (context) =>StatefulBuilder(builder: (context, dialogState) {
        dialogStateMain =dialogState ;
        return  AlertDialog(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Image.asset(Images.splashLogo),
          actions: [
            Text('*You will have to pay INR ${setupCost}/-incl GST',style: TextStyle(fontSize: 16)),
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
                  SizedBox(width: 5,),
                  Expanded(
                    flex: 1,
                    child: InkWell( onTap: () {

                      dialogState((){
                        applyPromo();
                      });

                    },child: Container(
                      height: 30,
                      // width: 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [CustomColors.primaryColor, CustomColors.secondaryColor],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: CustomColors.blackTemp.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          ),
                        ],

                      ),child: Icon(Icons.check, size: 25,color: CustomColors.whiteColor,),)),
                  )
                ],),
              SizedBox(height: 30,),

              isLoadingbtn ? Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),) : AppButton(title: 'Pay & Signup', onTab: () async{
                dialogState((){
                  isLoadingbtn = true ;
                });

                await getPaymentId();

                CashFreeHelper razorPay =  CashFreeHelper(
                    orderId ?? '1', context,paymentSessionId ,(result) async{
                  if (result != "error") {
                    //payOrder(widget.model.bookingId, result);
                    // buySubscription(index, result.toString());
                   await addTransaction(transactionId: '${result}', promo: refController.text,token: '${loginResponse?.data?.user?.token}', amount: '${setupCost}', discount: discount ??'0');

                     SharedPreferences preferences = await SharedPreferences.getInstance();
                     preferences.setString('token', loginResponse?.data?.user?.token ?? '');
                   dialogState(() {
                     isLoadingbtn = false;
                   });
                     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));








                  } else {
                    setState(() {
                      status = false;
                    });
                  }
                });

                setState(() {
                  status = true;
                });
                razorPay.init();
              }),

            ],),) ;
      },),
    );
  }

  String? monthRenewalCost;
  String? quarterlyRenewalCost;
  String? yearlyRenewalCost;
  String? setupCost;
  String? discount;
  String? orderId;
  String? paymentSessionId;

  Future<void> applyPromo() async {
    var param = {
      "code": refController.text.trim()
    };

    apiBaseHelper.postAPICall(applyPromoApi,param).then((getData) async {
      bool status = getData['status'] ?? true;
      String msg = getData['message'] ?? '';

      if(status) {
        Fluttertoast.showToast(msg: '${getData['data']['discount_amount']}/- discount ${msg}');

        discount = getData['data']['discount_amount'].toString() ;

        var data = ApplyCouponResponse.fromJson(getData);
        setupCost = data.data?.updatedPrice.toString();
        dialogStateMain!((){});
      }else {
        Fluttertoast.showToast(msg: msg);
      }

    });
  }

  Future<void> getPaymentId({String? name,String? email,String? mobile, String? amount,String? id}) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('POST', Uri.parse('${baseUrl}createOrderSession'));
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
    }
    else {
      print(response.reasonPhrase);
    }
  }


  Future<void> getPlanCost() async {
    apiBaseHelper.getAPICall(getPlanCostApi).then((value) async {
      setupCost = value['data']['plan_details']['setup_cost'] ?? '';
      print(setupCost);
      monthRenewalCost = value['data']['plan_details']['monthly_renewal_cost'] ?? '';
      quarterlyRenewalCost = value['data']['plan_details']['quaterly_renewal_cost'] ?? '';
      yearlyRenewalCost = value['data']['plan_details']['yearly_renewal_cost'] ?? '';

      setState(() {});
    });
  }
}
