import 'package:flutter/material.dart';
import 'package:immunelink/screens/signin_screen.dart';
import 'package:immunelink/screens/singup_screen.dart';

class WelcomeButton extends StatelessWidget {
  const WelcomeButton({super.key, required this.buttonText, this.onTap, this.color, this.textColor});
  final String buttonText;
  final Widget? onTap;
  final Color? color;
  final Color? textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (e) => onTap! ),);
      },
      child: Container(
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: color!,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40),
          ),
        ),
        child: Text(buttonText,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor!,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}