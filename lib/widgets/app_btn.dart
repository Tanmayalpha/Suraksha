import 'package:flutter/material.dart';
import 'package:suraksha/utils/colors%20.dart';

class AppButton extends StatelessWidget {
  const AppButton({Key? key,required this.title,required this.onTab}) : super(key: key);

  final String title ;
  final VoidCallback onTab ;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width/1.3,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [CustomColors.primaryColor, CustomColors.secondaryColor],
          ),
          boxShadow: [
            BoxShadow(
              color: CustomColors.blackTemp.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onTab,
          style: TextButton.styleFrom(shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),),

          child:  Text(
            title,
            style: const TextStyle(
              color: CustomColors.whiteColor,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
