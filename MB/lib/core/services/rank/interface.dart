import 'package:pickleball_app/core/models/models.dart';

abstract class IRankService {
  Future<List<Rankings>> getRanking();
}
