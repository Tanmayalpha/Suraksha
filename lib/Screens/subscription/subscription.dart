import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:suraksha/Screens/pay_to_admin.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/api_services/apiStrings.dart';
import 'package:suraksha/Services/payment_service/cashFree_pay.dart';
import 'package:suraksha/Services/payment_service/razor_pay.dart';
import 'package:suraksha/model/login_model.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/globles.dart';
import 'package:suraksha/widgets/app_bar.dart';
import 'package:suraksha/widgets/app_btn.dart';
import 'package:http/http.dart'as http;

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen(
      {Key? key, this.token, this.planStatus, this.userData})
      : super(key: key);

  final String? token;

  final String? planStatus;

  final LoginResponse? userData;

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPlanCost();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Subscription', context: context),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(color: CustomColors.primaryColor),
            )
          : Padding(
              padding: EdgeInsets.all(20),
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return subscriptionCard(index);
                },
              ),
            ),
    );
  }

  bool status = false;

  Widget subscriptionCard(int index) {
    String endDate = index == 0
        ? DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(Duration(days: 29)))
        : index == 1
            ? DateFormat('yyyy-MM-dd')
                .format(DateTime.now().add(Duration(days: 179)))
            : DateFormat('yyyy-MM-dd')
                .format(DateTime.now().add(Duration(days: 364)));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              image: AssetImage("assets/images/subcription.png"),
              fit: BoxFit.fill,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              Text(
                index == 0
                    ? "Monthly"
                    : index == 1
                        ? "Half Yearly"
                        : "Yearly",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    color: CustomColors.whiteColor),
              ),
              SizedBox(
                height: 60,
              ),
              /*Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Sub Total: ₹ 400",style: TextStyle(color: CustomColors.secondaryColor,fontWeight: FontWeight.bold,fontSize: 16,
                  decorationThickness: 2,),),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text("Discount: ₹ 10",style: TextStyle(color: CustomColors.secondaryColor,fontWeight: FontWeight.bold,fontSize: 16,
                  decorationThickness: 2,),),
              ),*/
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  "Total: ₹ ${index == 0 ? monthRenewalCost : index == 1 ? halfYearlyRenewalCost : yearlyRenewalCost}",
                  style: TextStyle(
                    color: CustomColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decorationThickness: 2,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Subscription",
                  style: TextStyle(
                    color: CustomColors.secondaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    decorationThickness: 2,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text("Amount:"),
                        // ),
                        /*SizedBox(height: 8,),
                        Text("Time Slot:"),*/
                        /*SizedBox(height: 8,),
                        Text("Purchase Date:"),*/
                        SizedBox(
                          height: 8,
                        ),
                        Text("Start Date:"),
                        SizedBox(
                          height: 8,
                        ),
                        Text("End Date:"),
                        SizedBox(
                          height: 8,
                        ),
                        /*Text("Address:"),
                        SizedBox(height: 8,),*/
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text("₹ ${subscribedPlansListModel!.data![i].amount}",style: TextStyle(color: colors.secondary,fontWeight: FontWeight.bold,fontSize: 20,
                        //     decorationThickness: 2,),),
                        // ),
                        /*SizedBox(height: 8),
                         Text("No"),*/
                        /*SizedBox(height: 8),
                        Text( DateFormat('yyyy-MM-dd').format(DateTime.now()),style: TextStyle(color: CustomColors.blackTemp,fontWeight: FontWeight.bold)),*/
                        SizedBox(height: 8),
                        Text(DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            style: TextStyle(
                                color: CustomColors.blackTemp,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text(endDate,
                            style: TextStyle(
                                color: CustomColors.blackTemp,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        /*Text("123, Ganga Nagar, Indore",
                            style: TextStyle(color: CustomColors.blackTemp,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),*/
                      ],
                    )
                  ],
                ),
              ),
              widget.planStatus == '2'
                  ? Column(
                    children: [
                      Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: AppButton(
                              title: 'Renew',
                              onTab: () async {
                                await getPaymentId(
                                    name: widget.userData?.data?.user?.fullName,
                                    email: widget.userData?.data?.user?.email,
                                    mobile: widget.userData?.data?.user?.mobile,
                                    id: widget.userData?.data?.user?.tfaCode,
                                    amount: '${index == 0 ? monthRenewalCost : index == 1
                                        ? halfYearlyRenewalCost
                                        : yearlyRenewalCost}');

                                CashFreeHelper razorPay = CashFreeHelper(orderId ?? '1',context,paymentSessionId
                                    , (result) async {
                                  if (result != "error") {
                                    //payOrder(widget.model.bookingId, result);
                                    // buySubscription(index, result.toString());

                                    await addTransaction(
                                        transactionId: '${result}',
                                        amount:
                                            '${index == 0 ? monthRenewalCost : index == 1 ? halfYearlyRenewalCost : yearlyRenewalCost}',
                                        discount: '0',
                                        promo: '',
                                        token: widget.token ?? '',
                                        enDate: endDate);
                                    Navigator.pop(context);
                                    Fluttertoast.showToast(msg: 'Renewal success');
                                  } else {
                                    setState(() {
                                      status = false;
                                    });
                                  }
                                },);

                                setState(() {
                                  status = true;
                                });
                                razorPay.init();
                              }),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      AppButton(
                          title: 'Renew Manually',
                          onTab: () async {
                            Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PayScreen(
                                        userToken: widget.token ?? '',
                                        promo: '',
                                        amount: '${index == 0 ? monthRenewalCost : index == 1 ? halfYearlyRenewalCost : yearlyRenewalCost}',
                                        discount: '0',enddate: endDate,
                                    )));
                          })
                    ],
                  )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  String? monthRenewalCost;
  String? halfYearlyRenewalCost;
  String? yearlyRenewalCost;
  String? setupCost;

  bool isLoading = false;

  String? orderId;

  String? paymentSessionId;

  Future<void> getPaymentId(
      {String? name,
      String? email,
      String? mobile,
      String? amount,
      String? id}) async {
   /* var param = {
      "customer_id": id ?? "1",
      "customer_name": ,
      "customer_email": email ?? "shubhamsamnotra@gmail.com",
      "customer_phone": mobile ?? "9149970345",
      "order_amount": amount ?? 1
    };*/
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
      log('${result}');
      var finalResult = jsonDecode(result);

      orderId = finalResult['data']['response']['order_id'];
      paymentSessionId = finalResult['data']['response']['payment_session_id'];
    }
    else {
      print(response.reasonPhrase);
    }

    /*apiBaseHelper
        .postAPICall(createPaymentSessionApi, param)
        .then((getData) async {
      bool status = getData['status'] ?? true;
      String msg = getData['message'] ?? '';

      if (status) {
        //Fluttertoast.showToast(msg: '${getData['data']['response']}/- discount ${msg}');

        orderId = getData['data']['response']['order_id'];
        paymentSessionId = getData['data']['response']['payment_session_id'];
      } else {
        Fluttertoast.showToast(msg: msg);
      }
    });*/
  }

  Future<void> getPlanCost() async {
    setState(() {
      isLoading = true;
    });
    apiBaseHelper.getAPICall(getPlanCostApi).then((value) async {
      setupCost = value['data']['plan_details']['setup_cost'] ?? '';
      print(setupCost);
      monthRenewalCost =
          value['data']['plan_details']['monthly_renewal_cost'] ?? '';
      halfYearlyRenewalCost =
          value['data']['plan_details']['half_yearly_renewal_cost'] ?? '';
      yearlyRenewalCost =
          value['data']['plan_details']['yearly_renewal_cost'] ?? '';

      setState(() {});
      isLoading = false;
    });
  }
}
