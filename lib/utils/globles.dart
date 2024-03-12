



import 'package:fluttertoast/fluttertoast.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/Services/api_services/apiStrings.dart';

String? mobileValidator(String? value) {
  if (value == null || value.isEmpty || value.length < 10) {
    return 'This value is required';
  }
  return null;
}

String? passwordValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      value.length != 8) {
    return 'This value is required';
  }
  return null;

}

String? emailValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      !RegExp(r'^[a-z||A-Z||0-9]+@[a-z]+\.[a-z]{2,3}')
          .hasMatch(value)) {
    return 'This value is required';
  }
  return null;

}

String? nameTextValidator(String? value) {
  if (value!.isEmpty) {
    return "Please Enter your name!";
  }
  return null;

}
String? confirmPassValidator(String? value, String value2) {
  if ((value == null ||
      value.isEmpty) && value2.isNotEmpty ) {
    return "please confirm password";
  }
  else if(value != value2){
    return 'password not matched';
  }
  return null;

}

Future<void> addTransaction(
    {required String transactionId,
   required String amount,
   required String discount,
   required String promo,
   required String token, String? enDate}) async {

  bool status = false ;
  var prm = {
  "transaction_id" : transactionId,
  'transaction_details': '',
  'amount': amount,
  'discount': discount,
  'promo_code': promo,
  'type_id': '1',
  'user_id':token
  };
       if(enDate !=null){
           prm['plan_ends'] = enDate ;
          }
  apiBaseHelper.postAPICall(addTransactionApi, prm).then((getData) {

    print('${getData}');

     status = getData['status'];
    String msg= getData['message'];

    if(status){
      status = true ;
      print('______________________');
    }else {
      status = false ;
      Fluttertoast.showToast(msg: msg);
    }


  });
}