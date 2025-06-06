import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/sponner.dart';
import 'package:pickleball_app/core/services/sponner/dto/sponner_request.dart';
import 'package:pickleball_app/core/services/sponner/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/sponner/interface.dart';

class SponnerService implements ISponnerService {
  @override
  Future<Sponner> createSponner(SponnerRequest sponnerRequest) async {
    try {
      final response = await globalApiService.post(
          Endpoints.createSponner, sponnerRequest.toJson());
      Sponner sponner = Sponner.fromJson(response['data']);
      return sponner;
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }

  @override
  Future<Sponner> getSponnerById(int sponnerId) async {
    try {
      final response =
          await globalApiService.get('${Endpoints.getSponnerById}/$sponnerId');
      Sponner sponner = Sponner.fromJson(response['data']);
      return sponner;
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }

  @override
  Future<Sponner> updateSponner(SponnerRequest sponnerRequest) async {
    try {
      final response = await globalApiService.put(
          Endpoints.updateSponner, sponnerRequest.toJson());
      Sponner sponner = Sponner.fromJson(response['data']);
      return sponner;
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }
}
