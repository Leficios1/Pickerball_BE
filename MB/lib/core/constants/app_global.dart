import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:pickleball_app/core/config/api/api_service.dart';
import 'package:pickleball_app/core/context/authentication.dart';
import 'package:pickleball_app/core/context/user_info_storage.dart';
import 'package:pickleball_app/core/services/blog_category/service.dart';
import 'package:pickleball_app/core/services/cloudinary/cloudinary_service.dart';
import 'package:pickleball_app/core/services/pay_os/service.dart';
import 'package:pickleball_app/core/services/player_registration/index.dart';
import 'package:pickleball_app/core/services/room/index.dart';
import 'package:pickleball_app/core/services/room/service.dart';
import 'package:pickleball_app/core/services/services.dart';
import 'package:pickleball_app/core/services/tournament_team_request/service.dart';

final FlutterSecureStorage globalStorage = const FlutterSecureStorage();

final SecureTokenService globalTokenService =
    SecureTokenService(storage: globalStorage);

final UserInfoStorage globalUserInfoStorage =
    UserInfoStorage(storage: globalStorage);

final ApiService globalApiService = ApiService(
  client: http.Client(),
);

final AuthService globalAuthService = AuthService();

final UserService globalUserService = UserService();

final RoomService globalRoomService = RoomService();

final RankService globalRankService = RankService();

final PlayerService globalPlayerService = PlayerService();

final MatchService globalMatchService = MatchService();

final TournamentService globalTournamentService = TournamentService();

final SponnerService globalSponnerService = SponnerService();

final FriendService globalFriendService = FriendService();

final VenueService globalVenueService = VenueService();

final MatchSendRequestService globalMatchSendRequestService =
    MatchSendRequestService();

final PlayerRegistrationService globalPlayerRegistrationService =
    PlayerRegistrationService();

final BlogCategoryService globalBlogCategoryService = BlogCategoryService();

final PaymentService globalPaymentService = PaymentService();

final TournamentTeamService globalTournamentTeamService =
    TournamentTeamService();
final RankingService globalRankingService = RankingService();
final CloudinaryService globalCloudinaryService = CloudinaryService();
final PayOsService globalPayOsService = PayOsService();

final ValueNotifier<ThemeMode> globalThemeMode = ValueNotifier(ThemeMode.light);
