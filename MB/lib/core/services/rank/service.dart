import 'package:pickleball_app/core/constants/app_global.dart';
import 'package:pickleball_app/core/constants/router_path.dart';
import 'package:pickleball_app/core/errors/error_handler.dart';
import 'package:pickleball_app/core/models/models.dart';
import 'package:pickleball_app/core/services/rank/dto/rank_response.dart';
import 'package:pickleball_app/core/services/rank/interface.dart';

class RankService implements IRankService {
  RankService();

  @override
  Future<List<Rankings>> getRanking() async {
    try {
      final response = await globalApiService.get(RouterPath.getAllRanks);
      final rankResponse = RankResponse.fromJson(response);
      return rankResponse.data;
    } catch (error) {
      throw ErrorHandler.handleApiError(error);
    }
  }
}
