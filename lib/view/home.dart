// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:proyecto2eva_budget/view/categorias.dart';
import 'package:proyecto2eva_budget/view/estadisticas/estadisticas.dart';
import 'package:proyecto2eva_budget/view/movimientos.dart';
import 'package:proyecto2eva_budget/view/principal.dart';
import 'package:proyecto2eva_budget/viewmodel/provider_ajustes.dart';
import 'package:proyecto2eva_budget/viewmodel/themeprovider.dart';

//Clase que define la distribución de la app
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  //Lista de pantallas para la barra de navegación
  final List<Widget> _screens = [
    Principal(),
    Movimientos(),
    Estadisticas(),
    Categorias(),
  ];

  @override
  Widget build(BuildContext context) {
    final ajustesProvider =
        Provider.of<ProviderAjustes>(context); //Obtener los ajustes actuales
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'MONEYTRACKER',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          //Botón para cambiar entre modo oscuro y modo claro
          IconButton(
            icon: Icon(
              ajustesProvider.modoOscuro
                  ? Icons.nightlight_round //Icono modo oscuro
                  : Icons.wb_sunny, //Icono modo claro
            ),
            onPressed: () {
              context.read<ThemeProvider>().changeThemeMode(); //cambio modo en ThemeProvider
            },
          ),
          //Dropdown para cambiar el idioma
          DropdownButton<String>(
            value: ajustesProvider.idioma.languageCode, //Idioma actual
            onChanged: (String? nuevoIdioma) {
              if (nuevoIdioma != null) {
                ajustesProvider.cambiarIdioma(nuevoIdioma); //Cambiar el idioma
              }
            },
            items: const [
              DropdownMenuItem(value: 'es', child: Text('Español')),
              DropdownMenuItem(value: 'en', child: Text('English')),
            ],
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: context
            .watch<ThemeProvider>()
            .palette()['selectedItem']!, //Color del ítem seleccionado
        unselectedItemColor: context
            .watch<ThemeProvider>()
            .palette()['unselectedItem']!, //Color de los ítems no seleccionados
        backgroundColor: Theme.of(context)
            .bottomNavigationBarTheme
            .backgroundColor, //Color de fondo de la barra de navegación
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home), //Pantalla principal
          BottomNavigationBarItem(
              icon: const Icon(Icons.swap_horiz),
              label: AppLocalizations.of(context)!
                  .movements), //Pantalla de movimientos
          BottomNavigationBarItem(
              icon: Icon(Icons.equalizer),
              label: AppLocalizations.of(context)!
                  .stadistics), //Pantalla de estadísticas
          BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: AppLocalizations.of(context)!
                  .categories), //Pantalla de categorías
        ],
      ),
    );
  }
}
