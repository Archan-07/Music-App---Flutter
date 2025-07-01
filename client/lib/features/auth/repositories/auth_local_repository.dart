import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'auth_local_repository.g.dart';

@Riverpod(keepAlive: true)
AuthLocalRepository authLocalRepository(Ref ref) {
  return AuthLocalRepository();
}

class AuthLocalRepository {
  // Make it nullable and initialize in the constructor or init method
  SharedPreferences? _sharedPreferences;

  // Add a getter to ensure initialization before access
  Future<SharedPreferences> get _prefs async {
    if (_sharedPreferences == null) {
      await init();
    }
    return _sharedPreferences!;
  }

  Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  Future<void> setToken(String? token) async {
    // Make it async
    final prefs = await _prefs; // Await initialization
    if (token != null) {
      prefs.setString('x-auth-token', token);
    }
  }

  String? getToken() {
    return _sharedPreferences?.getString('x-auth-token');
  }
}
