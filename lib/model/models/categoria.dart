///Clase que representa una categoría
class Categoria {
  final String nombre;
  final String icono;
  final String tipo;
  final String colorcategoria;

  Categoria({
    required this.nombre,
    required this.icono,
    required this.tipo,
    required this.colorcategoria
  });

  //Método para convertir un mapa (de la base de datos) a un objeto Categoria
  factory Categoria.fromMap(Map<String, dynamic> map) {
    return Categoria(
      nombre: map['nombre'],
      icono: map['icono'],
      tipo: map['tipo'],
      colorcategoria: map['colorcategoria']
    );
  }

  //Método para convertir un objeto Categoria a un mapa (para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'icono': icono,
      'tipo': tipo,
      'colorcategoria': colorcategoria
    };
  }
}