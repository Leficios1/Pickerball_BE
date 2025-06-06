import 'package:pickleball_app/core/services/player/dto/dto.dart';

abstract class IPlayerService {
  Future<CreatePlayerResponse> createPlayer(CreatePlayerRequest request);
}
