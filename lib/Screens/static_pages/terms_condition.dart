import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:http/http.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/widgets/app_bar.dart';

import '../../Services/api_services/apiConstants.dart';




class TermsConditionsWidget extends StatefulWidget {
  const TermsConditionsWidget({super.key});

  @override
  State<TermsConditionsWidget> createState() => _TermsConditionsWidgetState();
}

class _TermsConditionsWidgetState extends State<TermsConditionsWidget> {
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
          //  backgroundColor: colors.bgColor,
            appBar: myAppBar(context: context, title: 'Terms & Conditions'),
        body: isLoading ? Center(child: CircularProgressIndicator(color: CustomColors.primaryColor,),) : SingleChildScrollView(
            child: Html(data: data,)) ));
  }

bool isLoading = false ;

  var data ;

  Future<void> getterms() async {
    setState(() {
      isLoading = true;
    });


    apiBaseHelper.getAPICall(Uri.parse('${baseUrl}getContent/terms')).then((value) {
      data = value['data'][0]['content'];
      setState(() {
        isLoading = false;
      });
    });

  }

}

      