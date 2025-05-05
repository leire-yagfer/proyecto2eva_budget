import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isLightModeActive = true;

  //Los sigueintes colores es siguiendo el modo claro de la app (isLightModeActive == true)
  Map<String, Color> palette() => {
        //General
        "scaffoldBackground": (isLightModeActive) ? Color.fromARGB(255, 242, 242, 247) : Color.fromARGB(255, 28, 28, 30),
        "textBlackWhite": (isLightModeActive) ? Color.fromARGB(222, 0, 0, 0) : Color.fromARGB(255, 229, 229, 234),
        "buttonBlackWhite": (isLightModeActive) ? Color.fromARGB(222, 0, 0, 0) : Color.fromARGB(255, 229, 229, 234),
        "buttonWhiteBlack": (isLightModeActive) ? Color.fromARGB(255, 229, 229, 234) : Color.fromARGB(222, 0, 0, 0),
        "fixedBlack": Color.fromARGB(222, 0, 0, 0),
        "fixedWhite": Color.fromARGB(255, 229, 229, 234),
        "fixedLightGrey": Colors.grey,
        //Navegación inferior y pestañas
        "selectedItem": Colors.pink,
        "unselectedItem": (isLightModeActive) ? Color.fromARGB(222, 0, 0, 0) : Color.fromARGB(255, 229, 229, 234),
        "labelColor": Colors.pink,
        //Botones
        "greenButton": Color.fromARGB(255, 116, 212, 148),
        "redButton": Color.fromARGB(255, 212, 103, 103),
      };

  //cambiar modo claro/oscuro
  void changeThemeMode() {
    isLightModeActive = !isLightModeActive;
    notifyListeners();
  }
}
