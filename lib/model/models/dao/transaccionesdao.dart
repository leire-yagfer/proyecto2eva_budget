import 'package:proyecto2eva_budget/model/services/db_helper.dart';
import 'package:sqflite/sqflite.dart';

///Clase que gestiona transacciones en la base de datos
class TransaccionDao {
  final DBHelper dbHelper = DBHelper();

  ///Método para insertar una transacción
  Future<int> insertarTransaccion(Map<String, dynamic> transaccion) async {
    final db = await dbHelper.abrirBD();
    return await db.insert(
      'TRANSACCION',
      transaccion,
      conflictAlgorithm:
          ConflictAlgorithm.replace, 
    );
  }

  ///Consulta para obtener ingresos por categoría
  Future<List<Map<String, dynamic>>> obtenerIngresosPorCategoria({
    String filter = 'all',
    String? year,
  }) async {
    final db = await dbHelper.abrirBD();

    String whereClause = '';
    List<String> whereArgs = [];

    if (filter == 'year' && year != null) {
      whereClause = 'AND strftime("%Y", TRANSACCION.fecha) = ?';
      whereArgs.add(year);
    }

    return await db.rawQuery("""
    SELECT CATEGORIA.nombre, CATEGORIA.colorcategoria, SUM(TRANSACCION.importe) as total
    FROM TRANSACCION
    INNER JOIN CATEGORIA ON TRANSACCION.categoria = CATEGORIA.nombre
    WHERE CATEGORIA.tipo = 'Ingreso'
    $whereClause
    GROUP BY CATEGORIA.nombre
  """, whereArgs);
  }

  ///Consulta para obtener gastos por categoría
  Future<List<Map<String, dynamic>>> obtenerGastosPorCategoria({
    String filter = 'all',
    String? year,
  }) async {
    final db = await dbHelper.abrirBD();

    String whereClause = '';
    List<String> whereArgs = [];

    if (filter == 'year' && year != null) {
      whereClause = 'AND strftime("%Y", TRANSACCION.fecha) = ?';
      whereArgs.add(year);
    }

    return await db.rawQuery("""
    SELECT CATEGORIA.nombre, CATEGORIA.colorcategoria, SUM(TRANSACCION.importe) as total
    FROM TRANSACCION
    INNER JOIN CATEGORIA ON TRANSACCION.categoria = CATEGORIA.nombre
    WHERE CATEGORIA.tipo = 'Gasto'
    $whereClause
    GROUP BY CATEGORIA.nombre
  """, whereArgs);
  }

  ///Consulta para obtener el balance de los movimientos
  Future<double> obtenerTotalPorTipo({
    required String tipo,
    String filter = 'all',
    String? year,
  }) async {
    final db = await dbHelper.abrirBD();

    String whereClause = '';
    List<String> whereArgs = [tipo];

    if (filter == 'year' && year != null) {
      whereClause = 'AND strftime("%Y", TRANSACCION.fecha) = ?';
      whereArgs.add(year);
    }

    final result = await db.rawQuery("""
    SELECT SUM(importe) as total 
    FROM TRANSACCION
    INNER JOIN CATEGORIA ON TRANSACCION.categoria = CATEGORIA.nombre
    WHERE CATEGORIA.tipo = ?
    $whereClause
  """, whereArgs);

    return result.first['total'] != null
        ? (result.first['total'] as num).toDouble()
        : 0.0;
  }
}