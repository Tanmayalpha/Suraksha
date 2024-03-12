import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_borders/input_borders/gradient_outline_input_border.dart';
import 'package:suraksha/utils/colors%20.dart';
import 'package:suraksha/utils/extentions.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({Key? key, this.inputType,this.inputFormatters,this.prefixIcon,required this.controller, this.validator,this.hint, this.obscureText, this.suffixIcon}) : super(key: key);

 final TextEditingController controller ;
 final TextInputType? inputType ;
final  List<TextInputFormatter>? inputFormatters ;
  final String? hint ;
  final IconData? prefixIcon ;
  final IconData? suffixIcon ;
  final bool? obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 55,
      /*decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        //Theme.of(context).colorScheme.gray,
      ),*/
      child: Center(
        child: TextFormField(
          controller: controller,
          keyboardType: inputType,
          validator:  validator,
          obscureText: obscureText ?? false,
          inputFormatters: inputFormatters,
          style: TextStyle(fontSize: 14),
          decoration:  InputDecoration().inputDecoration(hint, prefixIcon, suffixIcon),
        ),
      ),
    );
  }
}
