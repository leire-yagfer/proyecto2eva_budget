// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:proyecto2eva_budget/view/loginsignup/loginregister.dart';
import 'package:proyecto2eva_budget/viewmodel/provider_ajustes.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';

void main() {
  //MultiProvider para los cambios
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProviderAjustes()),
        ChangeNotifierProvider(create: (context) => ThemeProvider())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ProviderAjustes>(
      builder: (context, ajustesProvider, child) {
        //Bloqueo de orientación -> solo permite vertical
        SystemChrome.setPreferredOrientations(
            [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

        return MaterialApp(
          debugShowCheckedModeBanner: false, //Desactivar el banner de debug
          title: 'MoneyTracker',

          //Declaración de los temas
          theme: ThemeData(
              brightness: (context.watch<ThemeProvider>().isLightModeActive)
                  ? Brightness.light
                  : Brightness.dark),

          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: ajustesProvider.idioma, //Idioma de la aplicación
          supportedLocales: const [
            Locale('es'),
            Locale('en'),
          ],
          home: LoginSignupPage(),
        );
      },
    );
  }
}