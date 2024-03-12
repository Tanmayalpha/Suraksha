import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/api_services/apiStrings.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/widgets/app_bar.dart';
import 'package:suraksha/widgets/app_btn.dart';

import '../model/getTransaction_response.dart';

class Wallet extends StatefulWidget {
  final LoginResponse? loginResponse;

  const Wallet({Key? key, this.loginResponse}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
  bool change = true;

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
    print(change);
  }

  String? uid;
  String? type;
  String? wallet;
  String? referralCode;
  String? userName;
  bool show = false;
  bool isUpi = false;
  int? _value = 1;

  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();
  TextEditingController confmAccountNumController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController upiController = TextEditingController();
  List accountType = ['Savings', 'Current'];
  var accTypeValue;
  GetTransactionsResponse? getTransactionsResponse;

  //WalletTransactionsModel? walletTransactionsModel;
  Future getWithdrawlHistory() async {
    var parm = {"user_id": widget.loginResponse?.data?.user?.token};
    apiBaseHelper.postAPICall(getTransactionApi, parm).then((value) {
      bool status = value['status'];
      String msg = value['message'];
      if (status) {
        getTransactionsResponse = GetTransactionsResponse.fromJson(value);
        setState(() {});
      } else {}
    });
  }

  Future withdrawRequest() async {

    /*var request = http.MultipartRequest(
        'POST', Uri.parse('${Apipath.withdrawRequestUrl}'));
    request.fields.addAll({
      'user_id': '${userId.toString()}',
      'amount': '${amountController.text.toString()}',
      'upi_id':'${upiController.text.toString()}',
      'ac_no': '${accountNoController.text.toString()}',
      'ac_holder_name': '${accountHolderController.text.toString()}',
      'ifsc_code': '${ifscController.text.toString()}',
      'bank_name': '${bankNameController.text.toString()}',
      'account_type': accTypeValue == null ? "" : '${accTypeValue.toString()}'
    });
    print("this is request !! ${request.fields}");

    http.StreamedResponse response = await request.send();
    print("this is request !! 11111${response}");
    if (response.statusCode == 200) {
      print("this response @@ ${response.statusCode}");
      final str = await response.stream.bytesToString();
      Fluttertoast.showToast(msg: "Request sent successfully!!");
    } else {
      return null;
    }*/
    var parm = {
      "user_id": widget.loginResponse?.data?.user?.token,
      'description': '{"upi": ${upiController.text
          .toString()},"ac_no":${accountNoController.text
          .toString()}, "ac_holder_name":${accountHolderController.text
          .toString()},"ifsc_code": ${ifscController.text.toString()}, "bank_name":${bankNameController.text.toString()},"account_type": ${accTypeValue == null ? "" : '${accTypeValue.toString()}}'}',
      'amount':amountController.text.toString(),
    };
    apiBaseHelper.postAPICall(getWidrawalRequestApi, parm).then((value) {
      bool status = value['status'];
      String msg = value['message'];
      if (status) {
        Fluttertoast.showToast(msg: msg);
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });
  }

  void checkingLogin() async {
    /*SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uid = prefs.getString(TokenString.userid).toString();
      type = prefs.getString(TokenString.type).toString();
      wallet = prefs.getString(TokenString.walletBalance).toString();
      referralCode = prefs.getString(TokenString.referralCode).toString();
      userName = prefs.getString(TokenString.userName).toString();
    });
    print("this id uid ${uid.toString()} aand ${type}");*/
  }

  void initState() {
    super.initState();
    //checkingLogin();
    getWithdrawlHistory();
    // Future.delayed(Duration(milliseconds: 500), () {
    //   return getprofile();
    // });
  }

