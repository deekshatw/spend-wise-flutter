import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static String sharedPreferenceUserNameKey = 'USER_NAME_KEY';
  static String sharedPreferenceUserEmailKey = 'USER_EMAIL_KEY';
  static String sharedPreferenceUserIdKey = 'USER_ID_KEY';
  static String sharedPreferenceUserTokenKey = 'USER_TOKEN_KEY';
  static String sharedPreferenceUserProfileKey = 'USER_PROFILE_KEY';

  /// storing data in shared preferences (Local Storage)
  static Future<bool> saveUsernameSharedPreference(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserNameKey, username);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserIdSharedPreference(int userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(sharedPreferenceUserIdKey, userId);
  }

  static Future<bool> saveUserTokenSharedPreference(String userToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserTokenKey, userToken);
  }

  static Future<bool> saveUserProfileSharedPreference(
      String userProfile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(sharedPreferenceUserProfileKey, userProfile);
  }

  ///getting data from shared preferences (Local Storage)
  static Future<String?> getUsernameSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserEmailKey);
  }

  static Future<int?> getUserIdSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(sharedPreferenceUserIdKey);
  }

  static Future<String?> getUserTokenSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserTokenKey);
  }

  static Future<String?> getUserProfileSharedPreference() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(sharedPreferenceUserProfileKey);
  }

  /// Clearing all data from shared preferences (Local Storage)
  static Future<void> clearUserSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(sharedPreferenceUserNameKey);
    await prefs.remove(sharedPreferenceUserEmailKey);
    await prefs.remove(sharedPreferenceUserIdKey);
    await prefs.remove(sharedPreferenceUserTokenKey);
    await prefs.remove(sharedPreferenceUserProfileKey);
  }
}
