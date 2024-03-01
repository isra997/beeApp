import 'dart:convert';

import 'package:app1/models/data_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataService extends ChangeNotifier {
  final String _baseUrl = 'flutter-app-3481c-default-rtdb.firebaseio.com';

  final List<Datos> datos = [];
  List<Datos> datosPersonalizados = [];

  double prom = 0;
  double prom2 = 0;
  double promFinal = 0;

  double sumaTotal = 0;
  double sumaTotal2 = 0;
  double sumaFinal = 0;

  bool isLoading = true;

  DataService() {
    loadData();
    loadDataSpecific();
  }

  Future<List<Datos>> loadData() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'data.json');
    final resp = await http.get(url);

    final Map<String, dynamic> dataMap = json.decode(resp.body);
    sumaTotal = 0;

    dataMap.forEach((key, value) {
      final temp = Datos.fromMap(value);
      sumaTotal += value['dato'];
      temp.id = key;
      datos.add(temp);
    });

    prom = double.parse((sumaTotal / dataMap.length).toStringAsFixed(2));

    isLoading = false;
    notifyListeners();

    return datos;
  }

  Future<List<Datos>> loadDataSpecific(
      {DateTime? startDate, DateTime? endDate}) async {
    final year1 = startDate?.year ?? 0;
    final month1 = startDate?.month ?? 0;
    final day1 = startDate?.day ?? 0;
    final year2 = endDate?.year ?? 0;
    final month2 = endDate?.month ?? 0;
    final day2 = endDate?.day ?? 0;
    DateTime fecha1 = DateTime.utc(year1, month1, day1);
    DateTime fecha2 = DateTime.utc(year2, month2, day2);
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'data.json');
    final resp = await http.get(url);

    final List<Datos> loadedData = [];
    final Map<String, dynamic> dataMap = json.decode(resp.body);
    sumaTotal = 0;
    sumaTotal2 = 0;
    sumaFinal = 0;

    dataMap.forEach((key, value) {
      final temp = Datos.fromMap(value);
      sumaTotal += value['dato'];
      temp.id = key;

      // Filtrar por fecha
      final dataDate = _parseDate(temp.fecha);

      if ((startDate == null ||
              dataDate.isAfter(fecha1) ||
              dataDate.isAtSameMomentAs(fecha1)) &&
          (endDate == null ||
              dataDate.isBefore(fecha2) ||
              dataDate.isAtSameMomentAs(fecha2))) {
        sumaTotal2 += value['dato'];
        loadedData.add(temp);
      }
    });

    loadedData
        .sort((a, b) => _parseDate(a.fecha).compareTo(_parseDate(b.fecha)));

    datosPersonalizados = loadedData;

    prom = double.parse((sumaTotal / dataMap.length).toStringAsFixed(2));
    prom2 = double.parse((sumaTotal / dataMap.length).toStringAsFixed(2));

    if (startDate != null && endDate != null) {
      promFinal =
          double.parse((sumaTotal2 / loadedData.length).toStringAsFixed(2));
      sumaFinal = double.parse(sumaTotal2.toStringAsFixed(2));
    } else {
      promFinal = prom2;
      sumaFinal = double.parse((sumaTotal).toStringAsFixed(2));
    }
    isLoading = false;
    notifyListeners();

    return datosPersonalizados;
  }

  static DateTime _parseDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);
      return DateTime.utc(year, month, day);
    } else {
      throw FormatException("Invalid date format: $dateString");
    }
  }
}
