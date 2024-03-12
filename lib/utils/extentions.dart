

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:suraksha/utils/colors%20.dart';

extension MyBoxDecoration on BoxDecoration {
  BoxDecoration myBoxDecoration(){
   return  BoxDecoration(gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        CustomColors.primaryColor,
        CustomColors.secondaryColor
      ],
    ),);
  }
}

extension MyHomeBoxDecoration on BoxDecoration {
  BoxDecoration myHomeBoxDecoration(){
    return  BoxDecoration(
        borderRadius:  BorderRadius.all(Radius.circular(42)),
        boxShadow: [
          BoxShadow(
            color: Colors.purple[200]?.withOpacity(0.6) ?? Colors.deepOrange,
            offset: const Offset(0, 20),
            blurRadius: 30,
            spreadRadius: -5,
          ),
        ],
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomCenter,
            colors: [
              Colors.purple[200]?.withOpacity(0.2) ?? Colors.deepOrange,
              Colors.purple[200]?.withOpacity(0.2) ?? Colors.deepOrange,
              Colors.purple[200]?.withOpacity(0.2) ?? Colors.deepOrange,
              Colors.purple[200]?.withOpacity(0.2) ?? Colors.deepOrange,
            ],
            stops: const [
              0.1,
              0.3,
              0.9,
              1.0
            ]));
  }
}

extension TextFieldDecoration on InputDecoration {
  InputDecoration inputDecoration(String? hint, IconData? prefixIcon,IconData? suffixIcon){
  return  InputDecoration(
      border: GradientOutlineInputBorder(
          gradient: LinearGradient(colors: [CustomColors.primaryColor, CustomColors.secondaryColor]),
          width: 2,borderRadius: BorderRadius.circular(30)
      ),
      filled: true,
      fillColor: Colors.white70,

      counterText: "",
      contentPadding:
      const EdgeInsets.only(left: 15, top: 12),
      hintText: hint,
      hintStyle: const TextStyle(
          color: CustomColors.blackTemp),
      prefixIcon:  Icon(
        prefixIcon,
        color: CustomColors.secondaryColor,
        size: 20,
      ),
    suffixIcon: Icon( suffixIcon,
      color: CustomColors.secondaryColor,
      size: 20,)
    );
  }
}