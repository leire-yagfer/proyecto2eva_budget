import 'package:proyecto2eva_budget/model/models/categoria.dart';
import 'package:sqflite/sqflite.dart';

///Clase que gestiona las categorías en la base de datos
class CategoriaDao {
  ///Obtener todas las categorías
  Future<List<Categoria>> obtenerCategorias(Database db) async {
    final List<Map<String, dynamic>> maps = await db.query('CATEGORIA');

    return List.generate(maps.length, (i) {
      return Categoria.fromMap(maps[i]);
    });
  }

  ///Obtener una categoría por nombre
  Future<Categoria?> obtenerCategoriaPorNombre(
      Database db, String nombre) async {
    List<Map<String, dynamic>> resultado = await db.query(
      'CATEGORIA',
      where: 'nombre = ?',
      whereArgs: [nombre],
    );

    if (resultado.isNotEmpty) {
      return Categoria.fromMap(resultado.first);
    } else {
      return null; //no se encuentra la categoría
    }
  }

  ///Obtener categoría por tipo
  Future<List<Categoria>> obtenerCategoriasPorTipo(
      Database db, String tipo) async {
    final List<Map<String, dynamic>> maps = await db.query(
      'CATEGORIA',
      where: 'tipo = ?',
      whereArgs: [tipo],
    );

    return List.generate(maps.length, (i) {
      return Categoria(
        nombre: maps[i]['nombre'],
        icono: maps[i]['icono'],
        tipo: maps[i]['tipo'],
        colorcategoria: maps[i]['colorcategoria'],
      );
    });
  }
}