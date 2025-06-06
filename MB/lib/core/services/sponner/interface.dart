import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/sponner/dto/sponner_request.dart';

abstract class ISponnerService {
  Future<Sponner> createSponner(SponnerRequest sponnerRequest);

  Future<Sponner> getSponnerById(int sponnerId);

  Future<Sponner> updateSponner(SponnerRequest sponnerRequest);
}
