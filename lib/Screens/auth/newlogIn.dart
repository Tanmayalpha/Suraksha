import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:suraksha/Screens/auth/signup.dart';
import 'package:suraksha/Screens/auth/verify_otp.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/utils/app_images.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/app_textField.dart';

import '../../Services/api_services/apiStrings.dart';
import 'forget_password.dart';

class LoginClass extends StatefulWidget {
  const LoginClass({Key? key}) : super(key: key);

  @override
  State<LoginClass> createState() => _LoginStateClass();
}

class _LoginStateClass extends State<LoginClass> {
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  int _value = 1;
  bool isMobile = true;
  bool isLoading = false;
  var Otp;

  Future<void> loginWithEmail() async {
    /* var headers = {
      'Cookie': 'ci_session=6e34bdd97875ed796707c02295da6acd82c85782'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${loginWithMail}'));
    request.fields.addAll({
      'email': '${emailController.text}',
      'password': '${passwordController.text}'
    });
    print("login with email para ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("working@@@@@@@@@");
      var finalResponse = await response.stream.bytesToString();
      jsonResponse = json.decode(finalResponse);
      print("responseeee ${jsonResponse}");
      Fluttertoast.showToast(msg: jsonResponse!['message']);

      if (jsonResponse!['status'] == true) {
         final SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.setString('userId', jsonResponse!['data']["id"]);
        prefs.setBool("isLogIn", true);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => homeScreen()));
      }
    } else {
      Fluttertoast.showToast(msg: jsonResponse!['message']);
    }*/
  }

  Map? jsonResponse;

  Future<void> loginWithMobile() async {
    /*var headers = {
      'Cookie': 'ci_session=dd06823d744e84ad73a327e309c6f7b3575fc5b2'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${loginMobile}'));
    request.fields
        .addAll({'login_mobile': '${mobileController.text}', 'check': '2'});
    print("login with mobile para ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print("working---------");
      var finalResponse = await response.stream.bytesToString();
      jsonResponse = json.decode(finalResponse);
      print("responseeee ${jsonResponse}");
      Otp = (jsonResponse!['otp']);

      // Fluttertoast.showToast(msg: jsonResponse!['message']);
      if (jsonResponse!['status'] == true) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => VerifyOtp(
                      mobile: mobileController.text,
                      otp: Otp,
                    )));
        Fluttertoast.showToast(msg: jsonResponse!['message']);
      } else {
        Fluttertoast.showToast(msg: jsonResponse!['message']);
      }
    }*/
  }

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
                      width: MediaQuery.of(context).size.width/2,
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
                                    color: CustomColors.blackTemp, fontSize: 16),
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
                                style:
                                TextStyle(color: CustomColors.blackTemp, fontSize: 16),
                              ),
                            ],
                          ),
                          !isMobile
                              ? Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, bottom: 20, left: 20, right: 20),
                            child: Column(
                              children: [
                                AppTextField(
                                  controller: emailController,
                                  prefixIcon: Icons.email,
                                  hint: "Enter Email",
                                  validator: emailValidator,
                                  obscureText: true,
                                  inputType:TextInputType.emailAddress,
                                  inputFormatters: <TextInputFormatter>[
                                    LengthLimitingTextInputFormatter(8),
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
                                  inputType:TextInputType.text,

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
                                    if (_formKey.currentState!.validate()) {
                                      if (emailController.text.isEmpty ||
                                          passwordController.text.isEmpty) {
                                        Fluttertoast.showToast(
                                            msg:
                                            'Enter Email and Password');
                                      } else {
                                        loginWithEmail();
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
                                // loginWithMobile();
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> VerifyOtp()));
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


}
