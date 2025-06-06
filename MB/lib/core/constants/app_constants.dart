import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  AppConstants._();

  static final navigationKey = GlobalKey<NavigatorState>();

  static final String _apiBaseUrl =
      dotenv.env['API_URL'] ?? 'https://localhost:5098';
  static final String _apiProvinces = dotenv.env['API_PROVINCES'] ??
      'https://provinces.open-api.vn/api/?depth=2';

  static final String _cloudinaryUrl = dotenv.env['CLOUDINARY_URL'] ?? '';

  static final String _socketUrl =
      dotenv.env['SOCKET_URL'] ?? 'https://localhost:5001';


  static String socketUrl = _socketUrl;
  static String cloudinaryUrl = _cloudinaryUrl;
  static String apiBaseUrl = _apiBaseUrl;
  static String apiProvinces = _apiProvinces;

  static const String appName = 'Pickelball App';

  static const String LANGUAGE_EN = "en";
  static const String LANGUAGE_VI = "vi";

  static final RegExp emailRegex = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.([a-zA-Z]{2,})+",
  );

  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$#!%*?&_])[A-Za-z\d@#$!%*?&_].{7,}$',
  );
}
