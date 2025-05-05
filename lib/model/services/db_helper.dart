import 'dart:io';

import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

///Clase que maneja la conexión y las operaciones sobre la base de datos
class DBHelper {
  ///Abrir la base de datos o crearla si no existe
  Future<Database> abrirBD() async {
    if(Platform.isWindows||Platform.isMacOS){
      databaseFactory = databaseFactoryFfi;
    }else{
      databaseFactory = databaseFactory;
    }
    
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'transacciones.db');
    print(path); //útil para ver la base de datos
    //await deleteDatabase(path);

    //Abrir la base de datos y crear las tablas
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
      CREATE TABLE IF NOT EXISTS USUARIO (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        correo_usuario TEXT NOT NULL,
        contraseña TEXT NOT NULL
      )
      ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS CATEGORIA (
        nombre TEXT PRIMARY KEY,
        icono TEXT NOT NULL,
        tipo TEXT NOT NULL CHECK (tipo IN ('Ingreso', 'Gasto')),
        colorcategoria TEXT NOT NULL
      )
      ''');

      await db.execute('''
      CREATE TABLE IF NOT EXISTS TRANSACCION (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo_transaccion TEXT NOT NULL,
        fecha DATE NOT NULL,
        categoria TEXT NOT NULL,
        importe REAL NOT NULL,
        divisaPrincipal TEXT NOT NULL,
        descripcion TEXT,
        id_usuario INTEGER NOT NULL,
        FOREIGN KEY (categoria) REFERENCES CATEGORIA (nombre) ON DELETE CASCADE,
        FOREIGN KEY (id_usuario) REFERENCES USUARIO (id) ON DELETE CASCADE
      )
      ''');

      //Categorías de gastos predeterminadas
      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Vivienda',
            'icono': 'house',
            'tipo': 'Gasto',
            'colorcategoria': '#ffffcc'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Alimentación',
            'icono': 'shopping_cart',
            'tipo': 'Gasto',
            'colorcategoria': '#ffcccc'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Ocio',
            'icono': 'shopping_bag',
            'tipo': 'Gasto',
            'colorcategoria': '#ffccff'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Transporte',
            'icono': 'directions_car',
            'tipo': 'Gasto',
            'colorcategoria': '#ccccff'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Cuidado personal',
            'icono': 'self_improvement',
            'tipo': 'Gasto',
            'colorcategoria': '#ccffff'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Educación',
            'icono': 'book',
            'tipo': 'Gasto',
            'colorcategoria': '#ccffcc'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);


      //Categorías de ingresos predeterminadas
      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Salario',
            'icono': 'money',
            'tipo': 'Ingreso',
            'colorcategoria': '#ffcc99'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Regalos',
            'icono': 'card_giftcard',
            'tipo': 'Ingreso',
            'colorcategoria': '#ff99cc'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Reembolso',
            'icono': 'attach_money',
            'tipo': 'Ingreso',
            'colorcategoria': '#cc99ff'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Becas',
            'icono': 'monetization_on',
            'tipo': 'Ingreso',
            'colorcategoria': '#99ccff'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'CATEGORIA',
          {
            'nombre': 'Otros',
            'icono': 'more_horiz',
            'tipo': 'Ingreso',
            'colorcategoria': '#99ffcc'
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      //Insertar transacciones
      await db.insert(
          'TRANSACCION',
          {
            'titulo_transaccion': 'Compra',
            'fecha': '2025-02-04',
            'categoria': 'Alimentación',
            'importe': 50.0,
            'divisaPrincipal': 'EUR',
            'descripcion': 'Compra en supermercado',
            'id_usuario': 1
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'TRANSACCION',
          {
            'titulo_transaccion': 'Salario mensual',
            'fecha': '2025-02-03',
            'categoria': 'Salario',
            'importe': 1200.0,
            'divisaPrincipal': 'EUR',
            'descripcion': 'Compra en supermercado',
            'id_usuario': 1
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'TRANSACCION',
          {
            'titulo_transaccion': 'Beca estudiante',
            'fecha': '2025-02-03',
            'categoria': 'Becas',
            'importe': 300.0,
            'divisaPrincipal': 'EUR',
            'descripcion': 'Beca por ser estudiante',
            'id_usuario': 1
          },
          conflictAlgorithm: ConflictAlgorithm.replace);

      await db.insert(
          'TRANSACCION',
          {
            'titulo_transaccion': 'Gimnasio',
            'fecha': '2024-02-03',
            'categoria': 'Cuidado personal',
            'importe': 40.0,
            'divisaPrincipal': 'EUR',
            'descripcion': 'Recibo mensual gimnasio',
            'id_usuario': 1
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }
}