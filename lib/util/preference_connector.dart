import 'package:shared_preferences/shared_preferences.dart';

class PreferenceConnector {
  static const USER_ID = 'user_id';
  static const X_API_KEY = 'x_api_key';
  static const EMAIL = 'emil';
  static const PASSWORD = 'password';
  static const REMEMBER_ME = 'remember_me';
  static const REMEMBER_ME_STATUS = 'remember_me_status';
  static const DEVICE_ID = 'device_id';
  static const LOGIN_DATE_TIME = 'login_date_time';
  static const USER_TYPE = 'user_type';

  _getSharedPreference() async {
    return await SharedPreferences.getInstance();
  }

  Future<String> getString(String key) async {
    SharedPreferences prefs = await _getSharedPreference();
    return prefs.getString(key) ?? '';
  }

  Future<int> getInt(String key) async {
    SharedPreferences prefs = await _getSharedPreference();
    return prefs.getInt(key) ?? -1;
  }

  Future<bool> getBool(String key) async {
    SharedPreferences prefs = await _getSharedPreference();
    return prefs.getBool(key) ?? false;
  }

  void setString(String key, String value) async {
    SharedPreferences prefs = await _getSharedPreference();
    prefs.setString(key, value);
  }

  void setInt(String key, int value) async {
    SharedPreferences prefs = await _getSharedPreference();
    prefs.setInt(key, value);
  }

  void setBool(String key, bool value) async {
    SharedPreferences prefs = await _getSharedPreference();
    prefs.setBool(key, value);
  }

  void clearAll()async{
    SharedPreferences prefs = await _getSharedPreference();
    prefs.clear();
  }
}
