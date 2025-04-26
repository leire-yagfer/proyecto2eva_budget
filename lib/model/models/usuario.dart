///Clase que representa un usuario
class Usuario {
  final int id;
  final String correoUsuario;
  final String contrasena;

  Usuario({
    required this.id,
    required this.correoUsuario,
    required this.contrasena,
  });

  //Método para convertir un mapa (de la base de datos) a un objeto Usuario
  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      correoUsuario: map['correo_usuario'],
      contrasena: map['contraseña'],
    );
  }

  //Método para convertir un objeto Usuario a un mapa (para insertar en la base de datos)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'correo_usuario': correoUsuario,
      'contraseña': contrasena,
    };
  }
}