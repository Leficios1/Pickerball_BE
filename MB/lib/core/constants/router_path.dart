class RouterPath {
  static const String createRoom = '/api/match';
  static const String getAllRooms = '/api/match';
  static const String getRoomById =
      '/api/match/'; // Add `/id` when calling the function
  static const String getAllRoomPrivate = '/api/match/private';
  static const String getAllRoomByUserId =
      '/api/match/user/'; // Add `/id` when calling the function

  static const String getAllRanks = '/api/rank';

  static const String onboarding = '/';
  static const String mainNavigation = '/main-navigation';

  static const String homeScreen = 'home-screen';
  static const String rankScreen = 'rank-screen';
  static const String matchScreen = '/match-screen';
  static const String tournamentScreen = 'tournament-screen';

  static const String createMatchScreen = '/create-match-screen';
  static const String quickMatchScreen = '/quick-match-screen';

  static const String pairingsScreen = '/pairings-screen';
  static const String settingScreen = 'setting-screen';
  static const String authenticationScreen = '/authentication-screen';

  static const String singlesPage = '/singles-page';
  static const String doublesPage = '/doubles-page';
  static const String contactUsPage = '/contact-us';
  static const String profilePage = '/profile-page';
  static const String friendPage = '/friend-page';
  static const String privacyPolicyPage = '/privacy-policy-page';
  static const String termsOfService = '/terms-of-service';
  static const String notificationPage = '/notification-page';

  static const String instructionPage = '/instruction-page';
  static const String createdRoomPage = '/created-room-page';
  static const String matchRoomPage = '/match-room-page';
  static const String invitePlayerPage = '/invite-player-page';
  static const String registerRolePage = '/register-role-page';

  static const String matchDetailScreen = '/match-detail-screen';

  static const String tournamentManageScreen = 'tournament-manage-screen';

  static const String tournamentPendingScreen = '/tournament-pending-screen';
  static const String tournamentDetailPage = '/tournament-detail-page';
  static const String tournamentCreatePage = '/tournament-create-page';
  static const String tournamentPolicyPage = '/tournament-policy-page';
  static const String tournamentJoinPage = '/tournament-join-page';

  static const String blogCategory = '/blog-category';
  static const String blogRuleDetail = '/blog-rule-detail';

  static const String paymentPage = '/payment-page';

  static const String paymentSuccessPage = '/payment-success-page';

  static const String endMatchPage = '/end-match-page';

  static const String selectPaymentMethod = '/select-payment-method';
}
