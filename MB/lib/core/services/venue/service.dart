import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/services/venue/dto/venues_response.dart';
import 'package:pickleball_app/core/services/venue/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/venue/interface.dart';

class VenueService implements IVenueService {
  @override
  Future<List<VenuesResponse>> getAllVenues() async {
    try {
      final response = await globalApiService.get(Endpoints.getAllVenues);
      final listVenues = response['data'] as List;
      return listVenues.map((json) => VenuesResponse.fromJson(json)).toList();
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }

  @override
  Future<VenuesResponse> getVenueById(int id) async {
    try {
      final response =
          await globalApiService.get('${Endpoints.getVenueById}/$id');
      return VenuesResponse.fromJson(response['data']);
    } catch (e) {
      throw ErrorHandler.handleApiError(e, 'en');
    }
  }
}
