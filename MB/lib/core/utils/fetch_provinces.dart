import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pickleball_app/core/constants/app_constants.dart';

class ProvinceService {
  Future<List<dynamic>> fetchProvinces() async {
    final response = await http.get(Uri.parse(AppConstants.apiProvinces));
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception("Failed to load provinces");
    }
  }
}
