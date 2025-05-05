// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto2eva_budget/model/models/crud/transaccionescrud.dart';
import 'package:proyecto2eva_budget/viewmodel/provider_ajustes.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/models/transaccion.dart';
import '../model/models/dao/categoriadao.dart';
import '../model/services/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Clase que muestra todos los movimientos/transacciones que se han almacenado en la base de datos
class Movimientos extends StatefulWidget {
  const Movimientos({super.key});

  @override
  _MovimientosState createState() => _MovimientosState();
}

class _MovimientosState extends State<Movimientos> {
  TransaccionCRUD transaccionCRUD = TransaccionCRUD();
  CategoriaDao categoriaDao = CategoriaDao();
  late Database db;

  @override
  void initState() {
    super.initState();
  }

  ///Obtener el color de la categoría -> se usa paa el fondo de las card
  Future<Color> obtenerColorCategoria(String categoriaNombre) async {
    db = await DBHelper().abrirBD();
    var categoria = await categoriaDao.obtenerCategoriaPorNombre(
        db, categoriaNombre); //Obtengo la categoría por nombre
    return categoria != null
        ? _obtenerColor(
            categoria.colorcategoria) //Obtengo el color de la categoría
        : context.watch<ThemeProvider>().palette()['fixedBlack']!;
  }

  ///Obtener el tipo de la categoría (Ingreso o Gasto)
  Future<String> obtenerTipoCategoria(String categoriaNombre) async {
    db = await DBHelper().abrirBD();
    var categoria =
        await categoriaDao.obtenerCategoriaPorNombre(db, categoriaNombre);
    return categoria?.tipo ?? 'Gasto';
  }

  ///Convertir color hexadecimal a Color
  Color _obtenerColor(String colorHex) {
    if (colorHex.startsWith('#')) {
      return Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } else {
      return context.watch<ThemeProvider>().palette()['fixedBlack']!;
    }
  }

  ///Eliminar una transacción
  Future<void> _eliminarTransaccion(int id, int index) async {
    await transaccionCRUD.eliminarTransaccion(id);
    context.read<ProviderAjustes>().listaTransacciones.removeAt(index);
    context.read<ProviderAjustes>().notifyListeners();
  }

  ///Formatear la fecha para mostrarla de forma legible
  String _formatearFecha(String fecha) {
    try {
      DateTime fechaParseada = DateTime.parse(fecha);
      return DateFormat('dd/MM/yyyy')
          .format(fechaParseada); // Formato: 07/02/2025
    } catch (e) {
      return fecha; // Si no se puede formatear, mostrar la fecha original
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Transaccion> transacciones =
        context.watch<ProviderAjustes>().listaTransacciones;
    return Scaffold(
      body: transacciones.isEmpty
          ? Center(
              child: Text(
                AppLocalizations.of(context)!.noTransactions,
                style: TextStyle(
                    fontSize: MediaQuery.of(context).textScaler.scale(18),
                    fontWeight: FontWeight.w600),
              ),
            )
          : ListView.builder(
              itemCount: transacciones.length,
              itemBuilder: (context, index) {
                Transaccion transaccion = transacciones[index];

                //Llamo a los métodos para obtener el color de la categoría y el tipo
                return FutureBuilder<Color>(
                  future: obtenerColorCategoria(transaccion.categoria),
                  builder: (context, colorSnapshot) {
                    if (colorSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    }
                    Color categoriaColor = colorSnapshot.data ??
                        context.watch<ThemeProvider>().palette()['fixedBlack']!;

                    return FutureBuilder<String>(
                      future: obtenerTipoCategoria(transaccion.categoria),
                      builder: (context, tipoSnapshot) {
                        if (tipoSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        String tipoCategoria = tipoSnapshot.data ?? 'Gasto';
                        Color fechaEImporteColor;
                        Icon icono;
                        if (tipoCategoria == 'Ingreso') {
                          fechaEImporteColor = context
                              .watch<ThemeProvider>()
                              .palette()['greenButton']!; //Verde
                          icono = Icon(Icons.arrow_upward,
                              color: fechaEImporteColor);
                        } else {
                          fechaEImporteColor = context
                              .watch<ThemeProvider>()
                              .palette()['redButton']!; //Rojo
                          icono = Icon(Icons.arrow_downward,
                              color: fechaEImporteColor);
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.012,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.015),
                          color:
                              categoriaColor, //Color de fondo de la tarjeta según categoría
                          child: ListTile(
                            onTap: () =>
                                _mostrarDetalleEditable(transaccion, index),
                            contentPadding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            leading: icono, //Flecha hacia arriba o hacia abajo
                            title: Text(
                              transaccion.tituloTransaccion,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: context
                                    .watch<ThemeProvider>()
                                    .palette()['fixedBlack']!,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${AppLocalizations.of(context)!.date}: ${_formatearFecha(transaccion.fecha)}",
                                  style: TextStyle(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .palette()['fixedBlack']!),
                                ),
                                Text(
                                  "${AppLocalizations.of(context)!.category}: ${transaccion.categoria}",
                                  style: TextStyle(
                                      color: context
                                          .watch<ThemeProvider>()
                                          .palette()['fixedBlack']!),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${transaccion.importe.toStringAsFixed(2)} ${context.watch<ProviderAjustes>().divisaEnUso.simbolo_divisa}', //Importe con símbolo de la divisa en uso
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: MediaQuery.of(context)
                                        .textScaler
                                        .scale(14),
                                    color:
                                        fechaEImporteColor, //Importe con color según tipo
                                  ),
                                ),
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                IconButton(
                                  icon: Icon(Icons.delete,
                                      color: context
                                          .watch<ThemeProvider>()
                                          .palette()['fixedBlack']!),
                                  iconSize:
                                      MediaQuery.of(context).size.width * 0.05,
                                  onPressed: () {
                                    _eliminarTransaccion(transaccion.id, index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }

  void _mostrarDetalleEditable(Transaccion transaccion, int index) {
    TextEditingController tituloController =
        TextEditingController(text: transaccion.tituloTransaccion);
    TextEditingController importeController =
        TextEditingController(text: transaccion.importe.toString());
    TextEditingController fechaController =
        TextEditingController(text: transaccion.fecha);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.editTransaction),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: tituloController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.title),
                ),
                TextField(
                  controller: importeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.amount),
                ),
                TextField(
                  controller: fechaController,
                  decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.date),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppLocalizations.of(context)!.cancel),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.accept),
              onPressed: () async {
                try {
                  double nuevoImporte = double.parse(importeController.text);
                  Transaccion transaccionModificada = Transaccion(
                    id: transaccion.id,
                    tituloTransaccion: tituloController.text,
                    categoria: transaccion.categoria,
                    importe: nuevoImporte,
                    fecha: fechaController.text,
                    divisaPrincipal: context
                        .read()<ProviderAjustes>()
                        .divisaEnUso
                        .codigo_divisa,
                    idUsuario: 1,
                  );

                  await transaccionCRUD
                      .actualizarTransaccion(transaccionModificada);

                  context.read<ProviderAjustes>().listaTransacciones[index] =
                      transaccionModificada;
                  context.read<ProviderAjustes>().notifyListeners();

                  Navigator.of(context).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(AppLocalizations.of(context)!
                            .errorUpdatingTransaction)),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
