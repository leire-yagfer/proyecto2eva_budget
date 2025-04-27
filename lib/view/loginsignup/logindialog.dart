import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:proyecto2eva_budget/reusable/reusablemainbutton.dart';
import 'package:proyecto2eva_budget/reusable/reusablerowloginregister.dart';
import 'package:proyecto2eva_budget/view/principal.dart';
import 'package:proyecto2eva_budget/view/loginsignup/mixinloginlogout.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';

class LogInDialog extends StatefulWidget {
  LogInDialog({super.key});

  @override
  State<LogInDialog> createState() => _LogInDialogState();
}

class _LogInDialogState extends State<LogInDialog> with LoginLogoutDialog {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible =
      false; // Variable para controlar la visibilidad de la contraseña

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.02),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.emailhint,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.emailerror;
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.passwordsi,
                  hintText: AppLocalizations.of(context)!.passwordhintsi,
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
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!.passworderror;
                  }
                  return null;
                },
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              ReusableRowLoginSignup(
                text1: AppLocalizations.of(context)!.singupinsignin1,
                text2: AppLocalizations.of(context)!.singupinsignin2,
                onClick: () {
                  Navigator.pop(context);
                  showRegisterDialog(context);
                },
              ),
              ReusableMainButton(
                  onClick: () {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Principal()));
                  },
                  textButton: AppLocalizations.of(context)!.signin,
                  colorButton: 'buttonWhiteBlack')
            ],
          ),
        ),
      ),
    );
  }
}
