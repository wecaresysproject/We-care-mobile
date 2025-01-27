import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences
      sharedPreferences; //* this is way of applying composition concept on oop

//! Here The Initialize of sharedPrefrences .
  init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

//! this method to get value of specific key from local database only return astring data type

  String? getDataString({
    required String key,
  }) {
    return sharedPreferences.getString(key);
  }

//! this method to put data in local database using key and value

  Future<bool> saveData({required String key, required dynamic value}) async {
    if (value is bool) {
      return await sharedPreferences.setBool(key, value);
    } else if (value is String) {
      return await sharedPreferences.setString(key, value);
    } else if (value is int) {
      return await sharedPreferences.setInt(key, value);
    } else {
      return await sharedPreferences.setDouble(key, value);
    }
  }

//! this method to get data already saved in local database

  dynamic getData({required String key}) {
    return sharedPreferences.get(key);
  }

//! remove data using specific key

  Future<bool> removeData({required String key}) async {
    return await sharedPreferences.remove(key);
  }

//! this method to check if local database contains {key}
  Future<bool> containsKey({required String key}) async {
    return sharedPreferences.containsKey(key);
  }

//TODO : search when to use it later ..
//! clear all data in the local database
  Future<bool> clearData() async {
    return await sharedPreferences.clear();
  }

// //! this method to put data in local database using key
//   Future<dynamic> put({
//     required String key,
//     required dynamic value,
//   }) async {
//     if (value is String) {
//       return await sharedPreferences.setString(key, value);
//     } else if (value is bool) {
//       return await sharedPreferences.setBool(key, value);
//     } else {
//       return await sharedPreferences.setInt(key, value);
//     }
//   }
}
