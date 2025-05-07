import 'package:proyecto2eva_budget/model/models/usuario.dart';
import 'package:proyecto2eva_budget/model/services/db_helper.dart';
import 'package:proyecto2eva_budget/model/services/firebasedb.dart';
import '../transaccion.dart';
import 'package:sqflite/sqflite.dart';

///Clase que gestiona las transacciones en la base de datos
class TransaccionCRUD {
  DBHelper db = DBHelper();

  ///Obtener las transacciones ordenadas por fecha
  Future<List<Transaccion>> obtenerTransaccionesPorFecha(Usuario u) async {
    List<Transaccion> allTransacciones = [];
    var userdata = await Firebasedb.data.doc(u.id).get(); //obtengo el usuario

    var categories = await userdata.reference
        .collection('categories')
        .get(); //obtengo las categorias

    //obtengo las transacciones de cada categoria
    for (var c in categories.docs) {
      var transacciones = await c.reference.collection('transacciones').get();
      for (var t in transacciones.docs) {
        var transaccion = t.data();
        transaccion["id"] =
            t.id; //le paso el ID de la transacción pq no lo pasa directamente
        transaccion["categoria"] = c
            .data(); //le paso todos los datos que implica la categoria a la que pertenece dicha transacción
        transaccion["categoria"]["id"] =
            c.id; //le paso el ID de la categoria pq no lo pasa directamente

        allTransacciones.add(Transaccion.fromMap(transaccion)); //método transacción que se encarga de crear la transacción a partir del mapa
      }
    }
    return allTransacciones;
  }

  ///Eliminar una transacción por ID
  Future<void> eliminarTransaccion(int id) async {
    Database database = await db.abrirBD(); //abre la base de datos
    await database.delete(
      'TRANSACCION', //el nombre de la tabla
      where: 'id = ?', //filtro para eliminar la transacción por ID
      whereArgs: [id], //el argumento que contiene el ID de la transacción
    );
  }
}
