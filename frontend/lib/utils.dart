import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class Utils {
  static const FlutterSecureStorage storage = FlutterSecureStorage();
  static var token = storage.read(key: "token");
  static var clearToken = storage.delete(key: "token");

  static void saveToken(String token) async {
    await storage.write(key: "token", value: token);
  }
}
