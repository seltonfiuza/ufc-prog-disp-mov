import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  bool _loggedIn = false;
  String _key = 'trab02_loggedIn';

  // Auth() {
  //   this._loggedIn = _read();
  // }

  getLoggedIn() {
    return this._loggedIn;
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getBool(this._key);
    return value ?? false;
  }

  setLogged(username, password, save) async {
    if (save) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(this._key, true);
    }
    this._loggedIn = true;
    return true;
  }

  _logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(this._key, false);
    print('Logged out');
  }

  clear() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(this._key, false);
    print('Desativado o logging automático');
  }
}
