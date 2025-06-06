import 'package:pickleball_app/core/services/venue/dto/venues_response.dart';

abstract class IVenueService {
  Future<VenuesResponse> getVenueById(int id);

  Future<List<VenuesResponse>> getAllVenues();
}
