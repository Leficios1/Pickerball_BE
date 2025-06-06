import 'package:pickleball_app/core/language/en.dart';
import 'package:pickleball_app/core/language/vi.dart';

class ErrorConstants {
  static String networkError(String locale) {
    return locale == 'vi'
        ? AppStringsVi.translations['network_error']!
        : AppStringsEn.translations['network_error']!;
  }

  static String unknownError(String locale) {
    return locale == 'vi'
        ? AppStringsVi.translations['unknown_error']!
        : AppStringsEn.translations['unknown_error']!;
  }
}
