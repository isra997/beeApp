import 'dart:convert';

class Datos {
    num dato;
    String fecha;
    String? nombre;
    String?  id;

    Datos({
        required this.dato,
        required this.fecha,
        required this.nombre,
    });

    factory Datos.fromJson(String str) => Datos.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory Datos.fromMap(Map<String, dynamic> json) => Datos(
        dato: json["dato"],
        fecha: json["fecha"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toMap() => {
        "dato": dato,
        "fecha": fecha,
        "nombre": nombre,
    };
}
