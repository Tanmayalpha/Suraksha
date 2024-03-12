import 'dart:convert';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:suraksha/Screens/Home.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/api_services/apiStrings.dart';
import 'package:suraksha/Services/payment_service/cashFree_pay.dart';
import 'package:suraksha/Services/payment_service/razor_pay.dart';
import 'package:suraksha/model/apply_promo_response.dart';
import 'package:suraksha/utils/app_images.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/app_textField.dart';
import 'login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController refController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final mobileController = TextEditingController();
  final codeController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? password, email, userid, message, userTocken, responseCode;

  // late int? otp;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanCost();
  }

  Map? jsonResponse;
  int _value = 1;
  bool isMobile = false;
  bool isSendOtp = false;
  num? otp;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          //SystemNavigator.pop();
          return true;
        },
        child: SafeArea(
          top: true,
          bottom: false,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              decoration: BoxDecoration().myBoxDecoration(),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
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
                    // Container(
                    //   width: MediaQuery.of(context).size.width,
                    //   // height: MediaQuery.of(context).size.height,
                    //   child: Image.asset(
                    //     'assets/logo/app icon.png',height: 150,width: 150,
                    //     // 'assets/images/login_logo.png',
                    //
                    //   ),
                    // ),
                    Container(
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
                          Container(
                            margin: const EdgeInsets.all(20),
                            child: const Text(
                              "Please provide your basic information in order to book and avail services",
                              style: TextStyle(
                                fontSize: 16,
                                color: CustomColors.blackTemp,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 10.0, bottom: 0, left: 20, right: 20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  AppTextField(
                                    controller: nameController,
                                    prefixIcon: Icons.person,
                                    hint: "Enter Name",
                                    validator: nameTextValidator,
                                    inputType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppTextField(
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
                                  ),
                                  const SizedBox(
                                    height: 20.0,
                                  ),
                                  AppTextField(
                                    controller: emailController,
                                    prefixIcon: Icons.email,
                                    hint: "Enter Email",
                                    validator: emailValidator,
                                    inputType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(
                                    height: 20.0,
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
                                    height: 20.0,
                                  ),
                                  Container(
                                    /*height: 55,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),*/
                                    child: Center(
                                      child: TextFormField(
                                        controller: confirmController,
                                        obscureText: false,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if ((value == null ||
                                                  value.isEmpty) &&
                                              passwordController
                                                  .text.isNotEmpty) {
                                            return "please confirm password";
                                          } else if (value !=
                                              passwordController.text) {
                                            return 'password not matched';
                                          }
                                          return null;
                                        },
                                        inputFormatters: <TextInputFormatter>[
                                          LengthLimitingTextInputFormatter(8),
                                          // FilteringTextInputFormatter.allow(
                                          // //  RegExp(r'[0-8]'),
                                          // ),
                                          // FilteringTextInputFormatter.digitsOnly
                                        ],
                                        // maxLength: 10,
                                        decoration: const InputDecoration()
                                            .inputDecoration('Confirm Password',
                                                Icons.lock, null),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  AppTextField(
                                    controller: addressController,
                                    prefixIcon: Icons.location_city,
                                    hint: "Enter Address",
                                    validator: nameTextValidator,
                                    inputType: TextInputType.text,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  /*AppTextField(
                                    controller: refController,
                                    prefixIcon: Icons.vpn_key,
                                    hint: "Promo Code (Optional)",
                                    inputType: TextInputType.text,
                                    suffixIcon: Icons.check_circle,
                                  ),
                                  Align(
                                      alignment: Alignment.topRight,
                                      child: Text(
                                          '*You will have to pay INR ${setupCost}/-incl GST'))*/
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          isLoading ? Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),) : AppButton(
                            title: 'Sign Up',
                            onTab: () {
                              setState(() {
                                isLoading = true;
                              });
                              if (_formKey.currentState!.validate()) {
                                // sendOtp();
                                if (passwordController.text !=
                                    confirmController.text) {
                                  Fluttertoast.showToast(
                                      msg: "Password must be same");
                                } else {
                                  showDialogForPayment();
                                }
                                // registerUser();
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                // Fluttertoast.showToast(msg: "All Fields Are Required!");
                              }
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
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
                                  "Log In",
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
                                        builder: (context) => Login()
                                        //     VendorRegisteration(
                                        //   role: "0",
                                        // ),
                                        ),
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
  Function ? dialogMainState ;
  showDialogForPayment() async {
    await showDialog(
      context: context,
      builder: (context) =>StatefulBuilder(builder: (context, dialogSate) {
        dialogMainState = dialogSate ;
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

                      dialogSate((){
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
              AppButton(title: 'Pay & Signup', onTab: () async{

              await  getPaymentId(name: nameController.text,mobile: mobileController.text,email: emailController.text,amount: setupCost ?? '1',id: '1');

              CashFreeHelper razorPay =  CashFreeHelper(
                  orderId ?? '1', context,paymentSessionId, (result) async{
                  if (result != "error") {
                    //payOrder(widget.model.bookingId, result);
                    // buySubscription(index, result.toString());
                    userSignup(result);
                    Navigator.pop(context);

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

String ? discount ;
  Future<void> userSignup(result) async {

    setState(() {
      isLoading = true ;
    });
    String? token = await FirebaseMessaging.instance.getToken();
    var param = {
      "full_name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "address": addressController.text,
      "mobile": mobileController.text,
      "fcm_id": token
    };
    apiBaseHelper.postAPICall(getSignUpApi, param).then((value) async {
      bool error = value['status'] ?? false;
      String msg = value['message'] ?? '';

      if (error) {
        Fluttertoast.showToast(msg: 'User registered successfully!');
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('token', value['data']['user']['token'] ?? '');
       await addTransaction(transactionId: '${result}', promo: refController.text,token: '${value['data']['user']['token'] ?? ''}', amount: '${setupCost}', discount: discount ??'0');
        setState(() {
          isLoading = false ;
        });

          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ));

      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });
  }


  String? setupCost;

  String? monthRenewalCost;
  String? quarterlyRenewalCost;
  String? yearlyRenewalCost;

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
  bool status = false;


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
        dialogMainState!((){});
        print(setupCost);
      }else {
        Fluttertoast.showToast(msg: msg);
      }

      setState(() {});
    });
  }

  String? orderId;
  String? paymentSessionId;

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
      log(result);
      var finalResult = jsonDecode(result);

      orderId = finalResult['data']['response']['order_id'];
      paymentSessionId = finalResult['data']['response']['payment_session_id'];
    }
    else {
      print(response.reasonPhrase);
    }
  }


}
