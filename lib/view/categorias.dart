import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto2eva_budget/model/models/dao/categoriadao.dart';
import 'package:proyecto2eva_budget/model/services/db_helper.dart';
import 'package:proyecto2eva_budget/reusable/categorycard.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:proyecto2eva_budget/model/models/categoria.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Clase que muestra las categorías almacenadas en la base de datos
class Categorias extends StatefulWidget {
  @override
  _CategoriasState createState() => _CategoriasState();
}

class _CategoriasState extends State<Categorias> {
  late Database db;
  List<Categoria> categorias = [];
  CategoriaDao categoriaDao = CategoriaDao();

  @override
  void initState() {
    super.initState();
    _cargarCategorias(); //Cargar categorías
  }

  ///Método para cargar las categorías desde la base de datos
  Future<void> _cargarCategorias() async {
    db = await DBHelper().abrirBD();
    List<Categoria> categoriasDB =
        await categoriaDao.obtenerCategorias(db); //Lista de objetos Categoria
    setState(() {
      categorias = categoriasDB; //Actualiza la lista con los objetos Categoria
    });
  }

  ///Método para obtener el icono correspondiente según el nombre del icono -> alamcenado en la BD con nombre concretos de iconos accesibles
  IconData obtenerIcono(String iconName) {
    switch (iconName) {
      //GASTOS
      case 'house':
        return Icons.house;
      case 'shopping_cart':
        return Icons.shopping_cart;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'directions_car':
        return Icons.directions_car;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'book':
        return Icons.book;

      //INGRESOS
      case 'money':
        return Icons.money;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'attach_money':
        return Icons.attach_money;
      case 'monetization_on':
        return Icons.monetization_on;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.help_outline; //Icono por defecto
    }
  }

  ///Método para convertir un color hexadecimal a un objeto Color de Flutter
  Color obtenerColor(String colorHex) {
    if (colorHex.startsWith('#')) {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } else {
      return context.watch<ThemeProvider>().palette()['fixedBlack']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    //Se separan las categorías en dos listas: una para ingresos y otra para gastos
    List<Categoria> ingresos =
        categorias.where((categoria) => categoria.tipo == 'Ingreso').toList();
    List<Categoria> gastos =
        categorias.where((categoria) => categoria.tipo == 'Gasto').toList();

    

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (ingresos.isNotEmpty)
              CategoryCard(
                title: AppLocalizations.of(context)!.income,
                categorias: ingresos,
                categoryColor: obtenerColor,
                categoryIcon: obtenerIcono,
              ),
            if (gastos.isNotEmpty)
              CategoryCard(
                title: AppLocalizations.of(context)!.expenses,
                categorias: gastos,
                categoryColor: obtenerColor,
                categoryIcon: obtenerIcono,
              ),
          ],
        ),
      ),
    );
  }
}