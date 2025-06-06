import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/services/player/endpoints/endpoints.dart';
import 'package:pickleball_app/core/services/player/index.dart';

class PlayerService implements IPlayerService {
  PlayerService();

  @override
  Future<CreatePlayerResponse> createPlayer(CreatePlayerRequest request) async {
    final response =
        await globalApiService.post(Endpoint.createPlayer, request.toJson());
    return CreatePlayerResponse.fromJson(response['data']);
  }
}
