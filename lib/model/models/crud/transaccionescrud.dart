import 'package:proyecto2eva_budget/model/services/db_helper.dart';
import '../transaccion.dart';
import 'package:sqflite/sqflite.dart';

///Clase que gestiona las transacciones en la base de datos
class TransaccionCRUD {
  DBHelper db = DBHelper();

  ///Obtener las transacciones ordenadas por fecha
  Future<List<Transaccion>> obtenerTransaccionesPorFecha() async {
    Database db = await DBHelper().abrirBD();
    List<Map<String, dynamic>> maps = await db.query(
      'TRANSACCION',
      orderBy: 'fecha ASC', //ordeno por fecha en orden ascendente
    );

    return List.generate(maps.length, (i) {
      return Transaccion.fromMap(maps[i]);
    });
  }

  ///Eliminar una transacción por ID
  Future<void> eliminarTransaccion(int id) async {
    Database database = await db.abrirBD(); //abre la base de datos
    await database.delete(
      'TRANSACCION', //el nombre de la tabla
      where: 'id = ?', //filtro para eliminar la transacción por ID
      whereArgs: [id], //el argumento que contiene el ID de la transacción
    );
    print('TRANSACCIÓN con id $id eliminada');
  }

  ///Actualizar una transacción existente en la base de datos
  Future<void> actualizarTransaccion(Transaccion transaccion) async {
    final db = await DBHelper().abrirBD(); //Abro la base de datos
    await db.update(
      'transacciones', //Nombre de la tabla
      transaccion.toMap(), //Datos actualizados como mapa
      where: 'id = ?', //Condición de actualización
      whereArgs: [transaccion.id], //ID de la transacción a actualizar
    );
  }
}
