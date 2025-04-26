import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proyecto2eva_budget/model/models/crud/transaccionescrud.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';
import 'package:sqflite/sqflite.dart';
import '../model/models/transaccion.dart';
import '../model/models/dao/categoriadao.dart';
import '../model/services/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

///Clase que muestra todos los movimientos/transacciones que se han almacenado en la base de datos
class Movimientos extends StatefulWidget {
  @override
  _MovimientosState createState() => _MovimientosState();
}

class _MovimientosState extends State<Movimientos> {
  TransaccionCRUD transaccionCRUD = TransaccionCRUD();
  CategoriaDao categoriaDao = CategoriaDao();
  List<Transaccion> transacciones = [];
  late Database db;

  @override
  void initState() {
    super.initState();
    _cargarTransacciones(); //Inicio con los movimientos cargados
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

  ///Cargar las transacciones desde la base de datos, ordenadas por fecha
  Future<void> _cargarTransacciones() async {
    List<Transaccion> lista =
        await transaccionCRUD.obtenerTransaccionesPorFecha();
    lista.sort((a, b) => -a.fecha.compareTo(b.fecha));
    setState(() {
      transacciones = lista;
    });
  }

  ///Eliminar una transacción
  Future<void> _eliminarTransaccion(int id, int index) async {
    await transaccionCRUD.eliminarTransaccion(id);
    setState(() {
      transacciones.removeAt(index);
    });
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
                            contentPadding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.01),
                            leading: icono, //Flecha hacia arriba o hacia abajo
                            title: Text(
                              "${transaccion.tituloTransaccion}",
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
                                  '${transaccion.importe.toStringAsFixed(2)}€',
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
}