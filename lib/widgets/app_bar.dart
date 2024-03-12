import 'package:flutter/material.dart';
import 'package:suraksha/utils/colors%20.dart';


AppBar myAppBar({required String title,required BuildContext context}){
  return AppBar(
    backgroundColor: CustomColors.primaryColor,
    elevation: 5,shadowColor: CustomColors.secondaryColor,
    leading: InkWell(
        onTap: (){
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios,color: CustomColors.whiteColor,)),
    centerTitle: true,
    title: Text(
      title,
      style: TextStyle(fontSize: 20,color: CustomColors.whiteColor),
    ),
    actions: [SizedBox(width: 20,)],
  );
}