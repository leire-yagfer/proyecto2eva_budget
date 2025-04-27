// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto2eva_budget/reusable/reusablemainbutton.dart';
import 'package:proyecto2eva_budget/view/principal.dart';
import 'package:proyecto2eva_budget/view/loginsignup/mixinloginlogout.dart';


class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> with LoginLogoutDialog {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.3),
          ReusableMainButton(
              onClick: () {
                showLoginDialog(context);
              },
              textButton: AppLocalizations.of(context)!.signin,
              colorButton: 'buttonWhiteBlack'),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          ReusableMainButton(
              onClick: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Principal()));
              },
              textButton: AppLocalizations.of(context)!.register,
              colorButton: 'buttonBlackWhite'),
        ],
      ),
    );
  }
}