  //GetProfileModel? profileModel;
  int _selectedIndex = 0;

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      appBar: myAppBar(title: 'My Wallet', context: context),
      body: Container(
        height: MediaQuery
            .of(context)
            .size
            .height,
        //  decoration: BoxDecoration().myBoxDecoration(),
        color: CustomColors.whiteColor,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                          child: Text(
                            "Available Balance",
                            style: TextStyle(
                                fontSize: 25, color: CustomColors.blackTemp),
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          widget.loginResponse?.data?.user?.wallet_balance ==
                              null ||
                              widget.loginResponse?.data?.user
                                  ?.wallet_balance ==
                                  ""
                              ? " ₹ 0"
                              : "₹ ${widget.loginResponse?.data?.user
                              ?.wallet_balance.toString()}",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.w600,
                              color: CustomColors.blackTemp),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AppButton(
                        title: 'Withdraw Amount',
                        onTab: () {
                          setState(() {
                            show = !show;
                          });
                        },
                      ),
                      Visibility(
                          visible: show,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 10, left: 10),
                                child: Text(
                                  'Amount',
                                  style:
                                  TextStyle(color: CustomColors.blackTemp),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, bottom: 10),
                                child: Container(
                                  // height: 50,
                                  child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: amountController,
                                      validator: (msg) {
                                        if (msg!.isEmpty) {
                                          return "Please Enter Amount";
                                        }
                                        // else if(int.parse(wallet.toString())< int.parse(msg) ){
                                        //   return "Please enter amt less or equal to your wallet amount";
                                        // }
                                      },
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(15)))
                                    // decoration: InputDecoration(
                                    //   border: OutlineInputBorder(),
                                    // ),
                                  ),
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                          value: 1,
                                          fillColor:
                                          MaterialStateColor.resolveWith(
                                                  (states) =>
                                              CustomColors.blackTemp),
                                          groupValue: _value,
                                          onChanged: (int? value) {
                                            setState(() {
                                              _value = value!;
                                              isUpi = false;
                                            });
                                          }),
                                      Text(
                                        "Bank Upi",
                                        style: TextStyle(
                                            color: CustomColors.blackTemp),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Radio(
                                          value: 2,
                                          fillColor:
                                          MaterialStateColor.resolveWith(
                                                  (states) =>
                                              CustomColors.blackTemp),
                                          groupValue: _value,
                                          onChanged: (int? value) {
                                            setState(() {
                                              _value = value!;
                                              isUpi = true;
                                            });
                                          }),
                                      Text(
                                        "Bank Account",
                                        style: TextStyle(
                                            color: CustomColors.blackTemp),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              isUpi == false
                                  ? Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('UPI Id',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 50,
                                    child: TextFormField(
                                        controller: upiController,
                                        validator: (msg) {
                                          if (msg!.isEmpty) {
                                            return "Please Enter UPI Id ";
                                          }
                                        },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15)))
                                      // decoration: InputDecoration(
                                      //   border: OutlineInputBorder(),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  AppButton(
                                    title: 'Submit',
                                    onTab: () {
                                      if (amountController
                                          .text.isNotEmpty) {
                                        if (double.parse(amountController
                                            .text
                                            .toString()) <=
                                            double.parse(
                                                widget.loginResponse?.data?.user?.wallet_balance.toString() ?? '0.0')) {
                                          if (upiController
                                              .text.isNotEmpty) {
                                            withdrawRequest();
                                          } else {
                                            Fluttertoast.showToast(
                                                msg:
                                                "Please enter valid Upi ID");
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                              "Withdraw amount is not more than available amount!");
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg:
                                            "Please enter amount you want to withdraw!");
                                      }
                                    },
                                  )
                                ],
                              )
                                  : SizedBox.shrink(),
                              isUpi == true
                                  ? Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('Account Holder Name',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 50,
                                    child: TextFormField(
                                        controller:
                                        accountHolderController,
                                        // validator: (msg) {
                                        //   if (msg!.isEmpty) {
                                        //     return "Please Enter Account Holder Name ";
                                        //   }
                                        // },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15)))
                                      // decoration: InputDecoration(
                                      //   border: OutlineInputBorder(),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('Account Number',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 50,
                                    child: TextFormField(
                                        controller: accountNoController,
                                        keyboardType:
                                        TextInputType.number,
                                        validator: (msg) {
                                          if (msg!.isEmpty) {
                                            return "Please Enter Account Number";
                                          }
                                        },
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15)))
                                      // decoration: InputDecoration(
                                      //   border: OutlineInputBorder(),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('Confirm Account Number',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 50,
                                    child: TextFormField(
                                        controller:
                                        confmAccountNumController,
                                        keyboardType:
                                        TextInputType.number,
                                        validator: (msg) {
                                          if (msg !=
                                              confmAccountNumController
                                                  .text) {
                                            return "Account number and confirm account number must be same";
                                          }
                                        },
                                        decoration: InputDecoration(
                                            counterText: "",
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15)))
                                      // decoration: InputDecoration(
                                      //   border: OutlineInputBorder(),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('Bank Name',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 50,
                                    child: TextFormField(
                                        controller: bankNameController,
                                        // validator: (msg) {
                                        //   if (msg!.isEmpty) {
                                        //     return "Please Enter Bank Name ";
                                        //   }
                                        // },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15)))
                                      // decoration: InputDecoration(
                                      //   border: OutlineInputBorder(),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('IFSC Code',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    // height: 50,
                                    child: TextFormField(
                                        controller: ifscController,
                                        // validator: (msg) {
                                        //   if (msg!.isEmpty) {
                                        //     return "Please Enter IFSC Code";
                                        //   }
                                        // },
                                        decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    15)))
                                      // decoration: InputDecoration(
                                      //   border: OutlineInputBorder(),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 10),
                                    child: Text('Account Type',
                                        style: TextStyle(
                                            color:
                                            CustomColors.blackTemp)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 10),
                                    child: Container(
                                      height: 60,
                                      padding: EdgeInsets.only(left: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          border: Border.all(
                                              color: Colors.black
                                                  .withOpacity(0.7))),
                                      child: DropdownButton(
                                        // Initial Value
                                        value: accTypeValue,
                                        underline: Container(),
                                        isExpanded: true,
                                        // Down Arrow Icon
                                        icon: Icon(
                                            Icons.keyboard_arrow_down),
                                        hint: Text("Select Account Type",
                                            style: TextStyle(
                                                color: CustomColors
                                                    .blackTemp)),
                                        // Array list of items
                                        items: accountType.map((items) {
                                          return DropdownMenuItem(
                                            value: items,
                                            child: Container(
                                                child: Text(
                                                    items.toString())),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (newValue) {
                                          setState(() {
                                            accTypeValue = newValue!;
                                            print(
                                                "selected category ${accTypeValue
                                                    .toString()}");
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  AppButton(
                                    title: "Submit",
                                    onTab: (){
                                      if(amountController.text.isNotEmpty){
                                        if(accountNoController.text.isNotEmpty
                                            && accountHolderController.text.isNotEmpty &&
                                        bankNameController.text.isNotEmpty && ifscController.text.isNotEmpty
                                        ){
                                          if(accountNoController.text.toString() == confmAccountNumController.text.toString()){
                                            withdrawRequest();
                                          }else{
                                            Fluttertoast.showToast(msg: "Account no. and confirm account no. should be same");
                                          }

                                        }else{
                                          Fluttertoast.showToast(msg: "Please enter valid Bank Details");
                                        }
                                      }else{
                                        Fluttertoast.showToast(msg: "Please enter amount you want to withdraw!");
                                      }
                                    },
                                  )
                                ],
                              )
                                  : SizedBox.shrink(),
                            ],
                          )),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 15, left: 8.0, bottom: 10),
                        child: Text(
                          "Transactions",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: CustomColors.blackTemp),
                        ),
                      ),
                      Divider(),
                      getTransactionsResponse == null
                          ? Center(
                        child: CircularProgressIndicator(
                          color: CustomColors.primaryColor,
                        ),
                      )
                          : getTransactionsResponse?.data?.isEmpty ?? true
                          ? Text('Transaction not available! ')
                          : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount:
                        getTransactionsResponse?.data?.length ??
                            0,
                        itemBuilder: (context, index) {
                          var item =
                          getTransactionsResponse?.data?[index];
                          return Card(
                            elevation: 2.0,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'Amount: ${walletModel?.walletAmount ?? ""}',
                                  //   style: const TextStyle(
                                  //       fontSize: 14.0, fontWeight: FontWeight.bold),
                                  // ),
                                  // const SizedBox(height: 5.0),
                                  Text(
                                    'Ammount: ${item!.amount}',
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontFamily: 'rubic'),
                                  ),
                                  //const SizedBox(height: 5.0),
                                  /*Text(
                                              'Credit Amount : ${item?.createdAt}',
                                              style: const TextStyle(
                                                  fontSize: 15.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.green,
                                                  fontFamily: 'rubic'),
                                            ),*/
                                  Text(
                                    'Debit on : ${DateFormat('dd MMM yyyy').format(DateTime.parse(item.updatedAt ?? ''))}',
                                    style: const TextStyle(
                                        fontSize: 15.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red,
                                        fontFamily: 'rubic'),
                                  ),
                                ],
                              ),
                            ),
                          );
                          ;
                        },
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  var bankDetails;
}

