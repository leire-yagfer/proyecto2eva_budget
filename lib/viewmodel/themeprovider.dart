import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool isLightModeActive = true;

  //Los sigueintes colores es siguiendo el modo claro de la app (isLightModeActive == true)
  Map<String, Color> palette() => {
        //General
        "textBlackWhite": (isLightModeActive) ? Colors.black : Colors.white,
        "buttonBlackWhite": (isLightModeActive) ? Colors.black : Colors.white,
        "fixedBlack": Colors.black,
        "fixedWhite": Colors.white,
        "fixedLightGrey": Colors.grey,
        //Navegación inferior y pestañas
        "selectedItem": Colors.pink,
        "unselectedItem": (isLightModeActive) ? Colors.black : Colors.white,
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
