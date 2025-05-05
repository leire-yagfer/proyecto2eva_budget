import 'package:proyecto2eva_budget/model/models/divisa.dart';
import 'package:proyecto2eva_budget/model/services/apicambiodivisa.dart';

///Clase que representa una transacción
class Transaccion {
  final int id;
  final String tituloTransaccion;
  final String fecha;
  final String categoria;
  double importe;
  final Divisa divisaPrincipal;
  final String? descripcion;
  final int idUsuario;

  Transaccion({
    required this.id,
    required this.tituloTransaccion,
    required this.fecha,
    required this.categoria,
    required this.importe,
    required this.divisaPrincipal,
    this.descripcion,
    required this.idUsuario,
  });

  //Método para convertir un mapa (de la base de datos) a un objeto Transaccion
  factory Transaccion.fromMap(Map<String, dynamic> map) {
    return Transaccion(
      id: map['id'],
      tituloTransaccion: map['titulo_transaccion'],
      fecha: map['fecha'],
      categoria: map['categoria'],
      importe: map['importe'],
      divisaPrincipal:  APIUtils.getFromList(map['divisaPrincipal'])!, //divisa en la que se trabaja
      descripcion: map['descripcion'],
      idUsuario: map['id_usuario'],
    );
  }

  //Método para convertir un objeto Transaccion a un mapa (para insertar en la base de datos) -> sin el id porque es autoIncrement
  Map<String, dynamic> toMap() {
    return {
      'titulo_transaccion': tituloTransaccion,
      'fecha': fecha,
      'categoria': categoria,
      'importe': importe,
      'divisaPrincipal': divisaPrincipal.codigo_divisa,
      'descripcion': descripcion,
      'id_usuario': idUsuario,
    };
  }
}