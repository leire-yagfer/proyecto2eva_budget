// ignore_for_file: annotate_overrides, overridden_fields, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proyecto2eva_budget/reusable/reusablemainbutton.dart';
import 'package:proyecto2eva_budget/reusable/reusablerowloginregister.dart';
import 'package:proyecto2eva_budget/view/principal.dart';
import 'package:proyecto2eva_budget/view/loginsignup/mixinloginregisterlogout.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';

//clase que implementa el dopDownButton de selección de país, ya que es de tipo stateful
class SignupDialog extends StatefulWidget {
  @override
  _SignupDialogState createState() => _SignupDialogState();
}

class _SignupDialogState extends State<SignupDialog> with LoginLogoutDialog {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatedpasswordController =
      TextEditingController();
  final _emailKey = GlobalKey<FormFieldState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  final _repeatedPasswordKey = GlobalKey<FormFieldState>();

  bool _isPasswordVisible =
      false; // Variable para controlar la visibilidad de la contraseña

  @override
  void dispose() {
    _passwordController.dispose();
    _repeatedpasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: SingleChildScrollView(
              child: Padding(
            padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: _emailKey,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.email,
                      hintText: AppLocalizations.of(context)!.email,
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.invalidemail;
                      }
                      String emailPattern =
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
                      RegExp regex = RegExp(emailPattern);
                      if (!regex.hasMatch(value)) {
                        return AppLocalizations.of(context)!.invalidemail;
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextFormField(
                    key: _passwordKey,
                    obscureText: !_isPasswordVisible,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.passwordr,
                      hintText: AppLocalizations.of(context)!.passwordhintr,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: context
                              .watch<ThemeProvider>()
                              .palette()['buttonBlackWhite']!,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          _passwordController.text.length < 6) {
                        return AppLocalizations.of(context)!.newpassworderror;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _passwordKey.currentState!.validate();
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  TextFormField(
                    key: _repeatedPasswordKey,
                    obscureText: !_isPasswordVisible,
                    controller: _repeatedpasswordController,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.repeatpassword,
                      hintText:
                          AppLocalizations.of(context)!.repeatpasswordhint,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: context
                              .watch<ThemeProvider>()
                              .palette()['buttonBlackWhite']!,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          value != _passwordController.text) {
                        return AppLocalizations.of(context)!
                            .nocoincidencedpasswords;
                      }
                      return null;
                    },
                    onChanged: (value) {
                      _repeatedPasswordKey.currentState!.validate();
                    },
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ReusableRowLoginSignup(
                    text1: AppLocalizations.of(context)!.signininsignup1,
                    text2: AppLocalizations.of(context)!.signininsignup2,
                    onClick: () {
                      Navigator.pop(context);
                      showLoginDialog(context);
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  ReusableMainButton(
                      onClick: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Principal()));
                      },
                      textButton: AppLocalizations.of(context)!.register,
                      colorButton: 'buttonWhiteBlack',
                      colorTextButton: 'buttonBlackWhite',
                      buttonHeight: 0.08,
                      buttonWidth: 0.5),
                ],
              ),
            ),
          ))),
    );
  }
}