class WithdrawWalletAmount extends StatefulWidget {
  const WithdrawWalletAmount({Key? key}) : super(key: key);

  @override
  State<WithdrawWalletAmount> createState() => _WithdrawWalletAmountState();
}

class _WithdrawWalletAmountState extends State<WithdrawWalletAmount> {
  TextEditingController accountHolderController = TextEditingController();
  TextEditingController accountNoController = TextEditingController();
  TextEditingController ifscController = TextEditingController();

  // TextEditingController accountTypeController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  List accountType = ['Savings', 'Current'];
  var accTypeValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryColor,
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text("Wallet"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 5),
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              decoration: BoxDecoration(
                  color: CustomColors.secondaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  )),
              child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      )),
                  child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Account Holder Name'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // height: 50,
                            child: TextFormField(
                                controller: accountHolderController,
                                // validator: (msg) {
                                //   if (msg!.isEmpty) {
                                //     return "Please Enter Account Holder Name ";
                                //   }
                                // },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)))
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(),
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Account Number'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // height: 50,
                            child: TextFormField(
                                controller: accountNoController,
                                keyboardType: TextInputType.number,
                                // validator: (msg) {
                                //   if (msg!.isEmpty) {
                                //     return "Please Enter Account Number";
                                //   }
                                // },
                                decoration: InputDecoration(
                                    counterText: "",
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)))
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(),
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Bank Name'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // height: 50,
                            child: TextFormField(
                                controller: bankNameController,
                                // validator: (msg) {
                                //   if (msg!.isEmpty) {
                                //     return "Please Enter Bank Name ";
                                //   }
                                // },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)))
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(),
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('IFSC Code'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            // height: 50,
                            child: TextFormField(
                                controller: ifscController,
                                // validator: (msg) {
                                //   if (msg!.isEmpty) {
                                //     return "Please Enter IFSC Code";
                                //   }
                                // },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                        BorderRadius.circular(15)))
                              // decoration: InputDecoration(
                              //   border: OutlineInputBorder(),
                              // ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text('Account Type'),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(top: 5.0, bottom: 10),
                            child: Container(
                              height: 60,
                              padding: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.7))),
                              child: DropdownButton(
                                // Initial Value
                                value: accTypeValue,
                                underline: Container(),
                                isExpanded: true,
                                // Down Arrow Icon
                                icon: Icon(Icons.keyboard_arrow_down),
                                hint: Text("Select Account Type"),
                                // Array list of items
                                items: accountType.map((items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Container(
                                        child: Text(items.toString())),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (newValue) {
                                  setState(() {
                                    accTypeValue = newValue!;
                                    print(
                                        "selected category ${accTypeValue
                                            .toString()}");
                                  });
                                },
                              ),
                            ),
                          ),
                          AppButton(title: 'Withdraw', onTab: () {})
                        ],
                      ))),
            ),
          ],
        ),
      ),
    );
  }
}
