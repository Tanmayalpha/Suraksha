
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:suraksha/Services/api_services/apiConstants.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/widgets/app_bar.dart';


class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getterms();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            //backgroundColor: C.bgColor,
            appBar: myAppBar(context: context, title: 'Privacy & Policy'),
            body: isLoading ? const Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),)  : SingleChildScrollView(child: Html(data: data,))));
  }

  bool isLoading = false ;

  var data ;


  Future<void> getterms() async {
    setState(() {
      isLoading = true;
    });


    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}getContent/privacy')).then((value) {
      data = value['data'][0]['content'];
      setState(() {
        isLoading = false;
      });
    });

  }
}
