import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suraksha/utils/colors%20.dart';

import 'login.dart';



class ForgetPassword extends StatefulWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor:CustomColors.whiteColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        foregroundColor: CustomColors.blackTemp,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 40,),
            SizedBox(
               width: MediaQuery.of(context).size.width,
               height: MediaQuery.of(context).size.height * 0.25,
               child: Image.asset(
                 'assets/logo/login logo.png',
                 // 'assets/images/login_logo.png',
                 fit: BoxFit.contain,
               ),
             ),
            const SizedBox(height: 20,),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              decoration: const BoxDecoration(
                  color: CustomColors.primaryColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45))),
              child: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    "Forget Password?",
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20.0, bottom: 20, left: 20, right: 20),
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.white,
                              //Theme.of(context).colorScheme.gray,
                            ),
                            child: Center(
                              child: TextFormField(
                                controller: emailController,
                                //validator: FormValidation.emailVeledetion,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty) {
                                    return 'Enter email';
                                  } else if(!RegExp(r'^[a-z||A-Z||0-9]+@[a-z]+\.[a-z]{2,3}')
                                      .hasMatch(value)){
                                    return 'Invalid Email';
                                  }
                                  return null;
                                },
                                keyboardType:
                                TextInputType.emailAddress,
                                // maxLength: 10,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  counterText: "",
                                  contentPadding: EdgeInsets.only(
                                      left: 15, top: 15),
                                  hintText: "Enter Email",
                                  hintStyle: TextStyle(
                                      color: CustomColors.blackTemp),
                                  // labelText: "Enter Email id",
                                  prefixIcon: Icon(
                                    Icons.email,
                                    color:
                                    CustomColors.secondaryColor,
                                    size: 24,
                                  ),
                                  // border: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(10),
                                  // ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        InkWell(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              // forget password
                            }
                          },
                          child: Container(
                            height: 43,
                            width:
                            MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(12),
                                color: CustomColors.secondaryColor),
                            child:
                            // isLoading ?
                            // loadingWidget():
                            const Center(
                                child: Text("Send",
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.black))),
                          ),
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ),


            GestureDetector(
              onTap: () {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>const Login()));
              },
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width/2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color:CustomColors.secondaryColor,
                  ),
                  child:const Center(
                    child: Text("Change Password",style: TextStyle(
                        color:CustomColors.whiteColor
                    )
                    ),
                  )
              ),
            ),

          ],
        ),
      ),
    );
  }
}
