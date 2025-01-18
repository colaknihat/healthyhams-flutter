import 'package:http/http.dart' as http;
import 'dart:convert';

class EdamamApiHelper {
  static const String _appId = '895769bc';
  static const String _appKey = '70d86f3b74e95e3cf57ee395b375a386';
  static const String _baseUrl = 'https://api.edamam.com/api/nutrition-data';

  //https://api.edamam.com/api/nutrition-data?app_id=895769bc&app_key=70d86f3b74e95e3cf57ee395b375a386&ingr=500grams%20of%20steak

  static Future<Map<String, dynamic>?> fetchFoodNutrition(String foodName) async {
    final Uri url = Uri.parse(_baseUrl)
        .replace(queryParameters: {
          'app_id': _appId,
          'app_key': _appKey,
          'ingr': foodName,
        });
        

    try {
      print(url);
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return jsonData;
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return null;
      }
    } catch (e) {
      print('Error fetching nutrition data: $e');
      return null;
    }
  }
}