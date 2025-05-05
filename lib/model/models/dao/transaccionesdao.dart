import 'package:proyecto2eva_budget/model/services/apicambiodivisa.dart';
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
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  ///Consulta para obtener ingresos/gastos por categoría para las estadísticas
  Future<List<Map<String, dynamic>>> obtenerIngresosGastosPorCategoria({
    String filter = 'all',
    String? year,
    required String tipoTransaccion,
    required String actualCode,
  }) async {
    List<Map<String, dynamic>> totalPorCategoria = [];

    final db = await dbHelper.abrirBD();

    String whereClause = '';

    if (filter == 'year' && year != null) {
      whereClause = 'AND strftime("%Y", TRANSACCION.fecha) = $year';
    }

    final categorias = await db.rawQuery(
      """
    SELECT CATEGORIA.nombre, CATEGORIA.colorcategoria
    FROM CATEGORIA
    WHERE CATEGORIA.tipo = '$tipoTransaccion'
    """,
    );
    
    for (var categoria in categorias) {
      final result = await db.rawQuery("""SELECT * FROM TRANSACCION WHERE categoria = '${categoria["nombre"]}' $whereClause""",);
      var total = 0.0;
      for (var line in result) {
        double valor = double.parse(line["importe"].toString());
        if (line["divisaPrincipal"] != actualCode) {
          var mapa =
              (await APIUtils.get_changes(line["divisaPrincipal"].toString()));
          valor = valor * mapa[actualCode]!;
        }
        total += valor;
      }
      if(total != 0) {
        totalPorCategoria.add({
        'nombre': categoria["nombre"],
        'color': categoria["colorcategoria"],
        'total': total,
      });
      }
      
    }
    return totalPorCategoria;
    //devolver lista de mapa de categoria (key) y total (value) y color
  }

  ///Consulta para obtener el balance de los movimientos
  Future<double> obtenerTotalPorTipo(
      {required String tipo,
      String filter = 'all',
      String? year,
      required String actualCode}) async {
    final db = await dbHelper.abrirBD();

    String whereClause = '';
    List<String> whereArgs = [tipo];

    if (filter == 'year' && year != null) {
      whereClause = 'AND strftime("%Y", TRANSACCION.fecha) = ?';
      whereArgs.add(year);
    }

    final result = await db.rawQuery("""
    SELECT *
    FROM TRANSACCION
    INNER JOIN CATEGORIA ON TRANSACCION.categoria = CATEGORIA.nombre
    WHERE CATEGORIA.tipo = ?
    $whereClause
  """, whereArgs);

    var total = 0.0;
    for (var line in result) {
      double valor = double.parse(line["importe"].toString());
      if (line["divisaPrincipal"] != actualCode) {
        var mapa =
            (await APIUtils.get_changes(line["divisaPrincipal"].toString()));
        valor = valor * mapa[actualCode]!;
      }
      total += valor;
    }
    return total;
  }
}
