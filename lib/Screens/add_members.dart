import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_bar.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:suraksha/widgets/app_textField.dart';

import '../Services/api_services/apiConstants.dart';
import '../Services/api_services/apiStrings.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({Key? key}) : super(key: key);

  @override
  State<AddMemberScreen> createState() => _AddMemberState();
}

class _AddMemberState extends State<AddMemberScreen> {

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  bool isLoading = false ;
  String? userToken ;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInItData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Add member', context: context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
            key: _formkey,
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
                AppTextField(
                  controller: addressController,
                  prefixIcon: Icons.location_city,
                  hint: "Address",
                  validator: nameTextValidator,
                  inputType: TextInputType.text,
                ),
                const SizedBox(
                  height: 50.0,
                ),
                AppButton(
                  title: 'Add Member',
                  onTab: () {
                    setState(() {
                      isLoading = true;
                    });
                    if(_formkey.currentState!.validate()){
                      userSignup();
                    }else{
                      setState((){
                        isLoading = false;
                      });
                      // Fluttertoast.showToast(msg: "All Fields Are Required!");
                    }
                  },
                ),
              ],
            )),
      ),
    );
  }

 getInItData() async{
   SharedPreferences preferences = await SharedPreferences.getInstance();
   userToken = preferences.getString('token');

 }
  Future<void> userSignup() async {

    var param = {
      "full_name": nameController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "address": addressController.text,
      "mobile": mobileController.text,
      "parent_id": userToken,
    };
    apiBaseHelper.postAPICall(getSignUpApi, param).then((value) async {
      bool error = value['status'] ?? true;
      String msg = value['message'] ?? '';

      if (error) {
        Fluttertoast.showToast(msg: 'User registered successfully!');
        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });
  }
}
