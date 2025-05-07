import 'package:proyecto2eva_budget/model/models/categoria.dart';
import 'package:proyecto2eva_budget/model/models/divisa.dart';
import 'package:proyecto2eva_budget/model/services/apicambiodivisa.dart';

///Clase que representa una transacción
class Transaccion {
  final int id;
  final String tituloTransaccion;
  final DateTime fecha;
  final Divisa divisa;
  final Categoria categoria;
  double importe;
  final String? descripcion;
  //No se necesita el usuario porque está en el provider y todo loq ue se haga se guarda en su sesión

  Transaccion({
    required this.id,
    required this.tituloTransaccion,
    required this.fecha,
    required this.divisa,
    required this.categoria,
    required this.importe,
    this.descripcion,
  });

  //a aprtir de un mapa creo una transacción
  static Transaccion fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'],
      tituloTransaccion: map['tituloTransaccion'],
      fecha: map['fecha'],
      divisa: APIUtils.getFromList(map['divisa'])!,
      categoria: Categoria.fromMap(map['categoria']),
      importe: map['importe'],
      descripcion: map['descripcion'],
    );
  }

   Map<String, dynamic> toMap() {
    return {
      'currency': divisa.codigo_divisa,
      'datetime': fecha,
      'description': descripcion,
      'import': importe,
      'title': tituloTransaccion
    };
  }
}
