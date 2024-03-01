import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDtiU9JlFsayDQMkLPPUygGUJO-Nb8PcgQ';

  final storage = const FlutterSecureStorage();
  Future<String?> createUser(
      {required String email,
      required String password,
      String? nombres,
      String? numero}) async {
    // ... register user with email and password

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> respDecoded = jsonDecode(resp.body);

    if (respDecoded.containsKey('idToken')) {
      // save token in device storage
      await storage.write(key: 'token', value: respDecoded['idToken']);
      // print(storage.read(key: 'token'));
      return null;
    } else {
      return respDecoded['error']['message'];
    }
  }

  Future<String?> signInUser(
      {required String email,
      required String password,
      String? nombres,
      String? numero}) async {
    // ... register user with email and password

    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
    };

    final url = Uri.https(_baseUrl, '/v1/accounts:signInWithPassword', {
      'key': _firebaseToken,
    });

    final resp = await http.post(url, body: json.encode(authData));

    final Map<String, dynamic> respDecoded = jsonDecode(resp.body);

    // print(respDecoded);

    if (respDecoded.containsKey('idToken')) {
      // save token in device storage
      await storage.write(key: 'token', value: respDecoded['idToken']);
      // print(storage.read(key: 'token'));
      return null;
    } else {
      return respDecoded['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    await storage.delete(key: 'nombre');
  }

  Future<String> readToken() async {
    // print(keyLogin.toString());
    return await storage.read(key: 'token') ?? '';
  }
}
