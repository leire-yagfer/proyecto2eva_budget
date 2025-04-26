import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Clase que gestiona el estado global de la app
class ProviderAjustes extends ChangeNotifier{
  bool _modoOscuro = false;
  Locale _idioma = Locale('es');

  ///Cargar las preferencias guardadas al iniciar la app
  ProviderAjustes() {
    _cargarPreferencias();
  }

  //Obtener el estado actual del modo oscuro
  bool get modoOscuro => _modoOscuro;

  //Obtener el idioma actual
  Locale get idioma => _idioma;

  ///Cambiar el modo oscuro y guardar la preferencia
  Future<void> cambiarModoOscuro(bool valor) async {
    _modoOscuro = valor;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('modoOscuro', valor);
  }

  ///Cambiar el idioma y guardar la preferencia
  Future<void> cambiarIdioma(String codigoIdioma) async {
    _idioma = Locale(codigoIdioma);
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('idioma', codigoIdioma);
  }

  ///Cargar las preferencias guardadas en el dispositivo
  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _modoOscuro = prefs.getBool('modoOscuro') ?? false;
    _idioma = Locale(prefs.getString('idioma') ?? 'es');
    notifyListeners();
  }
}