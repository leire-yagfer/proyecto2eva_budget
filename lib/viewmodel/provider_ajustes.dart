import 'package:flutter/material.dart';
import 'package:proyecto2eva_budget/model/models/crud/transaccionescrud.dart';
import 'package:proyecto2eva_budget/model/models/divisa.dart';
import 'package:proyecto2eva_budget/model/models/transaccion.dart';
import 'package:proyecto2eva_budget/model/services/apicambiodivisa.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Clase que gestiona el estado global de la app
class ProviderAjustes extends ChangeNotifier {
  bool _modoOscuro = false;
  Locale _idioma = Locale('es');
  Divisa _divisaEnUso = APIUtils.getFromList('EUR')!;
  //lista de transacciones
  List<Transaccion> listaTransacciones = [];

  ///Cargar las preferencias guardadas al iniciar la app
  ProviderAjustes() {
    _cargarPreferencias();
  }

  //Obtener el estado actual del modo oscuro
  bool get modoOscuro => _modoOscuro;

  //Obtener el idioma actual
  Locale get idioma => _idioma;

  //Obetener la divisa en la que se está trabajando
  Divisa get divisaEnUso => _divisaEnUso;

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

  ///Cambiar la divisa y guardar la preferencia
  Future<void> cambiarDivisa(Divisa nuevaDivisa) async {
    _divisaEnUso = nuevaDivisa;
    await cargarTransacciones(); //Recargar las transacciones con la nueva divisa
  
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('divisaEnUso', nuevaDivisa.codigo_divisa);
  }

  ///Cargar las preferencias guardadas en el dispositivo
  Future<void> _cargarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    _modoOscuro = prefs.getBool('modoOscuro') ?? false;
    _idioma = Locale(prefs.getString('idioma') ?? 'es');
    _divisaEnUso =
        APIUtils.getFromList(prefs.getString('divisaEnUso') ?? 'EUR')!;
    //Cargar las transacciones desde la base de datos
    await cargarTransacciones();
    notifyListeners();
  }

  ///Cargar las transacciones desde la base de datos, ordenadas por fecha
  Future<void> cargarTransacciones() async {
    listaTransacciones = await TransaccionCRUD().obtenerTransaccionesPorFecha();
    listaTransacciones.sort((a, b) => -a.fecha.compareTo(b.fecha));

    //Cambiar cada importe en función de la divisa que se esté usando --> en esta clase para que sea accesible y recargable desde todo el contexto (la app)
    for (var element in listaTransacciones) {
      if (element.divisaPrincipal != divisaEnUso) {
        Map<String, double> cambios =
            await APIUtils.get_changes(element.divisaPrincipal.codigo_divisa);
        element.importe = element.importe * cambios[divisaEnUso.codigo_divisa]!;
      }
      ;
      
    }
    notifyListeners();
    ;
  }
}
