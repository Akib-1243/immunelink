import 'package:flutter/material.dart';
import 'package:immunelink/screens/custom_scaffold.dart';
import 'package:immunelink/screens/signin_screen.dart';
import 'package:immunelink/screens/singup_screen.dart';
import 'package:immunelink/screens/welcome_button.dart';

class WelcomeScreen extends StatelessWidget{
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
   return CustomScaffold(
     child: Column(
       children: [
         Flexible(
           flex: 8,
             child: Container(
           padding: const EdgeInsets.symmetric(
               vertical: 0.0,
               horizontal: 40.0,
           ),
           child: Center(
               child: RichText(
                 textAlign: TextAlign.center,
                 text: const TextSpan(
                   children: [
                     TextSpan(
                       text: 'Welcome to ImmuneLink\n',
                       style: TextStyle(
                         fontSize: 45,
                         fontWeight: FontWeight.w600,
                         color: Colors.white,
                       ),
                     ),
                     TextSpan(
                       text: '\nGet vaccine faster',
                       style: TextStyle(
                         fontSize: 20,
                         fontWeight: FontWeight.w600,
                         color: Colors.white,
                       ),
                     )
                   ]
                 ),
               )
           ),
         )),
         Flexible(
           flex: 1,
           child: Align(
             alignment: Alignment.bottomRight,
             child: Row(
               children: [
                 Expanded(
                     child: WelcomeButton(
                       buttonText: 'Sign In',
                       onTap: SignInScreen(),
                       color: Colors.transparent,
                       textColor: Colors.white,
                     )
                 ),
                 Expanded(
                     child: WelcomeButton(
                       buttonText: 'Sign Up',
                       onTap: SignUpScreen(),
                       color: Colors.white,
                       textColor: Colors.blue,
                     )
                 ),
               ],
             ),
           ),
         ),
       ],
     )
   );
  }

}